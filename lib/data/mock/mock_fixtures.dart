// Sample payloads for domains the app does not call yet.
//
// Each map mirrors a schema in the backend `docs/openapi/buyer-v1.yaml`
// (named in the comment above it), so swapping a mock repository for a live
// one changes the source of the JSON, not its shape. Screens fed by these
// fixtures show «بيانات تجريبية».

abstract final class MockFixtures {
  /// Simulated network delay, short enough to keep the demo brisk.
  static const latency = Duration(milliseconds: 350);

  /// Sample flat fee per store order (`delivery_fee_per_store_syp`).
  static const deliveryFeePerStoreSyp = 5000;

  /// Sample code accepted by the mock OTP verifier (`simulation_code`).
  static const otpCode = '482910';

  /// Sample coupon accepted by the mock cart.
  static const couponCode = 'DOORY10';
  static const couponPercent = 10;
  static const couponMaxSyp = 20000;

  /// `BuyerDeliveryPromise.message_ar`.
  static const deliveryPromise = 'عادةً في نفس اليوم داخل حمص';

  /// `GET /neighborhoods?city_id=1` → `BuyerNeighborhood[]`.
  static const neighborhoods = <Map<String, dynamic>>[
    {
      'id': 1,
      'name': 'الوعر',
      'slug': 'al-waer',
      'is_open': true,
      'city_id': 1,
      'city_status': 'live',
    },
    {
      'id': 2,
      'name': 'الإنشاءات',
      'slug': 'al-inshaat',
      'is_open': true,
      'city_id': 1,
      'city_status': 'live',
    },
    {
      'id': 3,
      'name': 'الحمراء',
      'slug': 'al-hamra',
      'is_open': true,
      'city_id': 1,
      'city_status': 'live',
    },
    {
      'id': 4,
      'name': 'عكرمة',
      'slug': 'akrama',
      'is_open': true,
      'city_id': 1,
      'city_status': 'live',
    },
    {
      'id': 5,
      'name': 'الزهراء',
      'slug': 'az-zahraa',
      'is_open': true,
      'city_id': 1,
      'city_status': 'live',
    },
    {
      'id': 6,
      'name': 'الغوطة',
      'slug': 'al-ghouta',
      'is_open': true,
      'city_id': 1,
      'city_status': 'live',
    },
    {
      'id': 7,
      'name': 'الخالدية',
      'slug': 'al-khalidiya',
      'is_open': true,
      'city_id': 1,
      'city_status': 'live',
    },
    {
      'id': 8,
      'name': 'باب السباع',
      'slug': 'bab-al-sibaa',
      'is_open': false,
      'city_id': 1,
      'city_status': 'live',
    },
    {
      'id': 9,
      'name': 'كرم الشامي',
      'slug': 'karm-al-shami',
      'is_open': false,
      'city_id': 1,
      'city_status': 'live',
    },
  ];

  /// `GET /addresses` → `BuyerAddress[]`.
  static const addresses = <Map<String, dynamic>>[
    {
      'id': 101,
      'lat': 34.7324,
      'lng': 36.7137,
      'label': 'المنزل',
      'landmark': 'قرب جامع الإنشاءات، الطابق الثالث',
      'neighborhood_id': 2,
      'neighborhood_name': 'الإنشاءات',
      'is_default': true,
    },
    {
      'id': 102,
      'lat': 34.7389,
      'lng': 36.7051,
      'label': 'العمل',
      'landmark': 'شارع الحضارة، مقابل الصيدلية',
      'neighborhood_id': 3,
      'neighborhood_name': 'الحمراء',
      'is_default': false,
    },
  ];

  /// `POST /auth/otp/verify` → `BuyerTokenResponse`.
  static Map<String, dynamic> tokenFor(String phone) => {
    'token': 'mock-token-$phone',
    'token_type': 'Bearer',
    'user': {'id': 1, 'phone': phone, 'name': 'أحمد الحمصي'},
  };

