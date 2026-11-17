import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabSignal {
  const TabSignal({this.tab = -1, this.tick = 0});

  final int tab;
  final int tick;
}

class TabReselect extends Notifier<TabSignal> {
  @override
  TabSignal build() => const TabSignal();

  void ping(int tab) => state = TabSignal(tab: tab, tick: state.tick + 1);
}

final tabReselectProvider = NotifierProvider<TabReselect, TabSignal>(
  TabReselect.new,
);
