/// Sealed hierarchy of domain-level errors surfaced throughout the app.
///
/// All repository implementations catch raw HTTP / serialisation exceptions and
/// re-throw as one of these variants so that the presentation layer never has
/// to depend on network internals.
sealed class AppError implements Exception {
  const AppError({required this.message});

  /// Human-readable description (safe to display in UI after localisation).
  final String message;

  @override
  String toString() => 'AppError($message)';
}

/// The server returned an HTTP error response (4xx / 5xx).
final class ServerError extends AppError {
  const ServerError({required this.statusCode, required super.message});

  final int statusCode;

  /// Whether the caller should retry the request.
  bool get isRetryable => statusCode >= 500;
}

/// A network-level failure (no connectivity, timeout, DNS, …).
final class NetworkError extends AppError {
  const NetworkError({super.message = 'Network unavailable'});
}

/// The local token cache does not hold a valid session.
final class UnauthorizedError extends AppError {
  const UnauthorizedError({super.message = 'Session expired'});
}

/// A generic / unexpected error that does not fit other categories.
final class UnknownError extends AppError {
  const UnknownError({super.message = 'An unexpected error occurred'});
}
