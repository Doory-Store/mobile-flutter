import '../../../core/network/api_exception.dart';
import '../../../core/network/api_transport.dart';
import '../../models/commerce_models.dart';
import 'commerce_contracts.dart';

/// Buyer authentication against the live API.
///
/// | Call | Endpoint | Success |
/// | --- | --- | --- |
/// | [requestOtp] | `POST /auth/otp {phone, purpose: login}` | 202 `{expires_in, simulation_code?}` |
/// | [verifyOtp] | `POST /auth/otp/verify {phone, code, purpose: login}` | 200 `{token, token_type, user}` |
/// | [loginWithPassword] | `POST /auth/login {phone, password}` | 200 `{token, token_type, user}` |
/// | [me] | `GET /me` | 200 `{id, phone, email, name, roles}` |
/// | [updateName] | `PATCH /me {name}` | 200 `BuyerMe` |
/// | [logout] | `POST /auth/logout` | 204 |
///
/// The bearer token is attached by `AuthInterceptor`, never here. Every
/// server failure is translated into a [DomainRejection] with Arabic copy.
class LiveAuthRepository implements AuthRepository {
  LiveAuthRepository(this._transport);

  final ApiTransport _transport;

  static const purpose = 'login';

  @override
  bool get isSample => false;

  @override
  Future<OtpChallenge> requestOtp(String phone) async {
    final response = await _guard(
      () => _transport.send(
        'POST',
        '/auth/otp',
        body: {'phone': phone, 'purpose': purpose},
      ),
    );
    return OtpChallenge.fromJson(
      phone,
      _map(response.data),
      remainingSends: int.tryParse(
        response.header('x-ratelimit-remaining') ?? '',
      ),
    );
  }

  @override
  Future<BuyerSession> verifyOtp(String phone, String code) async {
    final response = await _guard(
      () => _transport.send(
        'POST',
        '/auth/otp/verify',
        body: {'phone': phone, 'code': code.trim(), 'purpose': purpose},
      ),
    );
    return _session(response.data);
  }

  @override
  Future<BuyerSession> loginWithPassword(String phone, String password) async {
    final ApiResponse response;
    try {
      response = await _transport.send(
        'POST',
        '/auth/login',
        body: {'phone': phone, 'password': password},
      );
    } on ApiException catch (error) {
      // The contract documents 401 for bad credentials; the server sends 422
      // `errors.credentials`. Both read the same to the shopper.
      if (error.kind == ApiFailureKind.unauthorized) {
        throw const DomainRejection(AuthErrors.credentials);
      }
      throw AuthErrors.map(error);
    }
    return _session(response.data);
  }

  @override
  Future<BuyerUser> me() async {
    final response = await _guard(() => _transport.send('GET', '/me'));
    return BuyerUser.fromJson(_unwrap(response.data));
  }

  @override
  Future<BuyerUser> updateName(String name) async {
    final response = await _guard(
      () => _transport.send('PATCH', '/me', body: {'name': name.trim()}),
    );
    return BuyerUser.fromJson(_unwrap(response.data));
  }

  /// Revokes the presenting token. A 401 means it is already gone, which is
  /// the outcome logout wants.
  @override
  Future<void> logout() async {
    try {
      await _transport.send('POST', '/auth/logout');
    } on ApiException catch (error) {
      if (error.kind == ApiFailureKind.unauthorized) return;
      throw AuthErrors.map(error);
    }
  }

  BuyerSession _session(Object? data) {
    final session = BuyerSession.fromJson(_map(data));
    if (session.token.isEmpty || session.user.id == 0) {
      throw const DomainRejection(AuthErrors.unexpected);
    }
    return session;
  }

  static Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ApiException catch (error) {
      throw AuthErrors.map(error);
    }
  }

  static Map<String, dynamic> _map(Object? data) =>
      data is Map ? Map<String, dynamic>.from(data) : const {};

  /// `/me` is a Laravel JsonResource; accept it with or without `data`.
  static Map<String, dynamic> _unwrap(Object? data) {
    final map = _map(data);
    final inner = map['data'];
    if (inner is Map && !map.containsKey('id')) {
      return Map<String, dynamic>.from(inner);
    }
    return map;
  }
}

