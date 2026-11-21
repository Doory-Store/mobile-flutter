import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/network/api_transport.dart';
import '../demo/demo_data.dart';
import '../models/buyer_dto.dart';
import '../models/catalog_models.dart';
import '../models/product_query.dart';
import 'repo_result.dart';

class CatalogRepository {
  CatalogRepository(this._transport, this._config);

  final ApiTransport _transport;
  final AppConfig _config;

  Future<RepoResult<List<CategoryNode>>> categories({
    CancelToken? cancelToken,
  }) {
    return runRequest<List<CategoryNode>>(
      hasBaseUrl: _config.hasBaseUrl,
      demo: () => DemoData.categories,
      request: () async {
        final raw = await _transport.get(
          '/categories',
          cancelToken: cancelToken,
        );
        return buildCategoryTree(decodeCategoryList(raw));
      },
    );
  }

  Future<RepoResult<ProductPage>> products(
    ProductsQuery query, {
    String? categorySlug,
    CancelToken? cancelToken,
  }) {
    final params = query.toQuery(search: false);
    if (params == null) {
      return Future.value(const RepoRejected('invalid price range'));
    }
    return runRequest<ProductPage>(
      hasBaseUrl: _config.hasBaseUrl,
      demo: () => DemoData.listingFor(categorySlug),
      request: () async {
        final raw = await _transport.get(
          '/products',
          query: params,
          cancelToken: cancelToken,
        );
        if (raw is! Map) throw const FormatException('products');
        final dto = ProductPageDto.fromJson(Map<String, dynamic>.from(raw));
        final items = mapCards(dto.data);
        return ProductPage(
          items: items,
          meta: mapMeta(
            dto.meta,
            fallbackPage: query.page,
            fallbackPerPage: query.perPage,
            itemCount: items.length,
          ),
        );
      },
    );
  }
}
