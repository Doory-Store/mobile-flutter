import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/l10n/pdp_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';

/// White full-bleed block separated by a thin grey gap, as on Trendyol's PDP.
class PdpBlock extends StatelessWidget {
  const PdpBlock({
    required this.child,
    this.padding = const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: DooryColors.surface,
      padding: padding,
      child: child,
    );
  }
}

/// 1 dp hairline, inset 16 dp, as on Trendyol PDP cards.
class PdpSectionDivider extends StatelessWidget {
  const PdpSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Divider(height: 1, thickness: 1, color: DooryColors.border),
    );
  }
}

/// Section header: title at the start, optional action («الكل (28)») at the end.
class PdpHeader extends StatelessWidget {
  const PdpHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    this.trailing,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: DooryTypography.section(context)),
          ),
        ),
        ?trailing,
        if (actionLabel != null)
          InkWell(
            onTap: onAction,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: DooryTypography.labelStrong(context)
                        .copyWith(color: DooryColors.primary),
                  ),
                  const Icon(
                    Icons.chevron_left,
                    size: 18,
                    color: DooryColors.primary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// A row that expands and collapses in place (no navigation).
class PdpExpandable extends StatefulWidget {
  const PdpExpandable({
    required this.title,
    required this.child,
    this.leading,
    this.summary,
    this.initiallyExpanded = false,
    this.trailing,
    super.key,
  });

  final String title;
  final IconData? leading;
  final String? summary;
  final Widget child;
  final bool initiallyExpanded;
  final Widget? trailing;

  @override
  State<PdpExpandable> createState() => _PdpExpandableState();
}

class _PdpExpandableState extends State<PdpExpandable> {
  late bool _open = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return PdpBlock(
      padding: EdgeInsetsDirectional.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: _open,
            child: InkWell(
              onTap: () => setState(() => _open = !_open),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 12, 14),
                child: Row(
                  children: [
                    if (widget.leading != null) ...[
                      Icon(
                        widget.leading,
                        size: 20,
                        color: DooryColors.primary,
                      ),
                      const SizedBox(width: 10),
                    ],
                    Flexible(
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: DooryTypography.section(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: !_open && widget.summary != null
                          ? Text(
                              widget.summary!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: DooryTypography.label(context),
                            )
                          : const SizedBox.shrink(),
                    ),
                    ?widget.trailing,
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.keyboard_arrow_down, color: muted),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Collapsed content is not built, so screen readers and finders
          // only see what is on screen.
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            alignment: AlignmentDirectional.topStart,
            child: _open
                ? Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      0,
                      16,
                      16,
                    ),
                    child: widget.child,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

/// Text that shows a few lines with «عرض المزيد» / «عرض أقل» in place.
class PdpReadMore extends StatefulWidget {
  const PdpReadMore({
    required this.text,
    this.trimLines = 3,
    this.style,
    super.key,
  });

  final String text;
  final int trimLines;
  final TextStyle? style;

  @override
  State<PdpReadMore> createState() => _PdpReadMoreState();
}

class _PdpReadMoreState extends State<PdpReadMore> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DooryTypography.body(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: widget.trimLines,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              maxLines: _open ? null : widget.trimLines,
              overflow: _open ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (overflows || _open)
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsetsDirectional.zero,
                  minimumSize: const Size(44, 36),
                  foregroundColor: DooryColors.primary,
                ),
                onPressed: () => setState(() => _open = !_open),
                child: Text(_open ? PdpStrings.showLess : PdpStrings.showMore),
              ),
          ],
        );
      },
    );
  }
}

/// Tall photo pager with page dots, a «1/5» counter, and room for overlays.
/// Tapping a photo opens [showPdpFullscreenGallery].
class PdpGallery extends StatefulWidget {
  const PdpGallery({
    required this.urls,
    required this.name,
    this.overlays = const [],
    super.key,
  });

  final List<String> urls;
  final String name;
  final List<Widget> overlays;

  @override
  State<PdpGallery> createState() => _PdpGalleryState();
}

