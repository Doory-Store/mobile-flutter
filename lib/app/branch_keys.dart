import 'package:flutter/widgets.dart';

final branchNavigatorKeys = List<GlobalKey<NavigatorState>>.generate(
  5,
  (index) => GlobalKey<NavigatorState>(debugLabel: 'doory-branch-$index'),
);
