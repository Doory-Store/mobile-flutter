import 'package:material_ui/material_ui.dart';

import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

enum SectionGutter { dense, regular }

/// Section title with an optional end link such as «رؤية الكل».
class SectionHeader extends StatefulWidget {
  const SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    this.gutter = SectionGutter.dense,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final SectionGutter gutter;

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final inset = widget.gutter == SectionGutter.dense
        ? tokens.space.gutterDense
        : tokens.space.gutter;
    final showAction =
        widget.onAction != null &&
        widget.actionLabel != null &&
        widget.actionLabel!.isNotEmpty;
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 44),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: inset),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                label: widget.title,
                container: true,
                excludeSemantics: true,
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DooryTypography.sectionTitle(context),
                ),
              ),
            ),
            if (showAction) ...[
              const SizedBox(width: 8),
              Semantics(
                button: true,
                label: widget.actionLabel,
                onTap: widget.onAction,
                container: true,
                excludeSemantics: true,
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _pressed = true),
                  onTapCancel: () => setState(() => _pressed = false),
                  onTapUp: (_) => setState(() => _pressed = false),
                  onTap: widget.onAction,
                  child: Opacity(
                    opacity: _pressed ? 0.72 : 1,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 8,
                      ),
                      child: Text(
                        widget.actionLabel!,
                        style: DooryTypography.link(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
