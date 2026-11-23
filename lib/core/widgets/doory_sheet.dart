import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

/// Bottom sheet with a 56 dp title row and a close button. No grabber.
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
              color: scheme.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(tokens.radius12),
              ),
              boxShadow: DooryShadows.sheet(tokens.shadowCard),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: Focus(
                            autofocus: true,
                            child: Semantics(
                              header: true,
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: DooryTypography.toolbarTitle(context),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: DooryStrings.close,
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(
                            Icons.close,
                            size: DooryIconSize.chrome,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(child: SingleChildScrollView(child: child)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
