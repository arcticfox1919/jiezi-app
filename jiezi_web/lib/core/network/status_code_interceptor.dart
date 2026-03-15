import 'dart:convert';

import 'package:gio/gio.dart';

import '../error/api_response_exception.dart';

/// Gio [Interceptor] that converts non-2xx HTTP responses into typed exceptions.
///
/// **Chain position**: register this FIRST (outermost) so that downstream
/// interceptors such as [TokenRefreshInterceptor] still see raw responses and
/// can act on 401 before the exception surfaces to callers:
///
/// ```
/// statusCodeInterceptor         ← throws ApiResponseException on >= 400
///   → TokenRefreshInterceptor   ← intercepts 401, refreshes, retries
///     → BearerTokenInterceptor  ← injects Authorization header
///       → network
/// ```
///
/// **Body handling**: the response body stream is only consumed for error
/// responses (status >= 400). Success responses are returned untouched to
/// preserve streaming semantics for large downloads.
///
/// **JSON parsing**: expects the server's standard error envelope:
/// ```json
/// { "code": 404, "error": "NOT_FOUND", "message": "not found: ..." }
/// ```
/// Falls back to sensible defaults when the body is not valid JSON or the
/// expected fields are absent.
Future<StreamedResponse> statusCodeInterceptor(Chain chain) async {
  final response = await chain.proceed(chain.request);
  if (response.statusCode < 400) return response;

  final bodyBytes = await response.stream.toBytes();
  final bodyStr = utf8.decode(bodyBytes, allowMalformed: true);

  var errorCode = 'UNKNOWN_ERROR';
  var message = 'Request failed with status ${response.statusCode}';

  try {
    final json = jsonDecode(bodyStr) as Map<String, dynamic>;
    final rawError = json['error'];
    if (rawError is String && rawError.isNotEmpty) errorCode = rawError;
    final rawMsg = json['message'];
    if (rawMsg is String && rawMsg.isNotEmpty) message = rawMsg;
  } catch (_) {
    // Body is not JSON — keep default values.
  }

  throw ApiResponseException(
    statusCode: response.statusCode,
    errorCode: errorCode,
    message: message,
  );
}
