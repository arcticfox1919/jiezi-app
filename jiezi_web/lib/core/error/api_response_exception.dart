/// A typed exception raised when the server returns a non-2xx HTTP response.
///
/// Thrown by [StatusCodeInterceptor] after parsing the JSON error body:
/// ```json
/// { "code": 409, "error": "CONFLICT", "message": "conflict: username already taken" }
/// ```
///
/// Repositories catch this and convert it to a domain [AppError] so that the
/// presentation layer never depends on network internals.
final class ApiResponseException implements Exception {
  const ApiResponseException({
    required this.statusCode,
    required this.errorCode,
    required this.message,
  });

  /// HTTP status code (e.g. 404, 409, 422).
  final int statusCode;

  /// Machine-readable error identifier from the server (e.g. `"NOT_FOUND"`).
  final String errorCode;

  /// Human-readable description forwarded from the server response.
  final String message;

  @override
  String toString() =>
      'ApiResponseException($statusCode, $errorCode): $message';
}
