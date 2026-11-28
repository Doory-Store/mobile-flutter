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

/// Grouped Latin digits with no currency label (struck compare-at prices).
String formatSypDigits(int amount) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer(amount < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '\u2066$buffer\u2069';
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

/// Compact Latin count: 1247 → «1.2 ألف», 1200000 → «1.2 مليون».
String formatCompactCount(int count) {
  final negative = count < 0;
  final value = count.abs();
  final String text;
  if (value >= 1000000) {
    text = _compactNumber(value / 1000000, 'مليون');
  } else if (value >= 1000) {
    text = _compactNumber(value / 1000, 'ألف');
  } else {
    text = '$value';
  }
  final signed = negative ? '-$text' : text;
  return '\u2066$signed\u2069';
}

String _compactNumber(double value, String unit) {
  final rounded = (value * 10).round() / 10;
  final digits = rounded == rounded.truncateToDouble()
      ? '${rounded.toInt()}'
      : rounded.toStringAsFixed(1);
  return '$digits $unit';
}
