import 'package:material_ui/material_ui.dart';

import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';
import 'list_row.dart';

/// White group on a canvas page. Radius 8, no border and no shadow.
class GroupCard extends StatelessWidget {
  const GroupCard({this.title, required this.children, super.key});

  final String? title;
  final List<ListRow> children;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final hasTitle = title != null && title!.isNotEmpty;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 12),
      child: Material(
        color: scheme.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasTitle)
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
                child: Semantics(
                  header: true,
                  child: Text(
                    title!,
                    style: DooryTypography.sectionTitle(context),
                  ),
                ),
              ),
            ...children,
          ],
        ),
      ),
    );
  }
}
