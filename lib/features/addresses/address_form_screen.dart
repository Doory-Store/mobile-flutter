import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/doory_strings.dart';
import '../../core/l10n/shop_strings.dart';
import '../../core/theme/doory_colors.dart';
import '../../core/theme/doory_typography.dart';
import '../../core/widgets/ui_kit.dart';
import '../../data/models/commerce_models.dart';
import '../../data/repositories/commerce/commerce_contracts.dart';
import '../account/account_providers.dart';

/// Add (`id == null`) or edit an address: label, city, neighborhood,
/// landmark. Map pinning names its endpoint and is not wired.
class AddressFormScreen extends ConsumerStatefulWidget {
  const AddressFormScreen({this.id, super.key});

  final int? id;

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _form = GlobalKey<FormState>();
  final _label = TextEditingController();
  final _landmark = TextEditingController();
  Neighborhood? _hood;
  BuyerAddress? _original;
  bool _busy = false;
  bool _seeded = false;
  String _labelChoice = 'المنزل';

  static const _labels = ['المنزل', 'العمل', 'أخرى'];

  @override
  void dispose() {
    _label.dispose();
    _landmark.dispose();
    super.dispose();
  }

  void _seed(List<BuyerAddress> items, List<Neighborhood> hoods) {
    if (_seeded) return;
    _seeded = true;
    if (widget.id == null) return;
    final address = items.where((item) => item.id == widget.id).firstOrNull;
    if (address == null) return;
    _original = address;
    final label = address.label ?? '';
    if (_labels.contains(label)) {
      _labelChoice = label;
    } else {
      _labelChoice = 'أخرى';
      _label.text = label;
    }
    _landmark.text = address.landmark ?? '';
    _hood = hoods.where((h) => h.id == address.neighborhoodId).firstOrNull;
  }

  Future<void> _pickHood(List<Neighborhood> hoods) async {
    final picked = await showDoorySheet<Neighborhood>(
      context,
      title: ShopStrings.chooseNeighborhood,
      builder: (context) => _NeighborhoodPicker(hoods: hoods, selected: _hood),
    );
    if (picked != null) setState(() => _hood = picked);
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    if (_hood == null) {
      showToast(context, ShopStrings.chooseNeighborhood);
      return;
    }
    setState(() => _busy = true);
    final label = _labelChoice == 'أخرى' ? _label.text.trim() : _labelChoice;
    final base =
        _original ?? const BuyerAddress(id: 0, lat: 34.7324, lng: 36.7137);
    try {
      await ref
          .read(addressesProvider.notifier)
          .save(
            base.copyWith(
              label: label.isEmpty ? 'أخرى' : label,
              landmark: _landmark.text.trim(),
              neighborhoodId: _hood!.id,
              neighborhoodName: _hood!.name,
            ),
          );
      if (!mounted) return;
      showToast(context, ShopStrings.addressSaved);
      context.pop();
    } on DomainRejection catch (error) {
      if (mounted) showToast(context, error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addresses = ref.watch(addressesProvider).asData?.value ?? const [];
    final hoods = ref.watch(neighborhoodsProvider);
    final hoodList = hoods.asData?.value ?? const <Neighborhood>[];
    if (hoods.hasValue) _seed(addresses, hoodList);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? ShopStrings.addAddress : ShopStrings.editAddress,
        ),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsetsDirectional.only(bottom: 24),
          children: [
            const MockBanner(),
            const SizedBox(height: 12),
            SectionCard(
              title: ShopStrings.addressLabel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final label in _labels)
                        ChoiceChip(
                          label: Text(label),
                          selected: _labelChoice == label,
                          onSelected: (_) =>
                              setState(() => _labelChoice = label),
                        ),
                    ],
                  ),
                  if (_labelChoice == 'أخرى') ...[
                    const SizedBox(height: 12),
                    DooryTextField(
                      label: ShopStrings.customLabel,
                      controller: _label,
                      hint: ShopStrings.customLabelHint,
                      maxLength: 30,
                    ),
                  ],
                ],
              ),
            ),
            SectionCard(
              title: ShopStrings.location,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InfoRow(label: ShopStrings.city, value: 'حمص', strong: true),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: hoods.isLoading
                        ? null
                        : () => _pickHood(hoodList),
                    icon: const Icon(Icons.map_outlined),
                    label: Text(_hood?.name ?? ShopStrings.chooseNeighborhood),
                  ),
                  const SizedBox(height: 12),
                  DooryTextField(
                    label: ShopStrings.landmark,
                    controller: _landmark,
                    hint: ShopStrings.landmarkHint,
                    maxLines: 2,
                    maxLength: 120,
                    validator: (value) =>
                        (value == null || value.trim().length < 3)
                        ? ShopStrings.landmarkInvalid
                        : null,
                  ),
                  TextButton.icon(
                    onPressed: () => showNotWired(
                      context,
                      feature: ShopStrings.mapPinFeature,
                    ),
                    icon: const Icon(Icons.my_location),
                    label: const Text(ShopStrings.pinOnMap),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: DooryPrimaryButton(
                label: ShopStrings.saveAddress,
                busy: _busy,
                onPressed: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NeighborhoodPicker extends StatefulWidget {
  const _NeighborhoodPicker({required this.hoods, this.selected});

  final List<Neighborhood> hoods;
  final Neighborhood? selected;

  @override
  State<_NeighborhoodPicker> createState() => _NeighborhoodPickerState();
}

class _NeighborhoodPickerState extends State<_NeighborhoodPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final shown = [
      for (final hood in widget.hoods)
        if (_query.isEmpty || hood.name.contains(_query)) hood,
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
          child: TextField(
            onChanged: (value) => setState(() => _query = value.trim()),
            decoration: const InputDecoration(
              hintText: ShopStrings.searchNeighborhood,
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final hood in shown)
                ListTile(
                  title: Text(hood.name),
                  subtitle: hood.isOpen
                      ? null
                      : Text(
                          ShopStrings.areaComingSoon,
                          style: DooryTypography.cardMeta(context),
                        ),
                  enabled: hood.isOpen,
                  trailing: widget.selected?.id == hood.id
                      ? const Icon(
                          Icons.check,
                          color: DooryColors.primaryStrong,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(hood),
                ),
              if (shown.isEmpty)
                const Padding(
                  padding: EdgeInsetsDirectional.all(24),
                  child: Text(
                    DooryStrings.noResults,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