  /// `GET /payment-guide` → `BuyerPaymentGuide`.
  static const paymentGuide = <String, dynamic>{
    'methods': [
      {
        'method': 'sham_cash',
        'label_ar': 'شام كاش',
        'steps_ar': [
          'أنشئ طلبك في دوري حتى يظهر المبلغ الإجمالي بالليرة السورية.',
          'افتح تطبيق شام كاش وأرسل المبلغ الكامل المعروض في الطلب إلى حساب دوري.',
          'انسخ رقم العملية من شام كاش.',
          'عد إلى دوري وأدخل رقم العملية عند الدفع.',
        ],
      },
      {
        'method': 'syriatel_cash',
        'label_ar': 'سيرياتيل كاش',
        'steps_ar': [
          'أنشئ طلبك في دوري حتى يظهر المبلغ الإجمالي بالليرة السورية.',
          'حوّل المبلغ الكامل عبر سيرياتيل كاش إلى حساب دوري.',
          'احتفظ برقم العملية أو المرجع الذي يعطيك إياه التطبيق.',
          'أدخل المرجع في دوري وأكّد الدفع.',
        ],
      },
      {
        'method': 'paymera',
        'label_ar': 'Paymera',
        'steps_ar': [
          'أنشئ طلبك في دوري حتى يظهر المبلغ الإجمالي بالليرة السورية.',
          'ادفع المبلغ الكامل عبر Paymera حسب تعليمات التطبيق.',
          'انسخ رقم العملية أو المرجع بعد الدفع.',
          'أدخل المرجع في دوري وأكّد الدفع.',
        ],
      },
    ],
  };

  /// Receiving account shown beside the payment steps.
  static const paymentAccounts = <String, String>{
    'sham_cash': '0991 234 567',
    'syriatel_cash': '0944 765 432',
    'paymera': 'DOORY-HOMS',
  };

  /// `GET /delivery/slots`.
  static const deliverySlots = <Map<String, dynamic>>[
    {'id': 'asap', 'label_ar': 'أقرب وقت متاح اليوم'},
    {'id': 'today-evening', 'label_ar': 'اليوم مساءً (5 – 9)'},
    {'id': 'tomorrow-morning', 'label_ar': 'غدًا صباحًا (9 – 1)'},
    {'id': 'tomorrow-evening', 'label_ar': 'غدًا مساءً (5 – 9)'},
  ];

  /// `GET /pickup-points`.
  static const pickupPoints = <Map<String, dynamic>>[
    {
      'id': 1,
      'name': 'نقطة دوري — الحمراء',
      'address': 'شارع الحمراء الرئيسي، بجانب مكتبة النور',
      'hours': 'يوميًا 10 صباحًا – 9 مساءً',
    },
    {
      'id': 2,
      'name': 'نقطة دوري — الإنشاءات',
      'address': 'دوار الإنشاءات، محل رقم 4',
      'hours': 'السبت – الخميس 9 صباحًا – 8 مساءً',
    },
  ];

