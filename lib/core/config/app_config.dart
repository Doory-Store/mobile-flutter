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

/// Which auth repository backs the session. `live` talks to the buyer API;
/// `mock` keeps the offline demo (code 482910) for tests and demos.
enum AuthMode {
  live,
  mock;

  static AuthMode parse(String raw) =>
      raw.trim().toLowerCase() == 'mock' ? AuthMode.mock : AuthMode.live;
}

/// Compile-time environment. Defaults let `flutter run` reach the buyer API
/// with no flags. Android product flavors are not wired; see INCOMPLETE.md.
class AppConfig {
  const AppConfig({
    required this.baseUrl,
    required this.timeout,
    required this.flavor,
    this.authMode = AuthMode.live,
    this.allowInsecureHttp = false,
  });

  final String baseUrl;
  final Duration timeout;
  final AppFlavor flavor;
  final AuthMode authMode;

  /// Debug and profile builds may point at a local `http://` backend. Release
  /// builds never do: [resolveBaseUrl] drops any non-https URL.
  final bool allowInsecureHttp;

  bool get hasBaseUrl => baseUrl.isNotEmpty;

  /// The API origin the bearer token belongs to. Requests to any other host
  /// (image CDNs, third parties) never carry it.
  Uri? get apiUri => hasBaseUrl ? Uri.tryParse(baseUrl) : null;

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
    const rawAuth = String.fromEnvironment('DOORY_AUTH', defaultValue: 'live');
    const release = bool.fromEnvironment('dart.vm.product');
    return AppConfig(
      baseUrl: resolveBaseUrl(rawUrl, release: release),
      timeout: Duration(
        milliseconds: rawTimeout <= 0 ? defaultTimeoutMs : rawTimeout,
      ),
      flavor: AppFlavor.parse(rawFlavor),
      authMode: AuthMode.parse(rawAuth),
      allowInsecureHttp: !release,
    );
  }

  /// Normalised base URL, or '' when it is unusable. Release builds accept
  /// `https://` only, so a token can never travel in clear text.
  static String resolveBaseUrl(String raw, {required bool release}) {
    final value = normalizeBaseUrl(raw);
    final uri = Uri.tryParse(value);
    if (uri == null || uri.host.isEmpty) return '';
    if (uri.scheme == 'https') return value;
    if (uri.scheme == 'http' && !release) return value;
    return '';
  }

  static String normalizeBaseUrl(String raw) {
    var value = raw.trim();
    while (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }
}
