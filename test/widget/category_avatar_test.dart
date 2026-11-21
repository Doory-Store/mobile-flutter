import 'package:cached_network_image/cached_network_image.dart';
import 'package:doory_mobile/core/theme/doory_theme.dart';
import 'package:doory_mobile/core/widgets/category_avatar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('a category with an image URL renders a network image', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: dooryTheme(),
        locale: const Locale('ar'),
        home: const Scaffold(
          body: CategoryAvatar(
            name: 'بقالة',
            imageUrl: 'https://cdn.example/grocery.webp',
            size: 68,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(CachedNetworkImage), findsOneWidget);
    expect(
      tester
          .widget<CachedNetworkImage>(find.byType(CachedNetworkImage))
          .imageUrl,
      'https://cdn.example/grocery.webp',
    );
  });

  testWidgets('a category with no image renders the name initial', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: dooryTheme(),
        locale: const Locale('ar'),
        home: const Scaffold(
          body: CategoryAvatar(name: 'مخبوزات', imageUrl: null, size: 68),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(CachedNetworkImage), findsNothing);
    expect(find.text('م'), findsOneWidget);
  });

  testWidgets('an empty image URL uses the same fallback as a null image', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: dooryTheme(),
        locale: const Locale('ar'),
        home: const Scaffold(
          body: CategoryAvatar(name: 'مخبوزات', imageUrl: '  ', size: 36),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(CachedNetworkImage), findsNothing);
    expect(find.text('م'), findsOneWidget);
  });
}