  /// `GET /orders` → `BuyerOrderListItem[]` and `GET /orders/{id}` →
  /// `BuyerOrderDetail`. One map carries both shapes.
  static final orders = <Map<String, dynamic>>[
    {
      'public_id': '7c1e4b2a-91d0-4f6e-8a1b-2f3c4d5e6f70',
      'store_name': 'فرن الياسمين',
      'status': 'out_for_delivery',
      'status_label_ar': 'خرج للتوصيل',
      'items_total_syp': 42000,
      'delivery_fee_syp': 5000,
      'delivery_promise': {'message_ar': deliveryPromise},
      'created_at': _ago(hours: 3),
      'address_summary': 'المنزل — الإنشاءات، حمص',
      'payment_method_label_ar': 'شام كاش',
      'notes': 'يرجى الاتصال عند الوصول',
      'lines': [
        {
          'id': 1,
          'product_id': 9001,
          'product_name_ar': 'خبز صاج طازج',
          'option_label_ar': 'ربطة',
          'quantity': 3,
          'unit_price_syp': 6000,
          'line_total_syp': 18000,
        },
        {
          'id': 2,
          'product_id': 9002,
          'product_name_ar': 'معمول بالتمر',
          'option_label_ar': 'علبة نصف كيلو',
          'quantity': 1,
          'unit_price_syp': 24000,
          'line_total_syp': 24000,
        },
      ],
      'status_history': [
        {
          'from_status': null,
          'to_status': 'pending_payment',
          'to_status_label_ar': 'بانتظار الدفع',
          'at': _ago(hours: 3),
        },
        {
          'from_status': 'pending_payment',
          'to_status': 'paid',
          'to_status_label_ar': 'مدفوع',
          'at': _ago(hours: 3, minutes: -10),
        },
        {
          'from_status': 'paid',
          'to_status': 'accepted_by_store',
          'to_status_label_ar': 'مقبول',
          'at': _ago(hours: 2, minutes: 30),
        },
        {
          'from_status': 'accepted_by_store',
          'to_status': 'preparing',
          'to_status_label_ar': 'قيد التجهيز',
          'at': _ago(hours: 2),
        },
        {
          'from_status': 'preparing',
          'to_status': 'out_for_delivery',
          'to_status_label_ar': 'خرج للتوصيل',
          'at': _ago(minutes: 25),
        },
      ],
      'cancellation_requests': [],
    },
    {
      'public_id': '3a9f8e7d-6c5b-4a39-8281-7f6e5d4c3b2a',
      'store_name': 'سوبرماركت الوعر',
      'status': 'pending_payment',
      'status_label_ar': 'بانتظار الدفع',
      'items_total_syp': 87500,
      'delivery_fee_syp': 5000,
      'delivery_promise': {'message_ar': deliveryPromise},
      'created_at': _ago(minutes: 40),
      'address_summary': 'العمل — الحمراء، حمص',
      'payment_method_label_ar': 'سيرياتيل كاش',
      'lines': [
        {
          'id': 3,
          'product_id': 9003,
          'product_name_ar': 'زيت زيتون بلدي',
          'option_label_ar': '1 لتر',
          'quantity': 1,
          'unit_price_syp': 55000,
          'line_total_syp': 55000,
        },
        {
          'id': 4,
          'product_id': 9004,
          'product_name_ar': 'لبنة بلدية',
          'option_label_ar': '500 غ',
          'quantity': 2,
          'unit_price_syp': 16250,
          'line_total_syp': 32500,
        },
      ],
      'status_history': [
        {
          'from_status': null,
          'to_status': 'pending_payment',
          'to_status_label_ar': 'بانتظار الدفع',
          'at': _ago(minutes: 40),
        },
      ],
      'cancellation_requests': [],
    },
    {
      'public_id': 'b5d4c3e2-1f0a-4b98-9c87-6d5e4f3a2b10',
      'store_name': 'حلويات الشام',
      'status': 'delivered',
      'status_label_ar': 'تم التسليم',
      'items_total_syp': 120000,
      'delivery_fee_syp': 5000,
      'delivery_promise': {'message_ar': deliveryPromise},
      'created_at': _ago(days: 4),
      'address_summary': 'المنزل — الإنشاءات، حمص',
      'payment_method_label_ar': 'شام كاش',
      'lines': [
        {
          'id': 5,
          'product_id': 9005,
          'product_name_ar': 'بقلاوة مشكّلة',
          'option_label_ar': 'كيلو',
          'quantity': 1,
          'unit_price_syp': 120000,
          'line_total_syp': 120000,
        },
      ],
      'status_history': [
        {
          'from_status': null,
          'to_status': 'pending_payment',
          'to_status_label_ar': 'بانتظار الدفع',
          'at': _ago(days: 4, hours: 2),
        },
        {
          'from_status': 'pending_payment',
          'to_status': 'paid',
          'to_status_label_ar': 'مدفوع',
          'at': _ago(days: 4, hours: 1),
        },
        {
          'from_status': 'paid',
          'to_status': 'accepted_by_store',
          'to_status_label_ar': 'مقبول',
          'at': _ago(days: 4, hours: 1),
        },
        {
          'from_status': 'accepted_by_store',
          'to_status': 'preparing',
          'to_status_label_ar': 'قيد التجهيز',
          'at': _ago(days: 4),
        },
        {
          'from_status': 'preparing',
          'to_status': 'out_for_delivery',
          'to_status_label_ar': 'خرج للتوصيل',
          'at': _ago(days: 4, hours: -1),
        },
        {
          'from_status': 'out_for_delivery',
          'to_status': 'delivered',
          'to_status_label_ar': 'تم التسليم',
          'at': _ago(days: 4, hours: -2),
        },
      ],
      'cancellation_requests': [],
    },
    {
      'public_id': 'e1f2a3b4-c5d6-4e7f-8091-a2b3c4d5e6f7',
      'store_name': 'مكتبة النور',
      'status': 'cancelled',
      'status_label_ar': 'ملغى',
      'items_total_syp': 30000,
      'delivery_fee_syp': 5000,
      'created_at': _ago(days: 12),
      'address_summary': 'المنزل — الإنشاءات، حمص',
      'lines': [
        {
          'id': 6,
          'product_id': 9006,
          'product_name_ar': 'دفتر جامعي 200 ورقة',
          'option_label_ar': null,
          'quantity': 2,
          'unit_price_syp': 15000,
          'line_total_syp': 30000,
        },
      ],
      'status_history': [
        {
          'from_status': null,
          'to_status': 'pending_payment',
          'to_status_label_ar': 'بانتظار الدفع',
          'at': _ago(days: 12),
        },
        {
          'from_status': 'pending_payment',
          'to_status': 'cancelled',
          'to_status_label_ar': 'ملغى',
          'at': _ago(days: 11),
        },
      ],
      'cancellation_requests': [],
    },
  ];

