import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_transport.dart';
import '../demo/demo_data.dart';
import '../models/buyer_dto.dart';
import '../models/catalog_models.dart';
import 'repo_result.dart';

class StoreRepository {
  StoreRepository(this._transport, this._config);

  final ApiTransport _transport;
  final AppConfig _config;

  Future<RepoResult<StoreModel>> fetch(
    String slug, {
    CancelToken? cancelToken,
    bool allowGenericDemo = true,
  }) {
    return runRequest<StoreModel>(
      hasBaseUrl: _config.hasBaseUrl,
      demo: () {
        if (!allowGenericDemo && slug != 'furn-al-yasmin') return null;
        return DemoData.store(slug);
      },
      request: () async {
        final raw = await _transport.get(
          '/stores/$slug',
          cancelToken: cancelToken,
        );
        if (raw is! Map) throw const FormatException('store');
        final store = mapStore(
          StoreDto.fromJson(Map<String, dynamic>.from(raw)),
        );
        if (store == null) throw const FormatException('store');
        return store;
      },
    );
  }
}
