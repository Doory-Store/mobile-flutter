import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import 'api_exception.dart';
import 'log_interceptor.dart';

/// Body, status and headers of a successful call.
class ApiResponse {
  const ApiResponse({
    required this.data,
    required this.statusCode,
    this.headers = const {},
  });

  final dynamic data;
  final int statusCode;

  /// Lower-cased header names.
  final Map<String, List<String>> headers;

  String? header(String name) {
    final values = headers[name.toLowerCase()];
    return values == null || values.isEmpty ? null : values.first;
  }
}

abstract class ApiTransport {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  });

  /// Any verb with a JSON body. Used by authenticated buyer endpoints.
  Future<ApiResponse> send(
    String method,
    String path, {
    Object? body,
    CancelToken? cancelToken,
  });
}

class DioApiTransport implements ApiTransport {
  DioApiTransport(
    this.config, {
    Dio? dio,
    List<Interceptor> interceptors = const [],
  }) : dio = dio ?? buildDio(config, interceptors: interceptors);

  final AppConfig config;
  final Dio dio;

  void close() => dio.close(force: true);

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    if (!config.hasBaseUrl) {
      throw const ApiException(ApiFailureKind.network, 'missing base url');
    }
    try {
      final response = await dio.get<dynamic>(
        path,
        queryParameters: query,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel) {
        throw const ApiCancelled();
      }
      final mapped = error.error;
      if (mapped is ApiException) throw mapped;
      throw mapDioException(error);
    }
  }

  @override
  Future<ApiResponse> send(
    String method,
    String path, {
    Object? body,
    CancelToken? cancelToken,
  }) async {
    if (!config.hasBaseUrl) {
      throw const ApiException(ApiFailureKind.network, 'missing base url');
    }
    try {
      final response = await dio.request<dynamic>(
        path,
        data: body,
        cancelToken: cancelToken,
        options: Options(method: method, contentType: Headers.jsonContentType),
      );
      return ApiResponse(
        data: response.data,
        statusCode: response.statusCode ?? 0,
        headers: {
          for (final entry in response.headers.map.entries)
            entry.key.toLowerCase(): entry.value,
        },
      );
    } on DioException catch (error) {
      if (error.type == DioExceptionType.cancel) {
        throw const ApiCancelled();
      }
      final mapped = error.error;
      if (mapped is ApiException) throw mapped;
      throw mapDioException(error);
    }
  }
}

/// [interceptors] run after the header interceptor and before logging and
/// error mapping, which is where the auth interceptor belongs.
Dio buildDio(AppConfig config, {List<Interceptor> interceptors = const []}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.timeout,
      receiveTimeout: config.timeout,
      sendTimeout: config.timeout,
      responseType: ResponseType.json,
      headers: const {'Accept': 'application/json', 'Accept-Language': 'ar'},
    ),
  );
  dio.interceptors.add(DooryHeaderInterceptor(config));
  dio.interceptors.addAll(interceptors);
  if (kDebugMode) dio.interceptors.add(RedactingLogInterceptor());
  dio.interceptors.add(DooryErrorInterceptor());
  return dio;
}

class DooryHeaderInterceptor extends Interceptor {
  DooryHeaderInterceptor(this.config);

  final AppConfig config;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    options.headers['Accept-Language'] = 'ar';
    options.connectTimeout = config.timeout;
    options.receiveTimeout = config.timeout;
    options.sendTimeout = config.timeout;
    if (config.baseUrl.isNotEmpty) {
      options.baseUrl = config.baseUrl;
    }
    handler.next(options);
  }
}

class DooryErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.cancel || err.error is ApiException) {
      handler.next(err);
      return;
    }
    final mapped = mapDioException(err);
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
        message: mapped.message,
      ),
    );
  }
}
