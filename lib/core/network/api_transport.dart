import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'api_exception.dart';

abstract class ApiTransport {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  });
}

class DioApiTransport implements ApiTransport {
  DioApiTransport(this.config, {Dio? dio}) : dio = dio ?? buildDio(config);

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
}

Dio buildDio(AppConfig config) {
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
