import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import '../../core/format/date_format.dart';
import '../../core/format/price_format.dart';
import '../../core/l10n/pdp_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/chrome.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/catalog_models.dart';
import '../../data/models/commerce_models.dart';
import '../store/store_screen.dart';
import 'pdp_mock.dart';

/// Share options. Uses the live `share.url` / `share_text` from the product.
Future<void> showPdpShareSheet(
  BuildContext context, {
  required String? url,
  required String name,
}) {
  return showDoorySheet<void>(
    context,
    title: PdpStrings.shareTitle,
    scrollable: false,
    builder: (sheetContext) {
      if (url == null) {
        return const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
          child: Text(PdpStrings.noShareLink),
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: DooryTypography.label(sheetContext),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.link),
            title: const Text(PdpStrings.copyLink),
            subtitle: Text(
              url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.ltr,
            ),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: url));
              if (sheetContext.mounted) {
                Navigator.of(sheetContext).pop();
                showToast(context, PdpStrings.linkCopied);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.text_snippet_outlined),
            title: const Text(PdpStrings.copyShareText),
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: '$name\n$url'));
              if (sheetContext.mounted) {
                Navigator.of(sheetContext).pop();
                showToast(context, PdpStrings.textCopied);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      );
    },
  );
}

/// Delivery city picker (local only).
Future<String?> showPdpCitySheet(BuildContext context, String? current) {
  return showDoorySheet<String>(
    context,
    title: PdpStrings.chooseCity,
    builder: (sheetContext) => ListView(
      shrinkWrap: true,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: DemoLabel(),
          ),
        ),
        // BACKEND: AVAILABLE GET /cities (city list; delivery estimate per city: MISSING)
        for (final city in PdpMock.cities)
          ListTile(
            title: Text(city),
            trailing: city == current
                ? const Icon(Icons.check, color: DooryColors.primary)
                : null,
            onTap: () => Navigator.of(sheetContext).pop(city),
          ),
        const SizedBox(height: 16),
      ],
    ),
  );
}

