import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/repo_result.dart';
import 'mock_scenario.dart';
import 'rebuild_models.dart';
import 'rebuild_repository.dart';

/// Default is a labelled mock. Later phases read these providers.
final mockScenarioProvider = StateProvider<MockScenario>(
  (ref) => MockScenario.ok,
);

final rebuildRepositoryProvider = Provider<RebuildRepository>(
  (ref) => RebuildRepository(ref.watch(mockScenarioProvider)),
);

final rebuildHomeProvider = FutureProvider<RepoResult<RebuildHome>>(
  (ref) => ref.watch(rebuildRepositoryProvider).home(),
);

final rebuildCategoriesProvider =
    FutureProvider<RepoResult<List<RebuildCategory>>>(
      (ref) => ref.watch(rebuildRepositoryProvider).categories(),
    );

final rebuildStoresProvider = FutureProvider<RepoResult<List<RebuildStore>>>(
  (ref) => ref.watch(rebuildRepositoryProvider).stores(),
);

final rebuildProductsProvider =
    FutureProvider<RepoResult<List<RebuildProduct>>>(
      (ref) => ref.watch(rebuildRepositoryProvider).products(),
    );

final rebuildCartProvider = FutureProvider<RepoResult<RebuildCart>>(
  (ref) => ref.watch(rebuildRepositoryProvider).cart(),
);

final rebuildFavoritesProvider =
    FutureProvider<RepoResult<List<RebuildProduct>>>(
      (ref) => ref.watch(rebuildRepositoryProvider).favorites(),
    );