class _PdpGalleryState extends State<PdpGallery> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final urls = widget.urls;
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: ColoredBox(
        color: DooryColors.surface,
        child: Stack(
          children: [
            if (urls.isEmpty)
              Center(child: Icon(Icons.image_outlined, color: muted, size: 64))
            else
              PageView.builder(
                controller: _controller,
                itemCount: urls.length,
                onPageChanged: (value) => setState(() => _page = value),
                itemBuilder: (context, index) => Semantics(
                  image: true,
                  label: widget.name,
                  child: GestureDetector(
                    onTap: () async {
                      final landed = await showPdpFullscreenGallery(
                        context,
                        urls: urls,
                        initialIndex: index,
                      );
                      if (landed != null && landed != _page && mounted) {
                        _controller.jumpToPage(landed);
                      }
                    },
                    child: CachedNetworkImage(
                      imageUrl: urls[index],
                      fit: BoxFit.contain,
                      memCacheWidth: 900,
                      errorWidget: (context, url, error) =>
                          Icon(Icons.image_outlined, color: muted, size: 48),
                    ),
                  ),
                ),
              ),
            if (urls.length > 1) ...[
              PositionedDirectional(
                bottom: 12,
                start: 12,
                child: _CounterPill(
                  text: PdpStrings.photoCounter(_page + 1, urls.length),
                ),
              ),
              Positioned(
                bottom: 18,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < urls.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsetsDirectional.symmetric(
                            horizontal: 3,
                          ),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _page
                                ? DooryColors.textPrimary
                                : DooryColors.border,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            ...widget.overlays,
          ],
        ),
      ),
    );
  }
}

class _CounterPill extends StatelessWidget {
  const _CounterPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 10,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: DooryColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: DooryColors.border),
      ),
      child: Text(text, style: DooryTypography.cardMeta(context)),
    );
  }
}

/// Round white button that floats over the gallery (favorite, share).
class PdpRoundButton extends StatelessWidget {
  const PdpRoundButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
    this.color,
    super.key,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DooryColors.surface,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: DooryColors.shadowFavorite,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onTap,
        icon: Icon(icon, color: color ?? DooryColors.textPrimary, size: 22),
      ),
    );
  }
}

/// Full-screen photo viewer over the page. Pinch to zoom, swipe between
/// photos, tap a thumbnail to jump. Resolves to the last photo index.
Future<int?> showPdpFullscreenGallery(
  BuildContext context, {
  required List<String> urls,
  int initialIndex = 0,
}) {
  return showGeneralDialog<int>(
    context: context,
    barrierDismissible: true,
    barrierLabel: PdpStrings.closeGallery,
    barrierColor: Colors.black,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (dialogContext, animation, secondary) =>
        _FullscreenGallery(urls: urls, initialIndex: initialIndex),
    transitionBuilder: (context, animation, secondary, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

class _FullscreenGallery extends StatefulWidget {
  const _FullscreenGallery({required this.urls, required this.initialIndex});

  final List<String> urls;
  final int initialIndex;

  @override
  State<_FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<_FullscreenGallery> {
  late final PageController _controller = PageController(
    initialPage: widget.initialIndex,
  );
  late int _page = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.urls;
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: PdpStrings.closeGallery,
                  onPressed: () => Navigator.of(context).pop(_page),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16),
                  child: Text(
                    PdpStrings.photoCounter(_page + 1, urls.length),
                    style: DooryTypography.labelStrong(context)
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: urls.length,
                onPageChanged: (value) => setState(() => _page = value),
                itemBuilder: (context, index) => InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: urls[index],
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image_outlined,
                        color: Colors.white54,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              PdpStrings.zoomHint,
              style: DooryTypography.cardMeta(context, color: Colors.white70),
            ),
            if (urls.length > 1)
              SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsetsDirectional.all(8),
                  itemCount: urls.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    ),
                    child: Container(
                      width: 56,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: index == _page
                              ? DooryColors.primary
                              : Colors.white24,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        imageUrl: urls[index],
                        fit: BoxFit.cover,
                        memCacheWidth: 160,
                        errorWidget: (context, url, error) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
