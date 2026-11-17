import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/widgets/chrome.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(DooryStrings.tabCart)),
      body: ComingSoonBody(
        title: DooryStrings.tabCart,
        body: DooryStrings.cartBody,
        onBrowse: () => context.go('/categories'),
      ),
    );
  }
}
