import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_typography.dart';

enum DooryWordmarkSize { compact, display }

/// The word «دوري». There is no logo file; the word is the mark.
class DooryWordmark extends StatelessWidget {
  const DooryWordmark({
    this.size = DooryWordmarkSize.compact,
    this.onTap,
    super.key,
  });

  final DooryWordmarkSize size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = size == DooryWordmarkSize.display
        ? DooryTypography.wordmarkDisplay(context)
        : DooryTypography.wordmark(context);
    final text = Text(DooryStrings.appName, style: style);
    if (onTap == null) {
      return Semantics(header: true, child: text);
    }
    return Semantics(
      button: true,
      label: DooryStrings.wordmarkHome,
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 44),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: 1,
              heightFactor: 1,
              child: text,
            ),
          ),
        ),
      ),
    );
  }
}
