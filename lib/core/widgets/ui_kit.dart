import 'package:material_ui/material_ui.dart';

import '../format/price_format.dart';
import '../l10n/doory_strings.dart';
import '../theme/doory_colors.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';
import 'chrome.dart';

/// Full-width primary action. Shows a spinner and ignores taps while [busy].
class DooryPrimaryButton extends StatelessWidget {
  const DooryPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.busy = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final child = busy
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: DooryColors.textOnStrong,
            ),
          )
        : Text(label);
    return SizedBox(
      width: double.infinity,
      child: icon == null || busy
          ? FilledButton(onPressed: busy ? null : onPressed, child: child)
          : FilledButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: child,
            ),
    );
  }
}

/// Full-width secondary action with the brand outline.
class DooryOutlineButton extends StatelessWidget {
  const DooryOutlineButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: icon == null
          ? OutlinedButton(onPressed: onPressed, child: Text(label))
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
            ),
    );
  }
}

/// A bordered white card that groups one topic on a screen.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.child,
    this.title,
    this.trailing,
    this.padding = const EdgeInsetsDirectional.all(16),
    this.margin = const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
    super.key,
  });

  final Widget child;
  final String? title;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    return Padding(
      padding: margin,
      // A Material (not a DecoratedBox) so list tiles inside keep their ink.
      child: Material(
        color: DooryColors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusCard),
          side: const BorderSide(color: DooryColors.border),
        ),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: DooryTypography.labelStrong(context),
                      ),
                    ),
                    ?trailing,
                  ],
                ),
                const SizedBox(height: 12),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

/// A label on the start side and a value on the end side.
class InfoRow extends StatelessWidget {
  const InfoRow({
    required this.label,
    required this.value,
    this.strong = false,
    this.valueColor,
    super.key,
  });

  final String label;
  final String value;
  final bool strong;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final style = strong
        ? DooryTypography.labelStrong(context)
        : DooryTypography.label(context);
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: style.copyWith(color: valueColor),
            ),
          ),
        ],
      ),
    );
  }
}

/// A money row for totals. A null amount reads «يُحدَّد لاحقًا».
class MoneyRow extends StatelessWidget {
  const MoneyRow({
    required this.label,
    required this.amount,
    this.strong = false,
    this.negative = false,
    super.key,
  });

  final String label;
  final int? amount;
  final bool strong;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    final value = amount == null
        ? DooryStrings.toBeDetermined
        : formatSyp(negative ? -amount! : amount!);
    return InfoRow(
      label: label,
      value: value,
      strong: strong,
      valueColor: strong
          ? DooryColors.primaryStrong
          : negative
          ? DooryColors.success
          : null,
    );
  }
}

/// Small rounded status label (order status, «جديد», «افتراضي»).
class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    this.tone = PillTone.neutral,
    super.key,
  });

  final String label;
  final PillTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      PillTone.neutral => (DooryColors.surfaceSubtle, DooryColors.textPrimary),
      PillTone.brand => (DooryColors.primarySubtle, DooryColors.primaryHover),
      PillTone.success => (const Color(0xFFE6F4EA), DooryColors.success),
      PillTone.info => (const Color(0xFFE1F0FA), const Color(0xFF1F5F8B)),
      PillTone.danger => (const Color(0xFFFCE8E8), DooryColors.danger),
    };
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 10,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: DooryTypography.cardMeta(context)
            .copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}

enum PillTone { neutral, brand, success, info, danger }

/// Centered empty state with an icon, a title, an optional body and action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
    this.demo = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool demo;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: tokens.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: DooryColors.primaryStrong),
            ),
            const SizedBox(height: 16),
            StatusMessage(
              title: title,
              body: body,
              actionLabel: actionLabel,
              onAction: onAction,
              demo: demo,
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton rows for list screens.
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({this.rows = 4, this.height = 84, super.key});

  final int rows;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsetsDirectional.all(16),
      itemCount: rows,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => SkeletonBox(height: height),
    );
  }
}

/// A one-line strip that marks a screen as running on sample data.
class MockBanner extends StatelessWidget {
  const MockBanner({this.message = DooryStrings.mockScreenNote, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    return Container(
      width: double.infinity,
      color: tokens.primarySubtle,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
      child: Row(
        children: [
          const DemoLabel(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: DooryTypography.cardMeta(context)),
          ),
        ],
      ),
    );
  }
}

/// Labelled text field with the form radius (8) instead of the search pill.
class DooryTextField extends StatelessWidget {
  const DooryTextField({
    required this.label,
    this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.prefix,
    this.onChanged,
    this.textDirection,
    this.enabled = true,
    this.autofocus = false,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final int? maxLength;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;
  final TextDirection? textDirection;
  final bool enabled;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(DooryTokens.of(context).radiusCard);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: DooryTypography.labelStrong(context)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          enabled: enabled,
          autofocus: autofocus,
          textDirection: textDirection,
          style: DooryTypography.body(context),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix,
            border: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(
                color: DooryColors.primaryStrong,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: const BorderSide(color: DooryColors.danger),
            ),
          ),
        ),
      ],
    );
  }
}

/// Standard modal bottom sheet with a drag handle and a title row.
Future<T?> showDoorySheet<T>(
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
  bool scrollable = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    isScrollControlled: scrollable,
    useSafeArea: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsetsDirectional.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: Text(title, style: DooryTypography.section(sheetContext)),
            ),
            Flexible(child: builder(sheetContext)),
          ],
        ),
      );
    },
  );
}

/// Confirmation dialog. Resolves to true when the shopper confirms.
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  String? body,
  String confirmLabel = DooryStrings.confirm,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: body == null ? null : Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(DooryStrings.cancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: DooryColors.danger)
              : null,
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Short confirmation toast at the bottom of the screen.
void showToast(
  BuildContext context,
  String message, {
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        // Toasts with an action still time out so they never cover the
        // checkout bar for long.
        persist: false,
        action: actionLabel == null || onAction == null
            ? null
            : SnackBarAction(label: actionLabel, onPressed: onAction),
      ),
    );
}

/// The one message for actions that need a server contract the app does not
/// call yet. [feature] names what would happen, e.g. «إرسال الطلب».
Future<void> showNotWired(BuildContext context, {String? feature}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.link_off, color: DooryColors.primaryStrong),
      title: const Text(DooryStrings.notWiredTitle),
      content: Text(
        feature == null
            ? DooryStrings.notWiredBody
            : DooryStrings.notWiredFeature(feature),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text(DooryStrings.understood),
        ),
      ],
    ),
  );
}
