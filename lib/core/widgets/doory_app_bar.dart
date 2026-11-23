import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';
import 'search_pill.dart';

enum DooryAppBarVariant { search, title }

/// Pushes a 56 dp bar below the status bar. [preferredSize] stays 56 because
/// [Scaffold] already adds the top inset to the app-bar slot.
class DooryStatusInset extends StatelessWidget {
  const DooryStatusInset({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: child,
    );
  }
}

class DooryAppBarAction {
  const DooryAppBarAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
}

/// Sub-screen bar. 56 dp, not counting the status bar.
class DooryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DooryAppBar({
    this.variant = DooryAppBarVariant.title,
    this.title = '',
    this.showBack = true,
    this.onBack,
    this.search,
    this.actionLabel,
    this.onAction,
    this.actions = const [],
    super.key,
  });

  final DooryAppBarVariant variant;
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final SearchPill? search;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<DooryAppBarAction> actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bar = SizedBox(
      height: 56,
      child: variant == DooryAppBarVariant.search
          ? _searchRow(context)
          : _titleRow(context),
    );
    return Material(
      color: scheme.surface,
      elevation: 0,
      child: DooryStatusInset(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: variant == DooryAppBarVariant.title
                ? Border(bottom: DooryBorders.hairline(scheme.outline))
                : null,
          ),
          child: bar,
        ),
      ),
    );
  }

  Widget _searchRow(BuildContext context) {
    return Row(
      children: [
        if (showBack) _back(context),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: search ?? const SearchPill(),
          ),
        ),
        for (final action in actions) _iconAction(action),
      ],
    );
  }

  Widget _titleRow(BuildContext context) {
    final action = _trailing(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        if (showBack)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: _back(context),
          ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 96),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: DooryTypography.toolbarTitle(context),
          ),
        ),
        if (action != null)
          Align(alignment: AlignmentDirectional.centerEnd, child: action),
      ],
    );
  }

  Widget? _trailing(BuildContext context) {
    if (actions.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [for (final action in actions) _iconAction(action)],
      );
    }
    if (actionLabel == null || actionLabel!.isEmpty) return null;
    final enabled = onAction != null;
    return TextButton(
      onPressed: onAction,
      child: Text(
        actionLabel!,
        style: DooryTypography.link(
          context,
        ).copyWith(color: enabled ? null : DooryTokens.of(context).textMuted),
      ),
    );
  }

  Widget _back(BuildContext context) {
    return IconButton(
      tooltip: DooryStrings.back,
      onPressed: () {
        if (onBack != null) {
          onBack!();
          return;
        }
        Navigator.maybePop(context);
      },
      icon: const Icon(Icons.arrow_back, size: DooryIconSize.chrome),
    );
  }

  Widget _iconAction(DooryAppBarAction action) {
    return IconButton(
      tooltip: action.tooltip,
      onPressed: action.onPressed,
      icon: Icon(action.icon, size: DooryIconSize.chrome),
    );
  }
}
