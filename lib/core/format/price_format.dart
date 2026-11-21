/// Latin digits and the currency label «ل.س», isolated so RTL stays stable.
String formatSyp(int amount) {
  final negative = amount < 0;
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  final sign = negative ? '-' : '';
  return '\u2066$sign$buffer ل.س\u2069';
}

String productSemantics({
  required String name,
  String? storeName,
  int? priceSyp,
  bool priceIsEstimate = false,
  bool available = true,
  bool canPurchase = true,
  double? rating,
}) {
  final parts = <String>[
    if (storeName != null && storeName.isNotEmpty) storeName,
    name,
    if (priceSyp != null) formatSyp(priceSyp),
    if (priceIsEstimate) 'سعر تقريبي',
    if (!available) 'نفدت الكمية',
    if (available && !canPurchase) 'غير متاح للشراء حاليًا',
    if (rating != null) 'التقييم ${rating.toStringAsFixed(1)}',
  ];
  return parts.join('، ');
}
