import 'dart:convert';
import 'dart:typed_data';

import 'package:gio/gio.dart';

import '../models/file_node.dart';
import 'upload_models.dart';

/// HTTP client for the resumable chunked upload API.
///
/// ## Protocol
///
/// 1. [prepare] — send file metadata + SHA-256 hash; receive [UploadPrepareResponse].
///    If [UploadPrepareResponse.instantComplete] is `true` the file already exists
///    in storage; skip straight to step 4.
/// 2. [uploadChunk] — upload each chunk by index (idempotent; safe to retry).
/// 3. [status] — optionally query which chunks are still missing (useful when
///    resuming an interrupted upload).
/// 4. [complete] — trigger server-side assembly; returns the new [FileNode].
/// 5. [cancel] — optional early abort; cleans up temporary chunk files.
///
/// All requests are authenticated via the [Gio] interceptor chain (the
/// [BearerTokenInterceptor] injects the `Authorization` header automatically).
class ResumableUploadClient {
  /// Creates a [ResumableUploadClient].
  ///
  /// [gio] is shared with the rest of the app's API clients so that all
  /// interceptors (auth, token-refresh, error mapping) are applied uniformly.
  ResumableUploadClient(Gio gio, {String? baseUrl})
    : _gio = gio,
      _baseUrl = baseUrl;

  final Gio _gio;
  final String? _baseUrl;

  String get _base => _baseUrl ?? '';

  // ── Helpers ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _postJson(
    String path, [
    Map<String, dynamic>? body,
  ]) async {
    final response = await _gio.post('$_base$path', jsonBody: body);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _getJson(String path) async {
    final response = await _gio.get('$_base$path');
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// `POST /api/v1/upload/prepare` — create a session or instant-complete.
  Future<UploadPrepareResponse> prepare(UploadPrepareRequest req) async {
    final json = await _postJson('/api/v1/upload/prepare', req.toJson());
    return UploadPrepareResponse.fromJson(json);
  }

  /// `GET /api/v1/upload/{sessionId}/status` — list missing chunk indices.
  Future<UploadSessionStatus> status(String sessionId) async {
    final json = await _getJson('/api/v1/upload/$sessionId/status');
    return UploadSessionStatus.fromJson(json);
  }

  /// `POST /api/v1/upload/{sessionId}/chunk/{index}` — upload a single chunk.
  ///
  /// [bytes] must be exactly `chunk_size` bytes for every chunk except the
  /// last, which may be smaller.  Re-uploading a chunk is idempotent.
  Future<UploadSessionStatus> uploadChunk(
    String sessionId,
    int index,
    Uint8List bytes,
  ) async {
    final uri = Uri.parse('$_base/api/v1/upload/$sessionId/chunk/$index');
    final request = Request('POST', uri)
      ..bodyBytes = bytes
      ..headers['Content-Type'] = 'application/octet-stream';

    final streamed = await _gio.send(request);
    final bodyBytes = await streamed.stream.toBytes();
    final body = utf8.decode(bodyBytes);

    return UploadSessionStatus.fromJson(
      jsonDecode(body) as Map<String, dynamic>,
    );
  }

  /// `POST /api/v1/upload/{sessionId}/complete` — assemble chunks, store, and
  /// create the VFS record.
  ///
  /// Returns the new [FileNode].  Throws if any chunks are still missing or if
  /// the SHA-256 hash does not match the value supplied in [prepare].
  Future<FileNode> complete(String sessionId) async {
    final json = await _postJson('/api/v1/upload/$sessionId/complete');
    return FileNode.fromJson(json);
  }

  /// `DELETE /api/v1/upload/{sessionId}` — cancel the session and remove
  /// temporary chunk files.
  Future<void> cancel(String sessionId) async {
    await _gio.delete('$_base/api/v1/upload/$sessionId');
  }
}
