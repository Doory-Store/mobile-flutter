import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/favorites/favorites_controller.dart';

/// A set of ids kept on the device. Used for followed stores and product
/// watches while their account endpoints are unwired.
class LocalIdSet extends FamilyNotifier<Set<String>, String> {
  String get _key => 'doory.mock.$arg.v1';

  @override
  Set<String> build(String arg) {
    return ref.watch(sharedPreferencesProvider).getStringList(_key)?.toSet() ??
        <String>{};
  }

  bool contains(String id) => state.contains(id);

  /// Returns true when [id] is now in the set.
  Future<bool> toggle(String id) async {
    final next = {...state};
    final added = next.add(id);
    if (!added) next.remove(id);
    state = next;
    await ref
        .read(sharedPreferencesProvider)
        .setStringList(_key, next.toList());
    return added;
  }
}

final localIdSetProvider =
    NotifierProvider.family<LocalIdSet, Set<String>, String>(LocalIdSet.new);

const followedStoresKey = 'followed-stores';
const priceWatchesKey = 'price-watches';
const stockWatchesKey = 'stock-watches';
const recentSearchesKey = 'recent-searches';
const browsingHistoryKey = 'browsing-history';

/// On/off switch of browsing history (default on). Stored without the
/// `doory.mock.` prefix: it is a real preference, not demo data.
const browsingHistoryEnabledKey = 'doory.browsing-history-enabled';