  /// `GET /notifications` → `BuyerNotification[]`.
  static final notifications = <Map<String, dynamic>>[
    {
      'id': 1,
      'event_key': 'order.out_for_delivery',
      'title': 'طلبك في الطريق',
      'body': 'خرج طلبك من فرن الياسمين للتوصيل، وسيصل خلال وقت قصير.',
      'read_at': null,
      'created_at': _ago(minutes: 25),
      'order_public_id': '7c1e4b2a-91d0-4f6e-8a1b-2f3c4d5e6f70',
    },
    {
      'id': 2,
      'event_key': 'order.pending_payment',
      'title': 'أكمل الدفع',
      'body':
          'طلبك من سوبرماركت الوعر بانتظار الدفع. أدخل رقم العملية لإتمامه.',
      'read_at': null,
      'created_at': _ago(minutes: 40),
      'order_public_id': '3a9f8e7d-6c5b-4a39-8281-7f6e5d4c3b2a',
    },
    {
      'id': 3,
      'event_key': 'order.delivered',
      'title': 'تم تسليم طلبك',
      'body': 'نتمنى أن تكون راضيًا عن طلبك من حلويات الشام. قيّم تجربتك.',
      'read_at': _ago(days: 4),
      'created_at': _ago(days: 4),
      'order_public_id': 'b5d4c3e2-1f0a-4b98-9c87-6d5e4f3a2b10',
    },
    {
      'id': 4,
      'event_key': 'product.back_in_stock',
      'title': 'عاد إلى المخزون',
      'body': 'منتج تتابعه أصبح متاحًا من جديد.',
      'read_at': _ago(days: 6),
      'created_at': _ago(days: 6),
    },
  ];

