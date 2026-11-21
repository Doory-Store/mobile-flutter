enum AppFlavor {
  dev,
  staging,
  prod;

  static AppFlavor parse(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'staging':
        return AppFlavor.staging;
      case 'prod':
      case 'production':
        return AppFlavor.prod;
      default:
        return AppFlavor.dev;
    }
  }

  String get label => switch (this) {
    AppFlavor.dev => 'dev',
    AppFlavor.staging => 'staging',
    AppFlavor.prod => 'prod',
  };
}

/// Compile-time environment. Defaults let `flutter run` reach the buyer API
/// with no flags. Android product flavors are not wired; see INCOMPLETE.md.
class AppConfig {
  const AppConfig({
    required this.baseUrl,
    required this.timeout,
    required this.flavor,
  });

  final String baseUrl;
  final Duration timeout;
  final AppFlavor flavor;

  bool get hasBaseUrl => baseUrl.isNotEmpty;

  static const defaultBaseUrl = 'https://doory.elogyc.com/api/v1';
  static const defaultTimeoutMs = 4000;

  factory AppConfig.fromEnvironment() {
    const rawUrl = String.fromEnvironment(
      'DOORY_API_BASE_URL',
      defaultValue: defaultBaseUrl,
    );
    const rawTimeout = int.fromEnvironment(
      'DOORY_API_TIMEOUT_MS',
      defaultValue: defaultTimeoutMs,
    );
    const rawFlavor = String.fromEnvironment(
      'DOORY_FLAVOR',
      defaultValue: 'dev',
    );
    return AppConfig(
      baseUrl: normalizeBaseUrl(rawUrl),
      timeout: Duration(
        milliseconds: rawTimeout <= 0 ? defaultTimeoutMs : rawTimeout,
      ),
      flavor: AppFlavor.parse(rawFlavor),
    );
  }

  static String normalizeBaseUrl(String raw) {
    var value = raw.trim();
    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }
}
