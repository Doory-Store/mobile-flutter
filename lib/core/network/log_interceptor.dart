import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'redaction.dart';

/// Debug-only request log. Every header, body and URL passes through
/// [redaction] first, so the console shows the shape of a call without its
/// secrets. [buildDio] installs it only when `kDebugMode` is true; release
/// builds carry no network logging at all.
class RedactingLogInterceptor extends Interceptor {
  RedactingLogInterceptor({void Function(String line)? sink})
    : _sink = sink ?? ((line) => debugPrint(line));

  final void Function(String line) _sink;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _sink(
      '→ ${options.method} ${redactUri(options.uri)} '
      'headers=${redactHeaders(options.headers)}'
      '${options.data == null ? '' : ' body=${redactBody(options.data)}'}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _sink('← ${response.statusCode} ${redactUri(response.requestOptions.uri)}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _sink(
      '✕ ${err.response?.statusCode ?? err.type.name} '
      '${redactUri(err.requestOptions.uri)}'
      '${err.response?.data == null ? '' : ' body=${redactBody(err.response?.data)}'}',
    );
    handler.next(err);
  }
}