  /// `GET /me/notification-preferences`.
  static const notificationPreferences = <String, dynamic>{
    'operational_in_app': true,
    'operational_whatsapp': true,
    'operational_email': false,
    'marketing_whatsapp': false,
    'marketing_email': false,
  };

  /// `GET /products/{id}/reviews` and `GET /stores/{slug}/reviews` →
  /// `BuyerReview[]` (with a display name).
  static final reviews = <Map<String, dynamic>>[
    {
      'id': 1,
      'rating': 5,
      'author_name': 'سارة م.',
      'comment': 'وصل الطلب بسرعة والمنتج كما في الوصف تمامًا.',
      'created_at': _ago(days: 2),
    },
    {
      'id': 2,
      'rating': 4,
      'author_name': 'محمد ع.',
      'comment': 'جودة ممتازة، والتغليف كان جيدًا.',
      'created_at': _ago(days: 9),
    },
    {
      'id': 3,
      'rating': 5,
      'author_name': 'ريم ح.',
      'comment': null,
      'created_at': _ago(days: 15),
    },
  ];

  /// `GET /help/articles`.
  static const helpArticles = <Map<String, dynamic>>[
    {
      'slug': 'how-to-order',
      'category': 'الطلبات',
      'title': 'كيف أطلب من دوري؟',
      'body': 'اختر المنتجات وأضفها إلى السلة، ثم اختر العنوان وطريقة الدفع وأكّد الطلب. يصلك إشعار عند كل تغيير في حالة الطلب.',
    },
    {
      'slug': 'delivery-areas',
      'category': 'التوصيل',
      'title': 'ما مناطق التوصيل الحالية؟',
      'body': 'نوصل حاليًا إلى أحياء مختارة في حمص، ويظهر في قائمة الأحياء ما هو مفتوح منها. نضيف أحياءً جديدة تباعًا.',
    },
    {
      'slug': 'delivery-fee',
      'category': 'التوصيل',
      'title': 'كيف تُحسب رسوم التوصيل؟',
      'body': 'تُحسب رسوم التوصيل لكل متجر في طلبك، وتظهر في السلة وفي ملخص الطلب قبل التأكيد.',
    },
    {
      'slug': 'payment-methods',
      'category': 'الدفع',
      'title': 'ما طرق الدفع المتاحة؟',
      'body': 'يمكنك الدفع عبر شام كاش أو سيرياتيل كاش أو Paymera. بعد التحويل أدخل رقم العملية في صفحة الطلب ليتم تأكيد الدفع.',
    },
    {
      'slug': 'cancel-order',
      'category': 'الطلبات',
      'title': 'هل يمكنني إلغاء طلبي؟',
      'body': 'يمكنك طلب الإلغاء من صفحة الطلب قبل أن يبدأ المتجر بتجهيزه. إذا كنت قد دفعت، يُعاد المبلغ إلى الحساب الذي دفعت منه.',
    },
    {
      'slug': 'returns',
      'category': 'الإرجاع',
      'title': 'كيف أُرجع منتجًا؟',
      'body': 'افتح الطلب بعد التسليم واختر «طلب إرجاع» خلال المدة المسموحة، ثم حدّد المنتجات والسبب.',
    },
  ];

  /// `GET /support/tickets`.
  static final supportTickets = <Map<String, dynamic>>[
    {
      'public_id': 'f0e1d2c3-b4a5-4697-8879-6a5b4c3d2e1f',
      'subject': 'استفسار عن موعد التوصيل',
      'status': 'resolved',
      'order_public_id': 'b5d4c3e2-1f0a-4b98-9c87-6d5e4f3a2b10',
      'created_at': _ago(days: 5),
    },
  ];

  /// Support contact channels.
  static const supportPhone = '+963 31 222 3344';
  static const supportWhatsapp = '+963 944 111 222';

  static String _ago({int days = 0, int hours = 0, int minutes = 0}) {
    return DateTime.now()
        .subtract(Duration(days: days, hours: hours, minutes: minutes))
        .toIso8601String();
  }
}
