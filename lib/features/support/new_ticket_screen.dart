import 'package:material_ui/material_ui.dart';

import '../../core/l10n/shop_strings.dart';
import '../../core/widgets/ui_kit.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({this.orderId, super.key});

  final String? orderId;

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {
  final _form = GlobalKey<FormState>();
  final _subject = TextEditingController();
  final _message = TextEditingController();
  String _topic = ShopStrings.ticketTopics.first;

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.orderId;
    return Scaffold(
      appBar: AppBar(title: const Text(ShopStrings.newTicket)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsetsDirectional.only(bottom: 24),
          children: [
            const MockBanner(),
            const SizedBox(height: 12),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (order != null) ...[
                    InfoRow(
                      label: ShopStrings.linkedOrder,
                      value: (order.length > 8 ? order.substring(0, 8) : order)
                          .toUpperCase(),
                      strong: true,
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    ShopStrings.ticketTopic,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final topic in ShopStrings.ticketTopics)
                        ChoiceChip(
                          label: Text(topic),
                          selected: _topic == topic,
                          onSelected: (_) => setState(() => _topic = topic),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DooryTextField(
                    label: ShopStrings.ticketSubject,
                    controller: _subject,
                    maxLength: 80,
                    validator: (value) =>
                        (value == null || value.trim().length < 4)
                        ? ShopStrings.subjectInvalid
                        : null,
                  ),
                  const SizedBox(height: 8),
                  DooryTextField(
                    label: ShopStrings.ticketMessage,
                    controller: _message,
                    maxLines: 5,
                    maxLength: 1000,
                    hint: ShopStrings.ticketMessageHint,
                    validator: (value) =>
                        (value == null || value.trim().length < 10)
                        ? ShopStrings.messageInvalid
                        : null,
                  ),
                  TextButton.icon(
                    onPressed: () => showNotWired(
                      context,
                      feature: ShopStrings.attachmentsFeature,
                    ),
                    icon: const Icon(Icons.attach_file),
                    label: const Text(ShopStrings.attachPhoto),
                  ),
                  const SizedBox(height: 8),
                  DooryPrimaryButton(
                    label: ShopStrings.sendTicket,
                    onPressed: () {
                      if (!(_form.currentState?.validate() ?? false)) return;
                      showNotWired(context, feature: ShopStrings.ticketFeature);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
