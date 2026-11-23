import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

/// Bottom sheet. The header is 49 dp on `surfaceSubtle`. Confirm rows stay 56.
Future<void> showDoorySheet({
  required BuildContext context,
  required String title,
  required Widget child,
  bool dismissible = true,
}) {
  final tokens = DooryTokens.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: dismissible,
    enableDrag: dismissible,
    barrierColor: tokens.sheetBarrier,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DoorySheet(title: title, dismissible: dismissible, child: child);
    },
  );
}

class DoorySheet extends StatelessWidget {
  const DoorySheet({
    required this.title,
    required this.child,
    this.dismissible = true,
    super.key,
  });

  final String title;
  final Widget child;
  final bool dismissible;

  static const headerKey = ValueKey<String>('doory-sheet-header');

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Semantics(
      namesRoute: true,
      scopesRoute: true,
      explicitChildNodes: true,
      label: title,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(tokens.radius12),
              ),
              boxShadow: DooryShadows.sheet(tokens.shadowCard),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(tokens.radius12),
              ),
              child: ColoredBox(
                color: scheme.surface,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DecoratedBox(
                        key: headerKey,
                        decoration: BoxDecoration(
                          color: tokens.surfaceSubtle,
                          border: Border(
                            bottom: DooryBorders.hairline(scheme.outline),
                          ),
                        ),
                        child: SizedBox(
                          height: 49,
                          child: Row(
                            children: [
                              const SizedBox(width: 14),
                              Expanded(
                                child: Focus(
                                  autofocus: true,
                                  child: Semantics(
                                    header: true,
                                    label: title,
                                    excludeSemantics: true,
                                    child: Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: DooryTypography.toolbarTitle(
                                        context,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsetsDirectional.only(end: 14),
                                child: _SheetClose(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(child: SingleChildScrollView(child: child)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetClose extends StatelessWidget {
  const _SheetClose();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 14,
      height: 14,
      child: OverflowBox(
        minWidth: 48,
        maxWidth: 48,
        minHeight: 48,
        maxHeight: 48,
          child: Semantics(
          button: true,
          label: DooryStrings.close,
          onTap: () => Navigator.of(context).maybePop(),
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: Icon(Icons.close, size: 14, color: scheme.onSurface),
          ),
        ),
      ),
    );
  }
}