Future<void> showPdpReturnSheet(BuildContext context) {
  return showDoorySheet<void>(
    context,
    title: PdpStrings.returnPolicyTitle,
    builder: (sheetContext) => ListView(
      shrinkWrap: true,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      children: [
        const Align(
          alignment: AlignmentDirectional.centerStart,
          child: DemoLabel(),
        ),
        const SizedBox(height: 8),
        // BACKEND: MISSING per-store return policy text
        for (final line in PdpMock.returnPolicy)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: DooryColors.success,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(line, style: DooryTypography.body(sheetContext)),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

Future<void> showPdpCampaignSheet(BuildContext context, PdpCampaign campaign) {
  return showDoorySheet<void>(
    context,
    title: PdpStrings.campaignsTitle,
    scrollable: false,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: AlignmentDirectional.centerStart,
            child: DemoLabel(),
          ),
          const SizedBox(height: 8),
          Text(
            campaign.title,
            style: DooryTypography.labelStrong(sheetContext),
          ),
          const SizedBox(height: 8),
          Text(campaign.detail, style: DooryTypography.body(sheetContext)),
          if (campaign.endsIn != null) ...[
            const SizedBox(height: 8),
            Text(
              PdpStrings.endsIn(campaign.endsIn!),
              style: DooryTypography.label(sheetContext)
                  .copyWith(color: DooryColors.primary),
            ),
          ],
          if (campaign.code != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 4, 4),
              decoration: BoxDecoration(
                color: DooryColors.primarySubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: DooryColors.primary),
              ),
              child: Row(
                children: [
                  Text(
                    '${PdpStrings.campaignCode}: ',
                    style: DooryTypography.label(sheetContext),
                  ),
                  Expanded(
                    child: Text(
                      campaign.code!,
                      style: DooryTypography.labelStrong(sheetContext),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: campaign.code!),
                      );
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                        showToast(context, PdpStrings.codeCopied);
                      }
                    },
                    child: const Text(PdpStrings.copyCode),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Option boxes like Trendyol's size chips. Used inline and in the sheet.
class PdpOptionBoxes extends StatelessWidget {
  const PdpOptionBoxes({
    required this.options,
    required this.selectedId,
    required this.onSelect,
    super.key,
  });

  final List<ProductOptionModel> options;
  final int? selectedId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          _OptionBox(
            option: option,
            selected: option.id == selectedId,
            onTap: option.available ? () => onSelect(option.id) : null,
          ),
      ],
    );
  }
}

class _OptionBox extends StatelessWidget {
  const _OptionBox({required this.option, required this.selected, this.onTap});

  final ProductOptionModel option;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Semantics(
      selected: selected,
      button: true,
      label:
          '${option.label} ${selected ? PdpStrings.selected : PdpStrings.notSelected}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          constraints: const BoxConstraints(minWidth: 56, minHeight: 44),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: selected ? DooryColors.primarySubtle : DooryColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? DooryColors.primary : DooryColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                option.label,
                style: DooryTypography.labelStrong(context).copyWith(
                  color: disabled ? DooryColors.textMuted : null,
                  decoration: disabled ? TextDecoration.lineThrough : null,
                ),
              ),
              if (option.lowStock && !disabled)
                Text(
                  PdpStrings.lowStock,
                  style: DooryTypography.cardMeta(
                    context,
                    color: DooryColors.danger,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Trendyol's add-to-cart sheet: product summary, option boxes, one button.
/// Resolves to the chosen option id, or null when dismissed.
Future<int?> showPdpVariantSheet(
  BuildContext context, {
  required ProductDetailModel product,
  required int? selectedId,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) =>
        _VariantSheet(product: product, selectedId: selectedId),
  );
}

class _VariantSheet extends StatefulWidget {
  const _VariantSheet({required this.product, required this.selectedId});

  final ProductDetailModel product;
  final int? selectedId;

  @override
  State<_VariantSheet> createState() => _VariantSheetState();
}

class _VariantSheetState extends State<_VariantSheet> {
  late int? _selected = widget.selectedId;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final photo = product.photoUrls.isEmpty ? null : product.photoUrls.first;
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.storeName != null)
                      Text(
                        product.storeName!,
                        style: DooryTypography.labelStrong(context),
                      ),
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: DooryTypography.label(context),
                    ),
                    const SizedBox(height: 6),
                    if (product.priceSyp != null)
                      Text(
                        formatSyp(product.priceSyp!),
                        style: DooryTypography.compactPrice(context)
                            .copyWith(color: DooryColors.primary),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 72,
                  height: 90,
                  child: photo == null
                      ? const ColoredBox(color: DooryColors.surfaceSubtle)
                      : CachedNetworkImage(
                          imageUrl: photo,
                          fit: BoxFit.cover,
                          memCacheWidth: 200,
                        ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Text(
            PdpStrings.optionsTitle,
            style: DooryTypography.section(context),
          ),
          const SizedBox(height: 10),
          PdpOptionBoxes(
            options: product.options,
            selectedId: _selected,
            onSelect: (id) => setState(() => _selected = id),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: DooryColors.primary,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _selected == null
                ? null
                : () => Navigator.of(context).pop(_selected),
            child: const Text(PdpStrings.addToCart),
          ),
        ],
      ),
    );
  }
}

class PdpQuestionCard extends StatefulWidget {
  const PdpQuestionCard({
    required this.question,
    this.sellerName,
    this.width,
    super.key,
  });

  final PdpQuestion question;
  final String? sellerName;
  final double? width;

  @override
  State<PdpQuestionCard> createState() => _PdpQuestionCardState();
}

class _PdpQuestionCardState extends State<PdpQuestionCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    return Container(
      width: widget.width,
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DooryColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  q.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DooryTypography.labelStrong(context),
                ),
              ),
              Text(q.date, style: DooryTypography.cardMeta(context)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            q.question,
            maxLines: _open ? null : 2,
            overflow: _open ? TextOverflow.visible : TextOverflow.ellipsis,
            style: DooryTypography.body(context),
          ),
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 6),
              child: Text(
                _open ? PdpStrings.showLess : PdpStrings.showMore,
                style: DooryTypography.label(context)
                    .copyWith(color: DooryColors.primary),
              ),
            ),
          ),
          if (q.answer != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsetsDirectional.all(10),
              decoration: BoxDecoration(
                color: DooryColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sellerName ?? PdpStrings.sellerAnswer,
                    style: DooryTypography.labelStrong(context),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    q.answer!,
                    maxLines: _open ? null : 2,
                    overflow: _open
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: DooryTypography.label(context),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> showPdpQuestionsSheet(
  BuildContext context, {
  required List<PdpQuestion> questions,
  String? sellerName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    PdpStrings.questionsTitle,
                    style: DooryTypography.section(context),
                  ),
                ),
                const DemoLabel(),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: controller,
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
              itemCount: questions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => PdpQuestionCard(
                question: questions[index],
                sellerName: sellerName,
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                onPressed: () => showPdpAskSheet(sheetContext),
                icon: const Icon(Icons.help_outline),
                label: const Text(PdpStrings.askQuestion),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Question form. Sending is not wired yet.
Future<void> showPdpAskSheet(BuildContext context) {
  return showDoorySheet<void>(
    context,
    title: PdpStrings.askQuestion,
    builder: (sheetContext) => _AskForm(parent: context),
  );
}

class _AskForm extends StatefulWidget {
  const _AskForm({required this.parent});

  final BuildContext parent;

  @override
  State<_AskForm> createState() => _AskFormState();
}

class _AskFormState extends State<_AskForm> {
  final _field = TextEditingController();

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _field,
            minLines: 3,
            maxLines: 5,
            maxLength: 300,
            decoration: const InputDecoration(
              hintText: PdpStrings.questionHint,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: _field.text.trim().isEmpty
                ? null
                : () {
                    Navigator.of(context).pop();
                    // BACKEND: AVAILABLE POST /products/{id}/questions (auth:sanctum; not wired)
                    showNotWired(
                      widget.parent,
                      feature: ShopStrings.questionFeature,
                    );
                  },
            child: const Text(PdpStrings.sendQuestion),
          ),
        ],
      ),
    );
  }
}

