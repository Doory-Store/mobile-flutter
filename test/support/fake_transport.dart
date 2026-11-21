import 'package:dio/dio.dart';
import 'package:doory_mobile/core/network/api_transport.dart';

class FakeTransport implements ApiTransport {
  FakeTransport(this.onGet);

  final Future<dynamic> Function(String path, Map<String, dynamic>? query)
  onGet;
  final List<String> calls = [];

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) {
    calls.add(path);
    return onGet(path, query);
  }
}
