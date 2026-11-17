import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(DooryStrings.tabAccount)),
      body: ListView(
        padding: const EdgeInsetsDirectional.all(16),
        children: [
          Text(DooryStrings.accountBody),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.push('/account/status'),
            child: const Text(DooryStrings.apiStatus),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go('/categories'),
            child: const Text(DooryStrings.browseCategories),
          ),
        ],
      ),
    );
  }
}
