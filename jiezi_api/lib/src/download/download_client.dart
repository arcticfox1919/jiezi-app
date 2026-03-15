import 'dart:typed_data';

import 'package:gio/gio.dart';

/// HTTP client for the file download API.
///
/// Fetches raw file bytes from `GET /api/v1/download/{id}`.
///
/// The caller is responsible for presenting the bytes to the user
/// (e.g. triggering a browser save dialog on web, or writing to disk on native).
///
/// All requests are authenticated via the [Gio] interceptor chain.
class DownloadClient {
  /// Creates a [DownloadClient].
  ///
  /// [gio] is shared with the rest of the app's API clients so that all
  /// interceptors (auth, token-refresh, error mapping) are applied uniformly.
  DownloadClient(Gio gio, {String? baseUrl})
      : _gio = gio,
        _baseUrl = baseUrl;

  final Gio _gio;
  final String? _baseUrl;

  String get _base => _baseUrl ?? '';

  /// `GET /api/v1/download/{id}` — fetch the complete file as bytes.
  ///
  /// Returns the raw file content.  Throws if the server returns a non-2xx
  /// status (handled by the StatusCodeInterceptor in the Gio chain).
  Future<Uint8List> downloadFile(String nodeId) async {
    final response = await _gio.get('$_base/api/v1/download/$nodeId');
    return response.bodyBytes;
  }

  /// `GET /api/v1/download/{id}` with a `Range` header.
  ///
  /// Downloads only the bytes in the inclusive range [[start], [end]],
  /// e.g. `start: 0, end: 1023` downloads the first 1024 bytes.
  ///
  /// Returns the partial content bytes.
  Future<Uint8List> downloadRange(String nodeId, int start, int end) async {
    final response = await _gio.get(
      '$_base/api/v1/download/$nodeId',
      headers: {'Range': 'bytes=$start-$end'},
    );
    return response.bodyBytes;
  }
}
