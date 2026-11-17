import 'package:dio/dio.dart';

enum ApiFailureKind {
  notFound,
  validation,
  unauthorized,
  forbidden,
  rateLimited,
  network,
  server,
  unknown,
}

class ApiException implements Exception {
  const ApiException(this.kind, this.message, {this.statusCode});

  final ApiFailureKind kind;
  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($kind, $statusCode, $message)';
}

/// In-flight call cancelled because the route was disposed or replaced.
class ApiCancelled implements Exception {
  const ApiCancelled();
}

String messageFromBody(Object? data) {
  if (data is Map) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) return message.trim();
  }
  return '';
}

ApiException mapDioException(DioException error) {
  if (error.type == DioExceptionType.cancel) {
    throw const ApiCancelled();
  }
  final code = error.response?.statusCode;
  final message = messageFromBody(error.response?.data);
  if (code == 404) {
    return ApiException(ApiFailureKind.notFound, message, statusCode: code);
  }
  if (code == 400 || code == 422) {
    return ApiException(ApiFailureKind.validation, message, statusCode: code);
  }
  if (code == 401) {
    return ApiException(ApiFailureKind.unauthorized, message, statusCode: code);
  }
  if (code == 403) {
    return ApiException(ApiFailureKind.forbidden, message, statusCode: code);
  }
  if (code == 429) {
    return ApiException(ApiFailureKind.rateLimited, message, statusCode: code);
  }
  if (code != null && code >= 500) {
    return ApiException(ApiFailureKind.server, message, statusCode: code);
  }
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return ApiException(ApiFailureKind.network, message, statusCode: code);
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.cancel:
      break;
  }
  if (error.type == DioExceptionType.unknown && error.response == null) {
    return ApiException(ApiFailureKind.network, message, statusCode: code);
  }
  return ApiException(ApiFailureKind.unknown, message, statusCode: code);
}
