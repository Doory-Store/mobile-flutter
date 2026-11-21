import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../core/l10n/doory_strings.dart';
import '../core/theme/doory_theme.dart';
import '../features/auth/session_controller.dart';
import 'router.dart';

class DooryApp extends ConsumerStatefulWidget {
  const DooryApp({super.key});

  @override
  ConsumerState<DooryApp> createState() => _DooryAppState();
}

class _DooryAppState extends ConsumerState<DooryApp> {
  @override
  void initState() {
    super.initState();
    // Confirms a restored token with `GET /me` and refreshes the profile.
    Future.microtask(() => ref.read(sessionProvider.notifier).refreshProfile());
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    ref.listen<SessionState>(sessionProvider, (previous, next) {
      if (next.expired && (previous?.expired ?? false) == false) {
        router.push('/login');
      }
    });
    return MaterialApp.router(
      title: DooryStrings.appName,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: dooryTheme(),
      routerConfig: router,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
