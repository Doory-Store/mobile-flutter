// Syrian mobile numbers, normalised exactly as the backend's
// `App\Domain\Identity\PhoneNormalizer::toE164` does for country SY, so the
// number the app sends is the number the server stores, throttles and
// verifies.

const _easternDigits = {
  '٠': '0', '١': '1', '٢': '2', '٣': '3', '٤': '4', //
  '٥': '5', '٦': '6', '٧': '7', '٨': '8', '٩': '9',
  '۰': '0', '۱': '1', '۲': '2', '۳': '3', '۴': '4',
  '۵': '5', '۶': '6', '۷': '7', '۸': '8', '۹': '9',
};

final _e164Syrian = RegExp(r'^\+9639\d{8}$');

/// Arabic-Indic and Persian digits → ASCII digits.
String westernDigits(String value) {
  final buffer = StringBuffer();
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_easternDigits[char] ?? char);
  }
  return buffer.toString();
}

/// `+9639XXXXXXXX`, or null when [input] is not a Syrian mobile.
///
/// Accepts 09XXXXXXXX, 9XXXXXXXX, 9639…, +9639…, 009639…, with spaces,
/// dashes, brackets and Eastern Arabic digits.
String? normalizeSyrianMobile(String input) {
  var compact = westernDigits(input.trim()).replaceAll(RegExp(r'[^\d+]'), '');
  if (compact.isEmpty) return null;
  if (compact.startsWith('00')) compact = '+${compact.substring(2)}';
  if (compact.startsWith('0')) {
    compact = '+963${compact.substring(1)}';
  } else if (RegExp(r'^9\d{8}$').hasMatch(compact)) {
    compact = '+963$compact';
  } else if (compact.startsWith('963')) {
    compact = '+$compact';
  }
  return _e164Syrian.hasMatch(compact) ? compact : null;
}

/// «+963 944 111 222» for display.
String formatPhone(String e164) {
  if (!e164.startsWith('+963') || e164.length != 13) return e164;
  final rest = e164.substring(4);
  return '\u2066+963 ${rest.substring(0, 3)} ${rest.substring(3, 6)} ${rest.substring(6)}\u2069';
}
