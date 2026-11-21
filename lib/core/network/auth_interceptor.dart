import 'package:dio/dio.dart';

/// Marks a request that left with the buyer's bearer token.
const authExtraKey = 'doory.auth.attached';

/// Attaches `Authorization: Bearer …` to calls that target the configured
/// buyer API and to nothing else.
///
/// The token is scoped by origin and path prefix: scheme, host, port and the
/// `/api/v1` base path must all match. Absolute URLs to image hosts or third
/// parties go out without it, and any Authorization header a caller set by
/// hand is stripped from them. Requests that carry the token do not follow
/// redirects, so the header cannot be replayed to another host.
///
/// A 401 on a request that carried the token means the server revoked or
/// expired it (Sanctum tokens live 30 days and the API has no refresh
/// endpoint), so [onUnauthorized] clears the session and the app routes to
/// sign-in.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.apiUri,
    required this.readToken,
    required this.onUnauthorized,
    this.allowInsecureHttp = false,
  });

  final Uri? apiUri;
  final String? Function() readToken;
  final void Function() onUnauthorized;
  final bool allowInsecureHttp;

  /// True when [uri] belongs to the buyer API origin and path.
  bool isApiRequest(Uri uri) {
    final api = apiUri;
    if (api == null || api.host.isEmpty) return false;
    final secure =
        uri.scheme == 'https' || (allowInsecureHttp && uri.scheme == 'http');
    if (!secure || uri.scheme != api.scheme) return false;
    if (uri.host.toLowerCase() != api.host.toLowerCase()) return false;
    if (uri.port != api.port) return false;
    final base = api.path.endsWith('/') ? api.path : '${api.path}/';
    return uri.path == api.path || uri.path.startsWith(base);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.removeWhere(
      (key, _) => key.toLowerCase() == 'authorization',
    );
    options.extra.remove(authExtraKey);
    final token = readToken();
    if (token != null && token.isNotEmpty && isApiRequest(options.uri)) {
      options.headers['Authorization'] = 'Bearer $token';
      options.extra[authExtraKey] = true;
      options.followRedirects = false;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final carriedToken = err.requestOptions.extra[authExtraKey] == true;
    if (carriedToken && err.response?.statusCode == 401) {
      onUnauthorized();
    }
    handler.next(err);
  }
}
