import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A canned HTTP reply.
class StubReply {
  const StubReply(this.status, [this.body, this.headers = const {}]);

  final int status;
  final Object? body;
  final Map<String, String> headers;
}

/// Dio adapter that answers from a function and records every request, so
/// interceptors and repositories run end to end without a network.
class StubAdapter implements HttpClientAdapter {
  StubAdapter(this.reply);

  final StubReply Function(RequestOptions options) reply;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final answer = reply(options);
    final text = answer.body == null ? '' : jsonEncode(answer.body);
    return ResponseBody.fromString(
      text,
      answer.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        for (final entry in answer.headers.entries) entry.key: [entry.value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
