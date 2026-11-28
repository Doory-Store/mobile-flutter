/// Product detail page copy (Trendyol-style layout). Formal MSA.
abstract final class PdpStrings {
  static const searchHint = 'البحث عن منتج، أو متجر، أو فئة';
  static const back = 'رجوع';
  static const share = 'مشاركة';
  static const shareTitle = 'مشاركة المنتج';
  static const copyLink = 'نسخ الرابط';
  static const copyShareText = 'نسخ نص المشاركة';
  static const linkCopied = 'نُسخ الرابط';
  static const textCopied = 'نُسخ نص المشاركة';
  static const noShareLink = 'لا يتوفر رابط مشاركة لهذا المنتج بعد.';
  static const cart = 'السلة';
  static const visualSearch = 'البحث بالصورة';
  static const closeGallery = 'إغلاق المعرض';
  static const zoomHint = 'اسحب بإصبعين للتكبير';
  static String photoCounter(int index, int total) => '$index/$total';

  static const specialCode = 'رمز خاص لك';
  static String endsIn(String left) => 'ينتهي خلال $left';

  static String ratingsCount(int count) => '$count من التقييمات';
  static String favoritesCount(String count) => '$count من التفضيلات';

  static const expectedDelivery = 'التسليم المتوقع';
  static const chooseAddress = 'اختر العنوان';
  static const chooseCity = 'اختر مدينة التسليم';
  static const fastDelivery = 'توصيل سريع من متاجر قريبة';
  static String deliverTo(String city) => 'التسليم إلى $city';

  static const shippingTitle = 'الشحن والتسليم';
  static const deliveryPartners = 'شركاء التسليم';

  static const commitmentsTitle = 'التزامات دوري';
  static const safeShopping = 'التسوق بأمان';
  static const securePayment = 'الدفع الآمن';
  static const privacy = 'حماية الخصوصية';
  static const safeDelivery = 'التسليم الآمن';
  static const lostRefund = 'ردّ أموال الطلبات المفقودة والتالفة';
  static const inspectOnDelivery = 'افحص الطلب عند الاستلام';

  static const freeReturn = 'إرجاع سهل';
  static const returnPolicyTitle = 'سياسة الإرجاع';

  static const campaignsTitle = 'العروض المتوفرة';
  static const campaignCode = 'رمز الخصم';
  static const copyCode = 'نسخ الرمز';
  static const codeCopied = 'نُسخ الرمز';
  static const appliedAtCheckout = 'يُطبَّق عند الدفع';

  static const optionsTitle = 'الخيارات';
  static String optionsAvailable(int count) => 'تتوفر $count من الخيارات';
  static String chooseOption(String first, int more) =>
      more > 0 ? 'اختر ($first و$more خيارات إضافية)' : 'اختر ($first)';
  static const chooseOptionTitle = 'اختر الخيار';
  static const selected = 'مختار';
  static const notSelected = 'غير مختار';
  static const lowStock = 'كمية محدودة';
  static const soldOut = 'نفدت الكمية';

  static const featuresTitle = 'ميزات المنتج';
  static const descriptionTitle = 'وصف المنتج';
  static const showMore = 'عرض المزيد';
  static const showLess = 'عرض أقل';

  static const sellerTitle = 'البائع';
  static String followers(String count) => '$count متابع';
  static const follow = 'تابع';
  static const following = 'متابَع';
  static const followedOnDevice = 'تمت المتابعة على هذا الجهاز';
  static const unfollowed = 'أُلغيت المتابعة';
  static const viewStore = 'زيارة المتجر';

  static const questionsTitle = 'أسئلة وأجوبة عن المنتج';
  static String all(int count) => 'الكل ($count)';
  static const sellerAnswer = 'إجابة البائع';
  static const askQuestion = 'اطرح سؤالاً';
  static const questionHint = 'اكتب سؤالك عن المنتج';
  static const sendQuestion = 'إرسال السؤال';

  static const otherSellersTitle = 'البائعون الآخرون';
  static const view = 'عرض';

  static const reviewsTitle = 'تقييمات المنتج';
  static const allReviews = 'كل التقييمات';
  static const allStars = 'الكل';
  static String stars(int count) => '$count نجوم';
  static const noReviewsForFilter = 'لا توجد تقييمات بهذا التصنيف';

  static const similarTitle = 'منتجات من نفس المتجر';
  static const moreTitle = 'المزيد';

  static const addToCart = 'إضافة إلى السلة';
  static const notifyMe = 'نبّهني عند التوفّر';
  static const priceDropAlert = 'تنبيه انخفاض السعر';
  static const backInStockAlert = 'تنبيه عودة التوفر';
  static const stockWatchOn = 'سنخبرك عند عودة التوفر';
  static const stockWatchOff = 'أُلغي التنبيه';
  static const unavailable = 'غير متاح للشراء';
  static const sampleNote = 'محتوى توضيحي حتى ربط الخادم';
}
