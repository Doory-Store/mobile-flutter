/// Labelled placeholder content for the Trendyol-style product page.
///
/// Nothing here comes from the server. Every block is tagged with
/// `BACKEND: AVAILABLE <endpoint>` when the current API already returns the
/// data (not wired yet), or `BACKEND: MISSING <what is needed>` when the API
/// has no source for it. See BACKEND_HOOKS.md at the repo root.
library;

class PdpCampaign {
  const PdpCampaign({
    required this.title,
    required this.detail,
    this.code,
    this.endsIn,
  });

  final String title;
  final String detail;
  final String? code;
  final String? endsIn;
}

class PdpQuestion {
  const PdpQuestion({
    required this.author,
    required this.date,
    required this.question,
    this.answer,
  });

  final String author;
  final String date;
  final String question;
  final String? answer;
}

class PdpOtherSeller {
  const PdpOtherSeller({
    required this.name,
    required this.score,
    required this.delivery,
    required this.priceSyp,
  });

  final String name;
  final String score;
  final String delivery;
  final int priceSyp;
}

abstract final class PdpMock {
  // BACKEND: AVAILABLE GET /products/{id} → campaign_badge {title, detail, code} (returned, not mapped in ProductDetailDto)
  static const specialCode = PdpCampaign(
    title: 'رمز خاص لك',
    detail: 'خصم 10% على سلة المشتريات',
    code: 'DOORY10',
    endsIn: '16 ساعة و33 دقيقة',
  );

  // BACKEND: AVAILABLE GET /products/{id} → campaign_badge (one campaign); list of several campaigns: MISSING
  static const campaigns = <PdpCampaign>[
    PdpCampaign(
      title: 'رمز الخصم: DOORY10 - خصم 10% على سلة المشتريات',
      detail: 'يُطبَّق الرمز على كامل السلة عند الدفع، لمرة واحدة لكل حساب.',
      code: 'DOORY10',
      endsIn: '16 ساعة و33 دقيقة',
    ),
    PdpCampaign(
      title: 'توصيل مجاني للطلبات فوق 150,000 ل.س',
      detail: 'يُحتسب الحد بعد الخصومات، ويختلف حسب المدينة.',
    ),
  ];

  // BACKEND: MISSING favorites count per product (no favorites_count field on GET /products/{id})
  static const favoritesCount = '1.2K+';

  // BACKEND: AVAILABLE GET /products/{id} → buyer_delivery_rows[{label,value}] (returned, not mapped); estimated date range: MISSING
  static const expectedDelivery = 'خلال 1 - 2 يوم عمل';

  // BACKEND: AVAILABLE GET /cities (list of cities; not used by the PDP yet)
  static const cities = <String>['دمشق', 'حمص', 'حلب', 'اللاذقية', 'حماة'];

  // BACKEND: MISSING delivery partners / courier names per product or city
  static const deliveryPartners = <String>['مندوبو دوري', 'توصيل المتجر'];

  // BACKEND: MISSING payment methods offered for this product (no payment-methods endpoint for the buyer)
  static const paymentMessages = <String>[
    'الدفع نقدًا عند الاستلام',
    'ادفع عبر سيريتل كاش',
  ];

  // BACKEND: MISSING per-store return policy text (only POST /orders/{public_id}/return-requests exists)
  static const returnSummary =
      'إرجاع المشتريات بسهولة خلال 7 أيام من الاستلام.';
  static const returnPolicy = <String>[
    'يمكنك طلب الإرجاع خلال 7 أيام من تاريخ الاستلام.',
    'يجب أن يكون المنتج بحالته الأصلية ومع غلافه.',
    'لا تُرجع المنتجات الغذائية المفتوحة أو سريعة التلف.',
    'يُردّ المبلغ بالطريقة نفسها التي دفعت بها.',
  ];

  // BACKEND: AVAILABLE GET /products/{id} → buyer_attributes[{label,value}] and buyer_highlights (returned, not mapped)
  static const attributes = <(String, String)>[
    ('الحجم', '750 مل'),
    ('بلد المنشأ', 'سوريا'),
    ('طريقة الحفظ', 'مكان بارد وجاف'),
    ('النوع', 'منتج محلي'),
    ('مدة الصلاحية', '12 شهرًا'),
  ];

  // BACKEND: AVAILABLE GET /products/{id} → store.average_rating, store.followers_count (returned, not mapped in StoreRefDto)
  static const sellerScore = '8.9';
  static const sellerFollowers = '1.1K';

  // BACKEND: AVAILABLE GET /products/{id}/questions (paged; POST /products/{id}/questions needs auth)
  static const questions = <PdpQuestion>[
    PdpQuestion(
      author: '**** ****',
      date: '15.11.2026 | 11:08',
      question: 'مرحبًا، هل يتوفر هذا المنتج بحجم أكبر؟ وكم يومًا يستغرق التوصيل إلى حمص تقريبًا؟',
      answer: 'مرحبًا، يتوفر بحجم 1 لتر، ويصل خلال يوم إلى يومين. نتمنى لك يومًا جميلًا.',
    ),
    PdpQuestion(
      author: '**** ****',
      date: '10.11.2026 | 18:42',
      question: 'كيف يُحفظ بعد الفتح؟',
      answer: 'يُغلق جيدًا ويُحفظ في مكان بارد بعيدًا عن الضوء.',
    ),
    PdpQuestion(
      author: '**** ****',
      date: '02.11.2026 | 09:15',
      question: 'هل المنتج من إنتاج محلي؟',
      answer: 'نعم، إنتاج محلي ومعبأ حديثًا.',
    ),
  ];
  static const questionsTotal = 28;

  // BACKEND: MISSING other sellers offering the same product (no offers/other-sellers endpoint)
  static const otherSellers = <PdpOtherSeller>[
    PdpOtherSeller(
      name: 'بقالية الحي',
      score: '9.6',
      delivery: 'التسليم: خلال يومين',
      priceSyp: 45000,
    ),
  ];
}
