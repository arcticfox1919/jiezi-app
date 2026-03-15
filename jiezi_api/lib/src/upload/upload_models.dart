import '../models/file_node.dart';

/// Request body for `POST /upload/prepare`.
class UploadPrepareRequest {
  const UploadPrepareRequest({
    required this.parentId,
    required this.fileName,
    required this.totalSize,
    required this.contentHash,
    this.mimeType,
    this.chunkSize,
    this.skipDedup = false,
  });

  /// ID of the VFS parent directory.
  final String parentId;

  /// Filename to store on the server.
  final String fileName;

  /// Total file size in bytes.
  final int totalSize;

  /// SHA-256 hex digest of the complete file (used for dedup and integrity).
  final String contentHash;

  /// Optional MIME type hint.
  final String? mimeType;

  /// Preferred chunk size in bytes.  Server may adjust; defaults to 8 MiB.
  final int? chunkSize;

  /// When `true`, skip the instant-complete dedup shortcut.
  final bool skipDedup;

  Map<String, dynamic> toJson() => {
    'parent_id': parentId,
    'file_name': fileName,
    'total_size': totalSize,
    'content_hash': contentHash,
    if (mimeType != null) 'mime_type': mimeType,
    if (chunkSize != null) 'chunk_size': chunkSize,
    'skip_dedup': skipDedup,
  };
}

/// Response body for `POST /upload/prepare`.
class UploadPrepareResponse {
  const UploadPrepareResponse({
    required this.sessionId,
    required this.chunkSize,
    required this.chunkCount,
    required this.instantComplete,
    this.fileNode,
  });

  /// Session identifier — pass to every subsequent request.
  final String sessionId;

  /// Negotiated chunk size in bytes.
  final int chunkSize;

  /// Total number of chunks expected.
  final int chunkCount;

  /// When `true` the file was already present; [fileNode] is populated and
  /// no chunks need to be uploaded.
  final bool instantComplete;

  /// Populated only when [instantComplete] is `true`.
  final FileNode? fileNode;

  factory UploadPrepareResponse.fromJson(Map<String, dynamic> json) =>
      UploadPrepareResponse(
        sessionId: json['session_id'] as String,
        chunkSize: json['chunk_size'] as int,
        chunkCount: json['chunk_count'] as int,
        instantComplete: json['instant_complete'] as bool,
        fileNode: json['file_node'] == null
            ? null
            : FileNode.fromJson(json['file_node'] as Map<String, dynamic>),
      );
}

/// Response body for `GET /upload/{session_id}/status`.
class UploadSessionStatus {
  const UploadSessionStatus({
    required this.sessionId,
    required this.status,
    required this.chunkCount,
    required this.receivedChunks,
    required this.missingChunks,
  });

  final String sessionId;
  final String status;
  final int chunkCount;
  final List<int> receivedChunks;
  final List<int> missingChunks;

  factory UploadSessionStatus.fromJson(Map<String, dynamic> json) =>
      UploadSessionStatus(
        sessionId: json['session_id'] as String,
        status: json['status'] as String,
        chunkCount: json['chunk_count'] as int,
        receivedChunks: (json['received_chunks'] as List)
            .map((e) => e as int)
            .toList(),
        missingChunks: (json['missing_chunks'] as List)
            .map((e) => e as int)
            .toList(),
      );
}
