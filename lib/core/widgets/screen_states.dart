import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';
import 'doory_button.dart';

/// Centered empty state. Copy belongs to the screen that uses it.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final showAction =
        actionLabel != null && actionLabel!.isNotEmpty && onAction != null;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tokens.primarySubtle,
                    ),
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Icon(
                        icon,
                        size: DooryIconSize.empty,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    header: true,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 32,
                      ),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: DooryTypography.toolbarTitle(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 32,
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: DooryTypography.bodySecondary(context),
                    ),
                  ),
                  if (showAction) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: DooryButton(
                        label: actionLabel!,
                        size: DooryButtonSize.h45,
                        expanded: true,
                        onPressed: onAction,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Full-page error with a retry button. The screen keeps pull-to-refresh too.
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message,
    required this.onRetry,
    this.title = DooryStrings.loadFailed,
    this.retrying = false,
    super.key,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;
  final bool retrying;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    return Semantics(
      liveRegion: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: tokens.surfaceSubtle,
                      ),
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: Icon(
                          Icons.error_outline,
                          size: DooryIconSize.empty,
                          color: tokens.danger,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 32,
                      ),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: DooryTypography.toolbarTitle(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 32,
                      ),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: DooryTypography.bodySecondary(context),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                      ),
                      child: DooryButton(
                        label: DooryStrings.retry,
                        size: DooryButtonSize.h45,
                        expanded: true,
                        loading: retrying,
                        onPressed: onRetry,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
