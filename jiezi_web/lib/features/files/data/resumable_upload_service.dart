import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:jiezi_api/jiezi_api.dart';

/// Orchestrates a resumable chunked upload to `POST /api/v1/upload/*`.
///
/// Wraps [ResumableUploadClient] with the higher-level logic:
/// - Computes the SHA-256 hash required by the server for integrity checking
///   and instant-complete deduplication.
/// - Slices [Uint8List] into server-negotiated chunks.
/// - Handles the prepare → chunk loop → complete lifecycle.
class ResumableUploadService {
  const ResumableUploadService(this._client);

  final ResumableUploadClient _client;

  /// Uploads [bytes] as a new file named [fileName] under the VFS directory
  /// identified by [parentId].
  ///
  /// Returns the newly created [FileNode] on success.  If the server already
  /// has a file with the same content (instant-complete dedup), the existing
  /// [FileNode] is returned without transmitting any bytes.
  Future<FileNode> upload({
    required String parentId,
    required String fileName,
    required Uint8List bytes,
    String mimeType = 'application/octet-stream',
  }) async {
    final contentHash = sha256.convert(bytes).toString();

    final resp = await _client.prepare(
      UploadPrepareRequest(
        parentId: parentId,
        fileName: fileName,
        totalSize: bytes.length,
        contentHash: contentHash,
        mimeType: mimeType,
      ),
    );

    // Instant-complete: same content already exists in storage.
    if (resp.instantComplete) return resp.fileNode!;

    // Upload every chunk sequentially.  The server validates exact sizes so
    // slicing must respect the negotiated chunk_size for all but the last chunk.
    final chunkSize = resp.chunkSize;
    for (var i = 0; i < resp.chunkCount; i++) {
      final start = i * chunkSize;
      final end = (start + chunkSize).clamp(0, bytes.length);
      await _client.uploadChunk(resp.sessionId, i, bytes.sublist(start, end));
    }

    return _client.complete(resp.sessionId);
  }
}
