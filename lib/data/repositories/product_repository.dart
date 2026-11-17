import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_transport.dart';
import '../demo/demo_data.dart';
import '../models/buyer_dto.dart';
import '../models/catalog_models.dart';
import 'repo_result.dart';

class ProductRepository {
  ProductRepository(this._transport, this._config);

  final ApiTransport _transport;
  final AppConfig _config;

  Future<RepoResult<ProductDetailModel>> fetch(
    int id, {
    CancelToken? cancelToken,
  }) {
    return runRequest<ProductDetailModel>(
      hasBaseUrl: _config.hasBaseUrl,
      demo: () => DemoData.product(id),
      request: () async {
        final raw = await _transport.get(
          '/products/$id',
          cancelToken: cancelToken,
        );
        if (raw is! Map) throw const FormatException('product');
        final detail = mapDetail(
          ProductDetailDto.fromJson(Map<String, dynamic>.from(raw)),
        );
        if (detail == null) throw const FormatException('product');
        return detail;
      },
    );
  }
}
