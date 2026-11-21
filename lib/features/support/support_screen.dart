import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/date_format.dart';
import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';
import '../../data/repositories/commerce/commerce_providers.dart';
import '../account/account_providers.dart';
import '../auth/session_controller.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final articles = ref.watch(helpArticlesProvider);
    final signedIn = ref.watch(sessionProvider).signedIn;
    final repo = ref.watch(engagementRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(ShopStrings.helpSupport)),
      body: ListView(
        padding: const EdgeInsetsDirectional.only(bottom: 24),
        children: [
          const MockBanner(),
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _query = value.trim()),
              decoration: const InputDecoration(
                hintText: ShopStrings.searchHelp,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SectionCard(
            title: ShopStrings.faq,
            padding: const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 8),
            child: articles.when(
              loading: () => const LinearProgressIndicator(),
              error: (error, stack) => const Text(DooryStrings.unavailable),
              data: (items) {
                final shown = [
                  for (final item in items)
                    if (_query.isEmpty ||
                        item.title.contains(_query) ||
                        item.body.contains(_query))
                      item,
                ];
                if (shown.isEmpty) {
                  return const Padding(
                    padding: EdgeInsetsDirectional.all(16),
                    child: Text(DooryStrings.noResults),
                  );
                }
                return Column(
                  children: [
                    for (final article in shown) _ArticleTile(article: article),
                  ],
                );
              },
            ),
          ),
          SectionCard(
            title: ShopStrings.contactUs,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.chat_outlined,
                    color: DooryColors.primaryStrong,
                  ),
                  title: const Text(ShopStrings.whatsapp),
                  subtitle: Text(
                    repo.supportWhatsapp,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.end,
                  ),
                  onTap: () => showNotWired(
                    context,
                    feature: ShopStrings.openWhatsappFeature,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.call_outlined,
                    color: DooryColors.primaryStrong,
                  ),
                  title: const Text(ShopStrings.callUs),
                  subtitle: Text(
                    repo.supportPhone,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.end,
                  ),
                  trailing: IconButton(
                    tooltip: ShopStrings.copy,
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: repo.supportPhone),
                      );
                      if (context.mounted) {
                        showToast(context, ShopStrings.copied);
                      }
                    },
                  ),
                  onTap: () =>
                      showNotWired(context, feature: ShopStrings.dialFeature),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.confirmation_number_outlined,
                    color: DooryColors.primaryStrong,
                  ),
                  title: const Text(ShopStrings.newTicket),
                  onTap: () => context.push(
                    signedIn ? '/support/new' : '/login?next=/support/new',
                  ),
                ),
              ],
            ),
          ),
          if (signedIn) const _Tickets(),
        ],
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({required this.article});

  final HelpArticle article;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      title: Text(article.title, style: DooryTypography.labelStrong(context)),
      subtitle: Text(
        article.category,
        style: DooryTypography.cardMeta(context),
      ),
      childrenPadding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
      expandedAlignment: AlignmentDirectional.centerStart,
      children: [Text(article.body, style: DooryTypography.body(context))],
    );
  }
}

class _Tickets extends ConsumerWidget {
  const _Tickets();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(ticketsProvider);
    return SectionCard(
      title: ShopStrings.myTickets,
      child: tickets.when(
        loading: () => const LinearProgressIndicator(),
        error: (error, stack) => const Text(DooryStrings.unavailable),
        data: (items) => items.isEmpty
            ? Text(ShopStrings.noTickets, style: DooryTypography.label(context))
            : Column(
                children: [
                  for (final ticket in items)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(ticket.subject),
                      subtitle: Text(formatDate(ticket.createdAt)),
                      trailing: StatusPill(
                        label: ticket.statusLabel,
                        tone: ticket.status == 'resolved'
                            ? PillTone.success
                            : PillTone.info,
                      ),
                      onTap: () => showNotWired(
                        context,
                        feature: ShopStrings.ticketThreadFeature,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
