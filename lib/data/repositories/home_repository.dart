import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_transport.dart';
import '../demo/demo_data.dart';
import '../models/buyer_dto.dart';
import '../models/catalog_models.dart';
import 'repo_result.dart';

class HomeRepository {
  HomeRepository(this._transport, this._config);

  final ApiTransport _transport;
  final AppConfig _config;

  Future<RepoResult<HomeContent>> fetch({CancelToken? cancelToken}) {
    return runRequest<HomeContent>(
      hasBaseUrl: _config.hasBaseUrl,
      demo: () => DemoData.home,
      request: () async {
        final raw = await _transport.get('/home', cancelToken: cancelToken);
        if (raw is! Map) throw const FormatException('home');
        return mapHome(HomeDto.fromJson(Map<String, dynamic>.from(raw)));
      },
    );
  }
}