/// Server failures → shopper-facing Arabic.
abstract final class AuthErrors {
  static const network =
      'تعذّر الاتصال بالخادم. تحقّق من اتصالك بالإنترنت ثم أعد المحاولة.';
  static const server = 'حدث خطأ في الخادم. أعد المحاولة بعد قليل.';
  static const unexpected = 'تعذّر إكمال الدخول. أعد المحاولة.';
  static const phoneInvalid = 'أدخل رقم جوال سوري صحيحًا، مثل 0944123456.';
  static const codeInvalid = 'الرمز غير صحيح. تحقّق منه ثم أعد المحاولة.';
  static const codeExpired = 'انتهت صلاحية الرمز. اطلب رمزًا جديدًا.';
  static const credentials = 'رقم الجوال أو كلمة المرور غير صحيحة.';
  static const nameInvalid = 'أدخل اسمًا من 2 إلى 120 حرفًا.';
  static const blocked = 'هذا الرقم محظور. تواصل مع الدعم.';
  static const sessionEnded = 'انتهت جلستك. سجّل الدخول من جديد.';
  static const maintenance = 'المنصة في صيانة مؤقتة. أعد المحاولة لاحقًا.';
  static const invalidData = 'تحقّق من البيانات المدخلة ثم أعد المحاولة.';

  static String throttled(Duration? wait) {
    if (wait == null || wait.inSeconds <= 0) {
      return 'محاولات كثيرة. انتظر قليلًا ثم أعد المحاولة.';
    }
    return 'محاولات كثيرة. أعد المحاولة بعد ${formatWait(wait)}.';
  }

  /// «45 ثانية», «3 دقائق», «12:30 دقيقة».
  static String formatWait(Duration wait) {
    final seconds = wait.inSeconds;
    if (seconds < 60) return '$seconds ثانية';
    final minutes = wait.inMinutes;
    final rest = seconds % 60;
    if (rest == 0) return minutes <= 10 ? '$minutes دقائق' : '$minutes دقيقة';
    return '$minutes:${rest.toString().padLeft(2, '0')} دقيقة';
  }

  static DomainRejection map(ApiException error) {
    switch (error.kind) {
      case ApiFailureKind.rateLimited:
        return RateLimitedRejection(
          throttled(error.retryAfter),
          retryAfter: error.retryAfter,
        );
      case ApiFailureKind.validation:
        return DomainRejection(_validation(error));
      case ApiFailureKind.forbidden:
        return DomainRejection(_arabicOr(error.message, blocked));
      case ApiFailureKind.unauthorized:
        return const DomainRejection(sessionEnded);
      case ApiFailureKind.network:
        return const DomainRejection(network);
      case ApiFailureKind.server:
        if (error.statusCode == 503) {
          return DomainRejection(_arabicOr(error.message, maintenance));
        }
        return const DomainRejection(server);
      case ApiFailureKind.notFound:
      case ApiFailureKind.unknown:
        return const DomainRejection(unexpected);
    }
  }

  static String _validation(ApiException error) {
    final code = error.fieldError('code');
    if (code.isNotEmpty) {
      final expired = code.contains('انتهت') || code.contains('expired');
      return expired ? codeExpired : codeInvalid;
    }
    if (error.fieldErrors.containsKey('credentials') ||
        error.fieldErrors.containsKey('password')) {
      return credentials;
    }
    if (error.fieldErrors.containsKey('phone')) return phoneInvalid;
    if (error.fieldErrors.containsKey('name')) return nameInvalid;
    return invalidData;
  }

  static final _arabic = RegExp('[\u0600-\u06FF]');

  static String _arabicOr(String message, String fallback) =>
      _arabic.hasMatch(message) ? message : fallback;
}
