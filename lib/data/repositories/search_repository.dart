import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/network/api_transport.dart';
import '../demo/demo_data.dart';
import '../models/buyer_dto.dart';
import '../models/catalog_models.dart';
import '../models/product_query.dart';
import 'repo_result.dart';

class SearchRepository {
  SearchRepository(this._transport, this._config);

  final ApiTransport _transport;
  final AppConfig _config;

  Future<RepoResult<SearchPage>> search(
    ProductsQuery query, {
    CancelToken? cancelToken,
  }) {
    final params = query.toQuery(search: true);
    if (params == null) {
      if (query.hasEmptySearch) {
        return Future.value(const RepoRejected(DooryStrings.emptySearch));
      }
      return Future.value(const RepoRejected(DooryStrings.invalidRange));
    }
    final q = query.q!.trim();
    return runRequest<SearchPage>(
      hasBaseUrl: _config.hasBaseUrl,
      demo: () => DemoData.searchFor(q),
      request: () async {
        final raw = await _transport.get(
          '/search',
          query: params,
          cancelToken: cancelToken,
        );
        if (raw is! Map) throw const FormatException('search');
        final dto = SearchResponseDto.fromJson(Map<String, dynamic>.from(raw));
        final items = mapCards(dto.data);
        final facets = <CategoryFacet>[
          for (final bucket in dto.facets?.category ?? const <FacetBucketDto>[])
            if (bucket.id != null)
              CategoryFacet(id: bucket.id!, count: bucket.count ?? 0),
        ];
        return SearchPage(
          query: dto.search?.q ?? q,
          items: items,
          meta: mapMeta(
            dto.meta,
            fallbackPage: query.page,
            fallbackPerPage: query.perPage,
            itemCount: items.length,
          ),
          degraded: dto.search?.degraded ?? false,
          categoryFacets: facets,
        );
      },
    );
  }
}
