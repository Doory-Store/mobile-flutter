import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

export 'skeleton.dart';

class DemoLabel extends StatelessWidget {
  const DemoLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: tokens.primarySubtle,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        DooryStrings.demo,
        style: DooryTypography.captionStrong(context),
      ),
    );
  }
}

class MaintenanceBanner extends StatelessWidget {
  const MaintenanceBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = DooryTokens.of(context);
    return Material(
      color: tokens.primarySubtle,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: scheme.primary.withValues(alpha: 0.35)),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: DooryTypography.labelStrong(context),
        ),
      ),
    );
  }
}

class StatusMessage extends StatelessWidget {
  const StatusMessage({
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
    this.demo = false,
    super.key,
  });

  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool demo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (demo) ...[const DemoLabel(), const SizedBox(height: 12)],
          Text(
            title,
            textAlign: TextAlign.center,
            style: DooryTypography.section(context),
          ),
          if (body != null) ...[
            const SizedBox(height: 8),
            Text(
              body!,
              textAlign: TextAlign.center,
              style: DooryTypography.body(
                context,
              ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

class ComingSoonBody extends StatelessWidget {
  const ComingSoonBody({
    required this.title,
    required this.body,
    required this.onBrowse,
    super.key,
  });

  final String title;
  final String body;
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StatusMessage(
        title: title,
        body: body,
        actionLabel: DooryStrings.browseCategories,
        onAction: onBrowse,
      ),
    );
  }
}

Future<void> showCheckoutComing(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(DooryStrings.tabCart),
        content: const Text(DooryStrings.checkoutLater),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(DooryStrings.continueShopping),
          ),
        ],
      );
    },
  );
}

/// Quiet search field. 44px tall, 20px radius, magnifier at the inline end.
class DoorySearchField extends StatelessWidget {
  const DoorySearchField({
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        autofocus: autofocus,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: DooryTypography.body(context),
        decoration: InputDecoration(
          isDense: true,
          hintText: DooryStrings.searchHint,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 10, 8, 10),
          suffixIcon: IconButton(
            tooltip: DooryStrings.searchAction,
            onPressed: () => onSubmitted?.call(controller.text),
            icon: Icon(Icons.search, color: scheme.primary),
          ),
        ),
      ),
    );
  }
}
