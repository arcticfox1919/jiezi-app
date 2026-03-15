import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Handles browser-native file interactions for the web platform.
///
/// Responsibilities:
/// - [pickFile]: opens the OS file picker and reads the selected file.
/// - [triggerSaveDialog]: wraps bytes from [DownloadClient] in a Blob and
///   triggers the browser save dialog.
///
/// HTTP transfers are handled by [ResumableUploadService] (upload) and
/// [DownloadClient] (download) via the shared [Gio] interceptor chain.
///
/// Uses `package:web` (the modern interop layer) instead of the deprecated
/// `dart:html`.
class WebFileTransferService {
  const WebFileTransferService();

  // ── File picker ───────────────────────────────────────────────────────────

  /// Opens the OS file picker and returns the selected file as bytes, name,
  /// and MIME type.  Returns `null` when the user dismisses the picker without
  /// selecting a file.
  Future<({Uint8List bytes, String name, String mimeType})?> pickFile() async {
    final input =
        web.document.createElement('input') as web.HTMLInputElement
          ..type = 'file'
          ..accept = '*/*';
    web.document.body!.append(input);
    final changeFuture = _nextEvent(input, 'change');
    input.click();
    await changeFuture;
    input.remove();

    final files = input.files;
    if (files == null || files.length == 0) return null;

    final file = files.item(0)!;
    final bytes = await _readFileAsBytes(file);
    return (
      bytes: bytes,
      name: file.name,
      mimeType: file.type.isNotEmpty ? file.type : 'application/octet-stream',
    );
  }

  // ── Download ───────────────────────────────────────────────────────────────

  /// Downloads the file and triggers the browser's save dialog.
  ///
  /// [bytes] are the already-fetched file bytes from [DownloadClient].
  /// Wraps them in a Blob, creates a temporary object URL, and triggers
  /// a programmatic anchor-click so the browser shows the save dialog.
  void triggerSaveDialog({
    required Uint8List bytes,
    required String fileName,
  }) {
    final blob = web.Blob([bytes.toJS].toJS);
    final objectUrl = web.URL.createObjectURL(blob);
    final anchor =
        web.document.createElement('a') as web.HTMLAnchorElement
          ..href = objectUrl
          ..download = fileName;
    web.document.body!.append(anchor);
    anchor.click();
    web.URL.revokeObjectURL(objectUrl);
    anchor.remove();
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Reads a [web.File] fully into memory as a [Uint8List].
  Future<Uint8List> _readFileAsBytes(web.File file) async {
    final reader = web.FileReader();
    final completer = Completer<Uint8List>();
    reader.onloadend = (web.Event _) {
      if (reader.error != null) {
        completer.completeError(
          const WebTransferException('Failed to read selected file.'),
        );
      } else {
        final buffer = (reader.result as JSArrayBuffer).toDart;
        completer.complete(buffer.asUint8List());
      }
    }.toJS;
    reader.readAsArrayBuffer(file);
    return completer.future;
  }

  /// Returns a [Future] that completes the next time [target] fires [eventType].
  Future<void> _nextEvent(web.EventTarget target, String eventType) {
    final completer = Completer<void>();
    late JSFunction handler;
    handler = (web.Event _) {
      target.removeEventListener(eventType, handler);
      completer.complete();
    }.toJS;
    target.addEventListener(eventType, handler);
    return completer.future;
  }
}

/// Thrown by [WebFileTransferService] when an upload or download fails.
final class WebTransferException implements Exception {
  const WebTransferException(this.message);

  final String message;

  @override
  String toString() => 'WebTransferException($message)';
}
