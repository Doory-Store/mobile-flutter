import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/catalog_models.dart';
import '../../data/models/commerce_models.dart';
import '../../data/repositories/commerce/commerce_contracts.dart';
import '../../data/repositories/commerce/commerce_providers.dart';

class CartState {
  const CartState({
    this.snapshot = const CartSnapshot(),
    this.summary = CartSummary.empty,
    this.loading = true,
    this.busyLineIds = const {},
    this.sample = true,
  });

  final CartSnapshot snapshot;
  final CartSummary summary;
  final bool loading;
  final Set<int> busyLineIds;
  final bool sample;

  CartState copyWith({
    CartSnapshot? snapshot,
    CartSummary? summary,
    bool? loading,
    Set<int>? busyLineIds,
  }) {
    return CartState(
      snapshot: snapshot ?? this.snapshot,
      summary: summary ?? this.summary,
      loading: loading ?? this.loading,
      busyLineIds: busyLineIds ?? this.busyLineIds,
      sample: sample,
    );
  }
}

/// Cart state for the whole app. Totals always come from [CartCalculator].
class CartController extends Notifier<CartState> {
  CartRepository get _repo => ref.read(cartRepositoryProvider);

  @override
  CartState build() {
    final repo = ref.watch(cartRepositoryProvider);
    Future.microtask(_load);
    return CartState(sample: repo.isSample);
  }

  Future<void> _load() async {
    final snapshot = await _repo.load();
    _apply(snapshot);
  }

  void _apply(CartSnapshot snapshot, {Set<int>? busy}) {
    state = state.copyWith(
      snapshot: snapshot,
      summary: CartCalculator.summarize(
        snapshot.lines,
        deliveryFeePerStoreSyp: _repo.deliveryFeePerStoreSyp,
        coupons: snapshot.coupons,
      ),
      loading: false,
      busyLineIds: busy ?? const {},
    );
  }

  Future<void> add(CartLineDraft draft) async {
    _apply(await _repo.addLine(draft));
  }

  Future<void> setQuantity(int lineId, int quantity) async {
    state = state.copyWith(busyLineIds: {...state.busyLineIds, lineId});
    _apply(await _repo.updateQuantity(lineId, quantity));
  }

  /// Removes a line and returns it so the screen can offer «تراجع».
  Future<CartLine?> remove(int lineId) async {
    final line = state.snapshot.lines
        .where((item) => item.id == lineId)
        .firstOrNull;
    _apply(await _repo.removeLine(lineId));
    return line;
  }

  Future<void> restore(CartLine line) async {
    await add(
      CartLineDraft(
        product: cardFromLine(line),
        quantity: line.quantity,
        optionId: line.productOptionId,
        optionLabel: line.optionLabel,
        storeId: line.storeId,
      ),
    );
  }

  /// Null on success, otherwise the shopper-facing reason.
  Future<String?> applyCoupon(String code) async {
    try {
      _apply(await _repo.applyCoupon(code));
      return null;
    } on DomainRejection catch (error) {
      return error.message;
    }
  }

  Future<void> removeCoupon(String code) async {
    _apply(await _repo.removeCoupon(code));
  }

  Future<void> clear() async {
    _apply(await _repo.clear());
  }

  /// Adds every line of a past order back to the cart.
  Future<int> reorder(OrderDetail order) async {
    var added = 0;
    for (final line in order.lines) {
      await _repo.addLine(
        CartLineDraft(
          product: ProductCardModel(
            id: line.productId ?? line.id,
            slug: '${line.productId ?? line.id}',
            name: line.productName,
            storeName: order.summary.storeName,
            priceSyp: line.unitPriceSyp,
          ),
          quantity: line.quantity,
          optionLabel: line.optionLabel,
          storeId: order.summary.storeName.hashCode.abs(),
        ),
      );
      added += line.quantity;
    }
    _apply(await _repo.load());
    return added;
  }
}

ProductCardModel cardFromLine(CartLine line) {
  return ProductCardModel(
    id: line.productId,
    slug: line.productRef ?? '${line.productId}',
    name: line.productName,
    photoUrl: line.photoUrl,
    storeName: line.storeName,
    storeSlug: line.storeSlug,
    available: line.available,
    priceSyp: line.priceSyp,
    priceIsEstimate: line.priceIsEstimate,
    canPurchase: line.canPurchase,
  );
}

final cartProvider = NotifierProvider<CartController, CartState>(
  CartController.new,
);

/// Badge count: total quantity across lines.
final cartCountProvider = Provider<int>(
  (ref) => ref.watch(cartProvider.select((state) => state.summary.itemCount)),
);
