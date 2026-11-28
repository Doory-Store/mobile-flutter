import 'package:dio/dio.dart';
import 'package:doory_mobile/core/config/app_config.dart';
import 'package:doory_mobile/core/format/price_format.dart';
import 'package:doory_mobile/core/network/api_exception.dart';
import 'package:doory_mobile/data/models/buyer_dto.dart';
import 'package:doory_mobile/data/models/catalog_models.dart';
import 'package:doory_mobile/data/models/product_query.dart';
import 'package:doory_mobile/data/repositories/repo_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('compact counts use Latin digits and ألف / مليون', () {
    expect(formatCompactCount(12), contains('12'));
    expect(formatCompactCount(1247), contains('1.2 ألف'));
    expect(formatCompactCount(1000), contains('1 ألف'));
    expect(formatCompactCount(1200000), contains('1.2 مليون'));
  });

  test('base URL drops a trailing slash', () {
    expect(
      AppConfig.normalizeBaseUrl('https://doory.elogyc.com/api/v1/'),
      'https://doory.elogyc.com/api/v1',
    );
    expect(AppConfig.normalizeBaseUrl('  '), '');
  });

  test('price uses Latin digits and ل.س', () {
    final formatted = formatSyp(117450);
    expect(formatted, contains('117,450'));
    expect(formatted, contains('ل.س'));
    expect(formatted, isNot(contains('٠')));
  });

  test('product ref keeps a leading id and rejects non-positive values', () {
    expect(parseProductRef('4-khbz-tnor-bldy'), 4);
    expect(parseProductRef('18'), 18);
    expect(parseProductRef('slug-only'), isNull);
    expect(parseProductRef('0'), isNull);
  });

  test('list query omits an inverted price range and an empty search', () {
    expect(
      const ProductsQuery(
        minPriceSyp: 100,
        maxPriceSyp: 10,
      ).toQuery(search: false),
      isNull,
    );
    expect(const ProductsQuery(q: '  ').toQuery(search: true), isNull);
    expect(
      const ProductsQuery(
        categoryId: 9,
        sort: ProductSort.priceAsc,
        page: 2,
        q: 'خبز',
      ).toQuery(search: true),
      {
        'page': 2,
        'per_page': 24,
        'category': 9,
        'sort': 'price_asc',
        'q': 'خبز',
      },
    );
    expect(clampPage(9, 3), 3);
  });

  test('category tree nests children and ignores a dangling parent', () {
    final tree = buildCategoryTree([
      const CategoryDto(id: 2, name: 'مخبوزات', slug: 'bakery'),
      const CategoryDto(id: 9, name: 'خبز', slug: 'bakery-bread', parentId: 2),
      const CategoryDto(id: 3, name: 'بقالة', slug: 'grocery', parentId: 99),
    ]);
    expect(tree.map((node) => node.slug), ['bakery', 'grocery']);
    expect(findCategory(tree, 'bakery-bread')?.id, 9);
    expect(findCategory(tree, 'missing'), isNull);
  });

  test('category JSON keeps image URLs on parents and children', () {
    final tree = buildCategoryTree([
      CategoryDto.fromJson({
        'id': 3,
        'name': 'بقالة',
        'slug': 'grocery',
        'image': 'https://cdn.example/grocery.webp',
      }),
      CategoryDto.fromJson({
        'id': 2,
        'name': 'مخبوزات',
        'slug': 'bakery',
        'image': null,
      }),
      CategoryDto.fromJson({
        'id': 9,
        'name': 'خبز',
        'slug': 'bakery-bread',
        'parent_id': 2,
        'image': 'https://cdn.example/bread.webp',
      }),
    ]);
    expect(
      findCategory(tree, 'grocery')?.imageUrl,
      'https://cdn.example/grocery.webp',
    );
    expect(findCategory(tree, 'bakery')?.imageUrl, isNull);
    expect(
      findCategory(tree, 'bakery-bread')?.imageUrl,
      'https://cdn.example/bread.webp',
    );
  });

  test('detail JSON tolerates a null price and unknown keys', () {
    final dto = ProductDetailDto.fromJson({
      'id': 4,
      'slug': '4-khbz-tnor-bldy',
      'name': 'خبز تنور بلدي',
      'description': 'ربطة خبز تنور طازج يومياً',
      'price_syp': null,
      'price_is_estimate': false,
      'can_purchase': true,
      'photos': [],
      'options': [
        {
          'id': 1,
          'label': 'ربطة صغيرة',
          'available': true,
          'low_stock_hint': false,
        },
      ],
      'store': {'id': 4, 'name': 'فرن الياسمين', 'slug': 'furn-al-yasmin'},
      'category': {'id': 9, 'name': 'خبز', 'slug': 'bakery-bread'},
      'average_rating': null,
      'reviews_count': 0,
      'not_in_the_contract': {'ignore': true},
    });
    final detail = mapDetail(dto);
    expect(detail?.priceSyp, isNull);
    expect(detail?.storeSlug, 'furn-al-yasmin');
    expect(detail?.options.single.label, 'ربطة صغيرة');
  });

  test('card JSON accepts a photo object and a string price', () {
    final card = mapCard(
      ProductCardDto.fromJson({
        'id': '13',
        'name': 'بقلاوة',
        'photo': {'url': 'https://cdn.example/p.jpg'},
        'price_syp': '117450',
        'price_is_estimate': 1,
      }),
    );
    expect(card?.id, 13);
    expect(card?.photoUrl, 'https://cdn.example/p.jpg');
    expect(card?.priceSyp, 117450);
    expect(card?.priceIsEstimate, isTrue);
  });

  group('error mapping', () {
    test('422 is validation and keeps the server message', () {
      final mapped = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/search'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/search'),
            statusCode: 422,
            data: {'message': 'البيانات غير صالحة'},
          ),
        ),
      );
      expect(mapped.kind, ApiFailureKind.validation);
      expect(mapped.message, 'البيانات غير صالحة');
    });

    test('404, 500, and a timeout land on distinct kinds', () {
      ApiException kindFor(int? code, DioExceptionType type) {
        return mapDioException(
          DioException(
            requestOptions: RequestOptions(path: '/products/1'),
            type: type,
            response: code == null
                ? null
                : Response(
                    requestOptions: RequestOptions(path: '/products/1'),
                    statusCode: code,
                    data: {'message': 'x'},
                  ),
          ),
        );
      }

      expect(
        kindFor(404, DioExceptionType.badResponse).kind,
        ApiFailureKind.notFound,
      );
      expect(
        kindFor(500, DioExceptionType.badResponse).kind,
        ApiFailureKind.server,
      );
      expect(
        kindFor(429, DioExceptionType.badResponse).kind,
        ApiFailureKind.rateLimited,
      );
      expect(
        kindFor(null, DioExceptionType.connectionTimeout).kind,
        ApiFailureKind.network,
      );
    });

    test('cancel is not an API failure', () {
      expect(
        () => mapDioException(
          DioException(
            requestOptions: RequestOptions(path: '/home'),
            type: DioExceptionType.cancel,
          ),
        ),
        throwsA(isA<ApiCancelled>()),
      );
    });
  });

  group('runRequest', () {
    test('validation is rejected and does not attach a fixture', () async {
      final result = await runRequest<int>(
        hasBaseUrl: true,
        demo: () => 9,
        request: () async =>
            throw const ApiException(ApiFailureKind.validation, 'bad'),
      );
      expect(result, isA<RepoRejected<int>>());
      expect((result as RepoRejected<int>).message, 'bad');
    });

    test('network failure is unavailable and may carry a fixture', () async {
      final result = await runRequest<int>(
        hasBaseUrl: true,
        demo: () => 9,
        request: () async =>
            throw const ApiException(ApiFailureKind.network, ''),
      );
      expect(result, isA<RepoUnavailable<int>>());
      expect((result as RepoUnavailable<int>).sample, 9);
    });

    test(
      'a missing base URL is unavailable without calling the host',
      () async {
        var called = false;
        final result = await runRequest<int>(
          hasBaseUrl: false,
          demo: () => 4,
          request: () async {
            called = true;
            return 1;
          },
        );
        expect(called, isFalse);
        expect((result as RepoUnavailable<int>).sample, 4);
      },
    );

    test('404 is not found and drops the fixture', () async {
      final result = await runRequest<int>(
        hasBaseUrl: true,
        demo: () => 9,
        request: () async =>
            throw const ApiException(ApiFailureKind.notFound, 'gone'),
      );
      expect(result, isA<RepoNotFound<int>>());
    });
  });
}
