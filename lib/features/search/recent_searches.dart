import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/favorites/favorites_controller.dart';
import '../account/local_preferences.dart';

/// Recent search words, newest first, kept on this device.
///
/// BACKEND: AVAILABLE GET /search/suggest → recent[] (per signed-in buyer; not wired)
class RecentSearches extends Notifier<List<String>> {
  static const _max = 10;
  static String get storageKey => 'doory.mock.$recentSearchesKey.v1';

  @override
  List<String> build() {
    return ref.watch(sharedPreferencesProvider).getStringList(storageKey) ??
        const <String>[];
  }

  Future<void> add(String query) async {
    final value = query.trim();
    if (value.isEmpty) return;
    final next = [
      value,
      for (final item in state)
        if (item != value) item,
    ].take(_max).toList();
    await _save(next);
  }

  Future<void> remove(String query) => _save([
    for (final item in state)
      if (item != query) item,
  ]);

  Future<void> clear() => _save(const <String>[]);

  Future<void> _save(List<String> next) async {
    state = next;
    await ref.read(sharedPreferencesProvider).setStringList(storageKey, next);
  }
}

final recentSearchesProvider = NotifierProvider<RecentSearches, List<String>>(
  RecentSearches.new,
);

/// «عمليات بحث مقترحة»: a fixed sample list shown with the red «غير مدعوم» label.
/// BACKEND: MISSING popular/trending search terms endpoint (GET /search/suggest returns products, categories, stores, recent only)
const popularSearches = <String>[
  'توصيل مجاني',
  'زيت زيتون',
  'خبز',
  'أجبان',
  'حلويات',
  'منظفات',
  'قهوة',
  'مكسرات',
];
