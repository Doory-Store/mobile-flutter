import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_providers.dart';
import '../../core/config/app_config.dart';
import '../../core/network/api_transport.dart';
import '../../core/network/auth_interceptor.dart';
import '../models/catalog_models.dart';
import 'catalog_repository.dart';
import 'home_repository.dart';
import 'meta_repository.dart';
import 'product_repository.dart';
import 'repo_result.dart';
import 'search_repository.dart';
import 'store_repository.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

final apiTransportProvider = Provider<ApiTransport>((ref) {
  final config = ref.watch(appConfigProvider);
  final transport = DioApiTransport(
    config,
    interceptors: [
      AuthInterceptor(
        apiUri: config.apiUri,
        allowInsecureHttp: config.allowInsecureHttp,
        readToken: () => ref.read(credentialVaultProvider).liveToken,
        onUnauthorized: () {
          ref.read(credentialVaultProvider).clear();
          ref.read(sessionRevokedProvider.notifier).state++;
        },
      ),
    ],
  );
  ref.onDispose(transport.close);
  return transport;
});

final metaRepositoryProvider = Provider<MetaRepository>((ref) {
  return MetaRepository(
    ref.watch(apiTransportProvider),
    ref.watch(appConfigProvider),
  );
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(
    ref.watch(apiTransportProvider),
    ref.watch(appConfigProvider),
  );
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository(
    ref.watch(apiTransportProvider),
    ref.watch(appConfigProvider),
  );
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(
    ref.watch(apiTransportProvider),
    ref.watch(appConfigProvider),
  );
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(
    ref.watch(apiTransportProvider),
    ref.watch(appConfigProvider),
  );
});

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository(
    ref.watch(apiTransportProvider),
    ref.watch(appConfigProvider),
  );
});

final homeProvider = FutureProvider<RepoResult<HomeContent>>((ref) {
  final cancel = CancelToken();
  ref.onDispose(cancel.cancel);
  return ref.watch(homeRepositoryProvider).fetch(cancelToken: cancel);
});

final categoriesProvider = FutureProvider<RepoResult<List<CategoryNode>>>((
  ref,
) {
  final cancel = CancelToken();
  ref.onDispose(cancel.cancel);
  return ref.watch(catalogRepositoryProvider).categories(cancelToken: cancel);
});

final metaStatusProvider = FutureProvider<ServiceStatus?>((ref) async {
  final cancel = CancelToken();
  ref.onDispose(cancel.cancel);
  final result = await ref
      .watch(metaRepositoryProvider)
      .status(cancelToken: cancel);
  if (result is RepoOk<ServiceStatus>) return result.data;
  return null;
});

final productProvider = FutureProvider.autoDispose
    .family<RepoResult<ProductDetailModel>, int>((ref, id) {
      final cancel = CancelToken();
      ref.onDispose(cancel.cancel);
      return ref
          .watch(productRepositoryProvider)
          .fetch(id, cancelToken: cancel);
    });

final storeProvider = FutureProvider.autoDispose
    .family<RepoResult<StoreModel>, String>((ref, slug) {
      final cancel = CancelToken();
      ref.onDispose(cancel.cancel);
      return ref
          .watch(storeRepositoryProvider)
          .fetch(slug, cancelToken: cancel);
    });
