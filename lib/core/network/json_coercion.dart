/// Tolerant JSON helpers. Live payloads omit fields and sometimes send null.
int? intOrNull(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

double? doubleOrNull(Object? value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.trim());
  return null;
}

bool? boolOrNull(Object? value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    switch (value.trim().toLowerCase()) {
      case 'true':
      case '1':
      case 'yes':
        return true;
      case 'false':
      case '0':
      case 'no':
        return false;
    }
  }
  return null;
}

String? stringOrNull(Object? value) {
  if (value == null) return null;
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  if (value is num || value is bool) return value.toString();
  return null;
}

/// Accepts a URL string or an object with url/src/path/image.
String? photoUrlOrNull(Object? value) {
  if (value == null) return null;
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  if (value is Map) {
    for (final key in const [
      'url',
      'src',
      'original',
      'large',
      'path',
      'image',
    ]) {
      final found = photoUrlOrNull(value[key]);
      if (found != null) return found;
    }
  }
  return null;
}

Map<String, String> stringMapOrEmpty(Object? value) {
  if (value is! Map) return const {};
  final out = <String, String>{};
  value.forEach((key, item) {
    final text = stringOrNull(item);
    if (text != null) out[key.toString()] = text;
  });
  return out;
}

List<String> photoListFromJson(Object? value) {
  if (value is! List) return const [];
  final out = <String>[];
  for (final item in value) {
    final url = photoUrlOrNull(item);
    if (url != null) out.add(url);
  }
  return out;
}

List<Map<String, dynamic>> photoListToJson(List<String>? value) => [
  for (final url in value ?? const <String>[]) {'url': url},
];
