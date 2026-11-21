// Redaction for anything that leaves the process as text: debug logs, error
// messages, crash breadcrumbs. Bearer tokens, one-time codes, passwords and
// phone numbers are replaced before a string is built, so they never reach
// logcat, the console or a crash report.

const redactedMark = '«redacted»';

/// Header names whose values are secrets. Compared case-insensitively.
const sensitiveHeaders = {
  'authorization',
  'cookie',
  'set-cookie',
  'x-xsrf-token',
  'x-csrf-token',
};

/// JSON keys whose values are secrets or personal data.
const sensitiveKeys = {
  'token',
  'access_token',
  'refresh_token',
  'plain_text_token',
  'code',
  'otp',
  'simulation_code',
  'password',
  'password_confirmation',
  'current_password',
  'phone',
  'referral_code',
};

/// Syrian mobiles in any common spelling: +9639…, 009639…, 9639…, 09…, 9….
final _phonePattern = RegExp(r'(?:\+|00)?(?:963)?0?9\d{8}');

/// Bearer credentials embedded in free text.
final _bearerPattern = RegExp(r'Bearer\s+[^\s,;"]+', caseSensitive: false);

/// Masks phone numbers and bearer credentials inside free text.
String redactText(String input) {
  return input
      .replaceAll(_bearerPattern, 'Bearer $redactedMark')
      .replaceAll(_phonePattern, redactedMark);
}

Map<String, Object?> redactHeaders(Map<String, Object?> headers) {
  return {
    for (final entry in headers.entries)
      entry.key: sensitiveHeaders.contains(entry.key.toLowerCase())
          ? redactedMark
          : entry.value,
  };
}

/// Deep copy of a JSON-like value with sensitive keys masked and phone
/// numbers removed from every remaining string.
Object? redactBody(Object? body) {
  if (body is Map) {
    return {
      for (final entry in body.entries)
        '${entry.key}': sensitiveKeys.contains('${entry.key}'.toLowerCase())
            ? redactedMark
            : redactBody(entry.value),
    };
  }
  if (body is List) return [for (final item in body) redactBody(item)];
  if (body is String) return redactText(body);
  return body;
}

/// URL with sensitive query parameters masked.
String redactUri(Uri uri) {
  if (uri.queryParameters.isEmpty) return redactText(uri.toString());
  final query = {
    for (final entry in uri.queryParameters.entries)
      entry.key: sensitiveKeys.contains(entry.key.toLowerCase())
          ? redactedMark
          : redactText(entry.value),
  };
  return redactText(uri.replace(queryParameters: query).toString());
}
