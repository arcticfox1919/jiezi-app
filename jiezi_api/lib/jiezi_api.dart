/// Jiezi Cloud API client library.
///
/// Exports both the code-generated REST clients ([JieziClient] and its
/// sub-clients) and the hand-written [ResumableUploadClient] for chunked
/// file uploads.
library;

// Generated clients and data classes.
export 'src/export.dart';

// Hand-written: resumable chunked-upload API.
export 'src/upload/upload_models.dart';
export 'src/upload/resumable_upload_client.dart';

// Hand-written: file download API.
export 'src/download/download_client.dart';
