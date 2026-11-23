import 'package:material_ui/material_ui.dart';

import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

enum ListRowDensity { regular, compact, edge }

enum ListRowTrailing { chevron, radio, none }

/// `standard` is the spec's default row. `radioLeading` is the sort sheet.
enum ListRowVariant { standard, radioLeading }

/// List row at 56, 42, or 52 dp. The chevron points to the inline end.
class ListRow extends StatelessWidget {
  const ListRow({
    required this.title,
    this.value,
    this.density = ListRowDensity.regular,
    this.leading,
    this.trailing = ListRowTrailing.chevron,
    this.variant = ListRowVariant.standard,
    this.selected = false,
    this.showDivider = true,
    this.enabled = true,
    this.titleColor,
    this.onTap,
    super.key,
  });

  final String title;
  final String? value;
  final ListRowDensity density;
  final IconData? leading;
  final ListRowTrailing trailing;
  final ListRowVariant variant;
  final bool selected;

  final bool showDivider;
  final bool enabled;
  final Color? titleColor;
  final VoidCallback? onTap;

  double get _height {
    return switch (density) {
      ListRowDensity.regular => 56,
      ListRowDensity.compact => 42,
      ListRowDensity.edge => 52,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final radioLeading = variant == ListRowVariant.radioLeading;
    final twoLine =
        !radioLeading && value != null && density == ListRowDensity.regular;
    final rowHeight = radioLeading ? 49.0 : _height;
    final divider = radioLeading ? false : showDivider;
    final isRadio = radioLeading || trailing == ListRowTrailing.radio;
    final titleStyle =
        (twoLine
                ? DooryTypography.rowLabelStrong(context)
                : DooryTypography.rowLabel(context))
            .copyWith(
              color: !enabled
                  ? tokens.textMuted
                  : titleColor ?? scheme.onSurface,
            );
    final label = value == null || value!.isEmpty ? title : '$title، $value';
    return Semantics(
      button: true,
      enabled: enabled,
      checked: isRadio ? selected : null,
      inMutuallyExclusiveGroup: isRadio,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: scheme.surface,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: divider
                  ? Border(bottom: DooryBorders.hairline(scheme.outline))
                  : null,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: rowHeight),
              child: Padding(
                padding: radioLeading
                    ? const EdgeInsetsDirectional.only(start: 14)
                    : EdgeInsetsDirectional.symmetric(
                        horizontal: 16,
                        vertical: twoLine ? 8 : 0,
                      ),
                child: Row(
                  children: [
                    if (radioLeading) ...[
                      DooryRadioMark(selected: selected),
                      const SizedBox(width: 8),
                    ],
                    if (leading != null && !radioLeading) ...[
                      Icon(
                        leading,
                        size: DooryIconSize.inline,
                        color: enabled ? scheme.primary : tokens.textMuted,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle,
                          ),
                          if (twoLine)
                            Text(
                              value!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: DooryTypography.caption(context),
                            ),
                        ],
                      ),
                    ),
                    if (!twoLine && value != null && value!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(value!, style: DooryTypography.caption(context)),
                    ],
                    if (!radioLeading &&
                        enabled &&
                        trailing == ListRowTrailing.chevron) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        size: DooryIconSize.chevron,
                        color: scheme.onSurfaceVariant,
                      ),
                    ],
                    if (!radioLeading && trailing == ListRowTrailing.radio) ...[
                      const SizedBox(width: 8),
                      DooryRadioMark(selected: selected),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DooryRadioMark extends StatelessWidget {
  const DooryRadioMark({required this.selected, super.key});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ring = selected ? scheme.primary : scheme.outline;
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.surface,
        border: Border.all(color: ring),
      ),
      child: SizedBox(
        width: 22,
        height: 22,
        child: selected
            ? Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.primary,
                  ),
                  child: const SizedBox(width: 8, height: 8),
                ),
              )
            : null,
      ),
    );
  }
}