/// All reviews with a star filter that works in place.
Future<void> showPdpReviewsSheet(
  BuildContext context, {
  required List<Review> reviews,
  required double? averageRating,
  required int reviewsCount,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (sheetContext) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      builder: (context, controller) => _ReviewsSheet(
        reviews: reviews,
        averageRating: averageRating,
        reviewsCount: reviewsCount,
        controller: controller,
      ),
    ),
  );
}

class _ReviewsSheet extends StatefulWidget {
  const _ReviewsSheet({
    required this.reviews,
    required this.averageRating,
    required this.reviewsCount,
    required this.controller,
  });

  final List<Review> reviews;
  final double? averageRating;
  final int reviewsCount;
  final ScrollController controller;

  @override
  State<_ReviewsSheet> createState() => _ReviewsSheetState();
}

class _ReviewsSheetState extends State<_ReviewsSheet> {
  int? _stars;

  @override
  Widget build(BuildContext context) {
    final filtered = [
      for (final review in widget.reviews)
        if (_stars == null || review.rating == _stars) review,
    ];
    final average = widget.averageRating;
    return ListView(
      controller: widget.controller,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                PdpStrings.reviewsTitle,
                style: DooryTypography.section(context),
              ),
            ),
            const DemoLabel(),
          ],
        ),
        const SizedBox(height: 8),
        if (average != null)
          Row(
            children: [
              Text(
                average.toStringAsFixed(1),
                style: DooryTypography.page(context),
              ),
              const SizedBox(width: 8),
              StarsRow(rating: average.round(), size: 16),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  PdpStrings.ratingsCount(widget.reviewsCount),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: DooryTypography.label(context),
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: PdpStrings.allStars,
                selected: _stars == null,
                onTap: () => setState(() => _stars = null),
              ),
              for (var s = 5; s >= 1; s--)
                _FilterChip(
                  label: PdpStrings.stars(s),
                  icon: Icons.star_rounded,
                  selected: _stars == s,
                  onTap: () => setState(() => _stars = s),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 32),
            child: Center(
              child: Text(
                PdpStrings.noReviewsForFilter,
                style: DooryTypography.label(context),
              ),
            ),
          )
        else
          for (final review in filtered)
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 12),
              child: PdpReviewCard(review: review),
            ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: FilterChip(
        avatar: icon == null
            ? null
            : Icon(icon, size: 16, color: DooryColors.rating),
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: DooryColors.primarySubtle,
        side: BorderSide(
          color: selected ? DooryColors.primary : DooryColors.border,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class PdpReviewCard extends StatelessWidget {
  const PdpReviewCard({required this.review, this.width, super.key});

  final Review review;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DooryColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              StarsRow(rating: review.rating, size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  formatDate(review.createdAt),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: DooryTypography.cardMeta(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(review.authorName, style: DooryTypography.labelStrong(context)),
          if (review.comment != null) ...[
            const SizedBox(height: 4),
            Text(
              review.comment!,
              maxLines: width == null ? null : 3,
              overflow: width == null ? null : TextOverflow.ellipsis,
              style: DooryTypography.body(context),
            ),
          ],
        ],
      ),
    );
  }
}
