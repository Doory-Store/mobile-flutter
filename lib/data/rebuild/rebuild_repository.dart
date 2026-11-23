import 'dart:async';

import '../../core/l10n/doory_strings.dart';
import '../repositories/repo_result.dart';
import 'mock_scenario.dart';
import 'rebuild_fixtures.dart';
import 'rebuild_models.dart';

/// Mock catalogs for the rebuild. The scenario is the single switch for
/// ok / empty / error / loading. Widgets never import the fixtures.
class RebuildRepository {
  const RebuildRepository(this.scenario);

  final MockScenario scenario;

  Future<RepoResult<RebuildHome>> home() {
    return _load(() => RebuildFixtures.home, () => const RebuildHome());
  }

  Future<RepoResult<List<RebuildCategory>>> categories() {
    return _load(
      () => RebuildFixtures.categories,
      () => const <RebuildCategory>[],
    );
  }

  Future<RepoResult<List<RebuildStore>>> stores() {
    return _load(() => RebuildFixtures.stores, () => const <RebuildStore>[]);
  }

  Future<RepoResult<List<RebuildProduct>>> products({
    String? category,
    String? store,
    String? query,
  }) {
    return _load(() {
      final needle = query?.trim();
      return [
        for (final product in RebuildFixtures.products)
          if (_matches(product, category, store, needle)) product,
      ];
    }, () => const <RebuildProduct>[]);
  }

  Future<RepoResult<RebuildProduct>> product(String ref) {
    return _loadOne(() {
      for (final product in RebuildFixtures.products) {
        if (product.slug == ref || '${product.id}' == ref) return product;
      }
      return null;
    });
  }

  Future<RepoResult<RebuildCart>> cart() {
    return _load(() => RebuildFixtures.cart, () => const RebuildCart());
  }

  Future<RepoResult<List<RebuildProduct>>> favorites() {
    return _load(
      () => RebuildFixtures.favorites,
      () => const <RebuildProduct>[],
    );
  }

  bool _matches(
    RebuildProduct product,
    String? category,
    String? store,
    String? query,
  ) {
    if (category != null &&
        category.isNotEmpty &&
        product.categorySlug != category) {
      return false;
    }
    if (store != null && store.isNotEmpty && product.storeSlug != store) {
      return false;
    }
    if (query != null && query.isNotEmpty) {
      final haystack = '${product.name} ${product.brand ?? ''}';
      if (!haystack.contains(query)) return false;
    }
    return true;
  }

  Future<RepoResult<T>> _load<T>(T Function() data, T Function() empty) {
    switch (scenario) {
      case MockScenario.loading:
        return Completer<RepoResult<T>>().future;
      case MockScenario.error:
        return Future.value(RepoRejected<T>(DooryStrings.unavailable));
      case MockScenario.empty:
        return Future.value(RepoOk<T>(empty()));
      case MockScenario.ok:
        return Future.value(RepoOk<T>(data()));
    }
  }

  Future<RepoResult<T>> _loadOne<T>(T? Function() find) {
    switch (scenario) {
      case MockScenario.loading:
        return Completer<RepoResult<T>>().future;
      case MockScenario.error:
        return Future.value(RepoRejected<T>(DooryStrings.unavailable));
      case MockScenario.empty:
        return Future.value(const RepoNotFound());
      case MockScenario.ok:
        final value = find();
        if (value == null) return Future.value(const RepoNotFound());
        return Future.value(RepoOk<T>(value));
    }
  }
}
