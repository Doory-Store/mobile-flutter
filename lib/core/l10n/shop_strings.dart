/// MSA copy for cart, checkout, account, orders, and support.
///
/// Terms stay consistent with `DooryStrings` and `PRODUCT.md`. Strings ending
/// in `Feature` name a server action for the «لم يتم الربط بعد» dialog.
abstract final class ShopStrings {
  // Cart
  static const cartEmptyTitle = 'سلتك فارغة';
  static const cartEmptyBody =
      'أضف منتجات من الفئات أو البحث، وستظهر هنا مجمّعة حسب المتجر.';
  static const cartMockNote =
      'السلة محفوظة على هذا الجهاز، والرسوم والخصومات قيم تجريبية.';
  static const clearCart = 'إفراغ السلة';
  static const clearCartConfirm = 'هل تريد إفراغ السلة؟';
  static const removedFromCart = 'أُزيل المنتج من السلة';
  static const undo = 'تراجع';
  static const viewCart = 'عرض السلة';
  static const storeSubtotal = 'مجموع منتجات المتجر';
  static const deliveryFee = 'رسوم التوصيل';
  static const itemsTotal = 'مجموع المنتجات';
  static const discount = 'الخصم';
  static const grandTotal = 'الإجمالي';
  static const orderSummary = 'ملخص الطلب';
  static const coupon = 'قسيمة الخصم';
  static const couponHint = 'أدخل رمز القسيمة';
  static const couponApplied = 'تم تطبيق القسيمة';
  static const removeCoupon = 'إزالة القسيمة';
  static const proceedToCheckout = 'متابعة الطلب';
  static const unpricedNote =
      'بعض المنتجات بلا سعر معروض، لذلك لا يمكن حساب الإجمالي بدقة بعد.';
  static const blockedNote =
      'بعض المنتجات غير متاحة للشراء. احذفها من السلة للمتابعة.';
  static const nothingPurchasable = 'لا توجد منتجات متاحة للشراء في المفضلة.';
  static const addAllToCart = 'أضف الكل إلى السلة';
  static const clearAll = 'مسح الكل';
  static const clearFavoritesConfirm = 'هل تريد مسح كل المفضلة؟';
  static const favoritesEmptyTitle = 'لا توجد منتجات في المفضلة';

  static String cartTitleCount(int count) => 'السلة ($count)';
  static String unitPrice(String price) => 'سعر القطعة: $price';
  static String deliveryFeeStores(int stores) =>
      stores > 1 ? 'رسوم التوصيل ($stores متاجر)' : 'رسوم التوصيل';
  static String couponDemoHint(String code) =>
      'للتجربة استخدم الرمز $code (خصم تجريبي 10%).';
  static String addedToCart(int quantity) => quantity > 1
      ? 'أُضيفت $quantity قطع إلى السلة'
      : 'أُضيف المنتج إلى السلة';
  static String addedManyToCart(int count) => 'أُضيف $count منتج إلى السلة';

  // Product page
  static const addedToFavorites = 'أُضيف إلى المفضلة';
  static const removedFromFavorites = 'أُزيل من المفضلة';
  static const deliveryAndReturns = 'التوصيل والاستلام';
  static const inspectOnDelivery = 'افحص طلبك عند الاستلام قبل التوقيع.';
  static const priceDropAlert = 'نبّهني عند انخفاض السعر';
  static const savedOnDevice = 'يُحفظ على هذا الجهاز';
  static const priceWatchOn = 'سننبّهك عند انخفاض السعر (على هذا الجهاز).';
  static const priceWatchOff = 'أُلغي تنبيه السعر';
  static const notifyBackInStock = 'نبّهني عند توفّره';
  static const reviews = 'التقييمات';
  static const writeReview = 'اكتب تقييمًا';
  static const noReviews = 'لا توجد تقييمات بعد';
  static const askQuestion = 'اسأل عن هذا المنتج';
  static const reportListing = 'الإبلاغ عن هذا المنتج';
  static String deliveryFeeLine(String fee) => 'رسوم التوصيل $fee لكل متجر';
  static String reviewsCount(int count) => '$count تقييم';
  static String starsLabel(int stars) => '$stars من 5';

  // Store
  static const products = 'المنتجات';
  static const aboutStore = 'عن المتجر';
  static const follow = 'متابعة المتجر';
  static const following = 'تتابعه';
  static const followedLocal = 'تمت متابعة المتجر على هذا الجهاز';
  static const unfollowed = 'أُلغيت متابعة المتجر';
  static const messageStore = 'مراسلة المتجر';
  static const storeNoProducts = 'لا توجد منتجات في هذا المتجر حاليًا';
  static const noStoreDescription = 'لم يضف المتجر وصفًا بعد.';
  static const delivery = 'التوصيل';
  static const reportStore = 'الإبلاغ عن المتجر';
  static String productsCount(int count) => '$count منتج';
  static String followers(int count) => '$count متابع';

  // Auth
  static const login = 'تسجيل الدخول';
  static const loginTitle = 'أهلًا بك في دوري';
  static const loginBody = 'أدخل رقم جوالك وسنرسل لك رمز تحقق من 6 أرقام.';
  static const loginMockNote =
      'تسجيل دخول تجريبي: لا يُرسل رمز حقيقي، والجلسة محفوظة على هذا الجهاز.';
  static const otpTitle = 'أدخل رمز التحقق';
  static const otpLength = 'الرمز مكوّن من 6 أرقام.';
  static const phone = 'رقم الجوال';
  static const phoneInvalid = 'أدخل رقم جوال سوري صحيحًا، مثل 0944123456.';
  static const sendCode = 'إرسال الرمز';
  static const verify = 'تحقّق';
  static const resend = 'إعادة إرسال الرمز';
  static const changePhone = 'تغيير الرقم';
  static const sendViaWhatsapp = 'أرسل الرمز عبر واتساب';
  static const loginWithPassword = 'الدخول بكلمة المرور';
  static const termsNote =
      'بمتابعتك فإنك توافق على شروط الاستخدام وسياسة الخصوصية.';
  static String otpBody(String phone) => 'أرسلنا الرمز إلى $phone';
  static String resendIn(int seconds) => seconds < 60
      ? 'إعادة الإرسال بعد $seconds ث'
      : 'إعادة الإرسال بعد ${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
  static const passwordLabel = 'كلمة المرور';
  static const passwordRequired = 'أدخل كلمة المرور.';
  static const loginPasswordTitle = 'الدخول بكلمة المرور';
  static const loginPasswordBody =
      'أدخل رقم جوالك وكلمة المرور التي عيّنتها لحسابك.';
  static const loginWithOtp = 'الدخول برمز التحقق';
  static const signInAction = 'دخول';
  static const sessionExpiredNote =
      'انتهت جلستك. سجّل الدخول من جديد للمتابعة.';
  static const serverTestCode = 'رمز الاختبار من الخادم';
  static String otpValidFor(int seconds) =>
      'الرمز صالح لمدة ${(seconds / 60).ceil()} دقائق.';
  static String remainingSends(int count) => count <= 0
      ? 'استنفدت طلبات الرمز لهذا الرقم. يمكنك الطلب مجددًا بعد 15 دقيقة.'
      : count == 1
      ? 'يمكنك طلب الرمز مرة واحدة أخرى خلال 15 دقيقة.'
      : count == 2
      ? 'يمكنك طلب الرمز مرتين أخريين خلال 15 دقيقة.'
      : 'يمكنك طلب الرمز $count مرات أخرى خلال 15 دقيقة.';
  static String simulationCode(String code) => 'الرمز: $code';
  static String signedIn(String name) => 'أهلًا $name';

  // Checkout
  static const checkout = 'إتمام الطلب';
  static const checkoutMockNote =
      'العناوين وطرق الدفع والمواعيد تجريبية، ولا يُرسل الطلب إلى المتاجر.';
  static const receiveMethod = 'طريقة الاستلام';
  static const homeDelivery = 'توصيل للمنزل';
  static const pickupPoint = 'نقطة استلام';
  static const deliveryAddress = 'عنوان التوصيل';
  static const addAddress = 'إضافة عنوان';
  static const noAddresses = 'لا توجد عناوين محفوظة';
  static const deliveryTime = 'موعد التوصيل';
  static const pickupTime = 'موعد الاستلام';
  static const paymentMethod = 'طريقة الدفع';
  static const paymentAfterOrder =
      'تدفع بعد تأكيد الطلب بتحويل المبلغ ثم إدخال رقم العملية.';
  static const contact = 'بيانات التواصل';
  static const guest = 'زائر';
  static const notYou = 'لست أنت؟';
  static const notes = 'ملاحظات';
  static const notesHint = 'مثال: يرجى الاتصال قبل الوصول';
  static const orderReview = 'مراجعة الطلب';
  static const pickupFee = 'رسوم الاستلام';
  static const policyNote =
      'بتأكيد الطلب توافق على سياسة الدفع والإرجاع. يُلغى الطلب تلقائيًا إذا لم يُدفع خلال المهلة.';
  static const placeOrder = 'تأكيد الطلب';
  static const placeOrderNotWired =
      'لن يُرسل هذا الطلب إلى المتجر لأن إنشاء الطلبات لم يُربط بالخادم بعد. يمكنك عرض صفحة التأكيد والدفع ببيانات تجريبية.';
  static const showSampleConfirmation = 'عرض تأكيد تجريبي';
  static const chooseAddress = 'اختر عنوان التوصيل أو أضف عنوانًا جديدًا.';
  static const choosePickup = 'اختر نقطة الاستلام.';
  static const choosePayment = 'اختر طريقة الدفع.';

  // Confirmation & payment
  static const orderCreated = 'تأكيد الطلب';
  static const orderCreatedTitle = 'تم إنشاء طلبك';
  static const confirmationMockNote =
      'هذه صفحة تأكيد تجريبية؛ لم يُرسل الطلب ولم يُحجز أي مبلغ.';
  static const amountDue = 'المبلغ المطلوب';
  static const storeOrders = 'طلبات المتاجر';
  static const receivingAccount = 'حساب الاستلام';
  static const copy = 'نسخ';
  static const copied = 'تم النسخ';
  static const transactionReference = 'رقم العملية';
  static const transactionReferenceHint = 'مثال: 784512369';
  static const referenceInvalid = 'أدخل رقم العملية كما يظهر في تطبيق الدفع.';
  static const confirmPayment = 'تأكيد الدفع';
  static const cancelOrder = 'إلغاء الطلب';
  static const noRecentOrder = 'لا يوجد طلب حديث لعرضه';
  static String orderNumber(String id) => 'رقم الطلب $id';
  static String payWith(String method) => 'الدفع عبر $method';
  static String payWithin(int hours) =>
      'ادفع خلال $hours ساعة وإلا يُلغى الطلب.';

  // Orders
  static const myOrders = 'طلباتي';
  static const orderDetails = 'تفاصيل الطلب';
  static const orderNotFound = 'لم نجد هذا الطلب';
  static const noOrders = 'لا توجد طلبات بعد';
  static const noOrdersInFilter = 'لا توجد طلبات في هذا التصنيف';
  static const noOrdersBody = 'عندما تطلب من دوري ستجد طلباتك وحالتها هنا.';
  static const filterAll = 'الكل';
  static const filterAwaitingPayment = 'بانتظار الدفع';
  static const filterInProgress = 'قيد التنفيذ';
  static const filterOnTheWay = 'في الطريق';
  static const filterDelivered = 'تم التسليم';
  static const filterClosed = 'ملغاة';
  static const orderNo = 'رقم الطلب';
  static const orderDate = 'تاريخ الطلب';
  static const orderTracking = 'تتبّع الطلب';
  static const orderItems = 'المنتجات';
  static const payNow = 'ادفع الآن';
  static const rateOrder = 'قيّم الطلب';
  static const reorder = 'اطلب مجددًا';
  static const requestCancel = 'طلب إلغاء';
  static const requestReturn = 'طلب إرجاع';
  static const helpWithOrder = 'مساعدة';
  static const cancelReasonTitle = 'سبب الإلغاء';
  static const cancelReasons = [
    'طلبت بالخطأ',
    'أريد تغيير المنتجات أو الكميات',
    'وجدت سعرًا أفضل',
    'تأخّر الطلب',
    'سبب آخر',
  ];
  static const sendCancelRequest = 'إرسال طلب الإلغاء';
  static const reviewHint = 'شاركنا رأيك في المنتجات والتوصيل (اختياري)';
  static const submitReview = 'إرسال التقييم';
  static String reordered(int count) => 'أُضيفت $count قطع إلى السلة';
  static String rateStorePrompt(String store) => 'كيف كانت تجربتك مع $store؟';

  // Account
  static const welcomeGuest = 'مرحبًا بك';
  static const guestBody = 'سجّل الدخول لمتابعة طلباتك وعناوينك.';
  static const myAddresses = 'عناويني';
  static const notifications = 'الإشعارات';
  static const profile = 'الملف الشخصي';
  static const settings = 'الإعدادات';
  static const helpSupport = 'المساعدة والدعم';
  static const logout = 'تسجيل الخروج';
  static const logoutConfirm = 'هل تريد تسجيل الخروج؟';
  static const loggedOut = 'تم تسجيل الخروج';
  static const fullName = 'الاسم الكامل';
  static const nameInvalid = 'أدخل اسمًا من حرفين على الأقل.';
  static const save = 'حفظ';
  static const profileSaved = 'تم حفظ الملف الشخصي';
  static const changePhoneNumber = 'تغيير رقم الجوال';
  static const security = 'الأمان والخصوصية';
  static const setPassword = 'تعيين كلمة مرور';
  static const sessions = 'الأجهزة المسجّلة';
  static const requestMyData = 'طلب نسخة من بياناتي';
  static const deleteAccount = 'حذف الحساب';
  static String welcomeUser(String name) => 'أهلًا، $name';

  // Addresses
  static const editAddress = 'تعديل العنوان';
  static const noAddressesBody =
      'أضف عنوانًا في حمص لتختاره بسرعة عند إتمام الطلب.';
  static const defaultAddress = 'افتراضي';
  static const makeDefault = 'تعيين كافتراضي';
  static const defaultSet = 'تم تعيين العنوان الافتراضي';
  static const edit = 'تعديل';
  static const delete = 'حذف';
  static const moreActions = 'خيارات';
  static const deleteAddressConfirm = 'هل تريد حذف هذا العنوان؟';
  static const addressDeleted = 'تم حذف العنوان';
  static const addressSaved = 'تم حفظ العنوان';
  static const addressLabel = 'اسم العنوان';
  static const customLabel = 'اسم مخصص';
  static const customLabelHint = 'مثال: بيت العائلة';
  static const location = 'الموقع';
  static const city = 'المدينة';
  static const chooseNeighborhood = 'اختر الحي';
  static const searchNeighborhood = 'ابحث عن حي';
  static const areaComingSoon = 'التوصيل قريبًا';
  static const landmark = 'وصف المكان';
  static const landmarkHint = 'الشارع، أقرب معلم، رقم البناء والطابق';
  static const landmarkInvalid = 'أضف وصفًا يساعد المندوب على الوصول.';
  static const pinOnMap = 'تحديد الموقع على الخريطة';
  static const saveAddress = 'حفظ العنوان';

  // Notifications & settings
  static const markAllRead = 'تعليم الكل كمقروء';
  static const notificationSettings = 'إعدادات الإشعارات';
  static const noNotifications = 'لا توجد إشعارات';
  static const noNotificationsBody = 'ستصلك هنا تحديثات طلباتك والعروض.';
  static const orderNotifications = 'إشعارات الطلبات';
  static const offersNotifications = 'العروض والتسويق';
  static const inApp = 'داخل التطبيق';
  static const whatsapp = 'واتساب';
  static const email = 'البريد الإلكتروني';
  static const general = 'عام';
  static const language = 'اللغة';
  static const onlyHoms = 'دوري متاح حاليًا في حمص.';
  static const onlyArabic = 'التطبيق متاح حاليًا باللغة العربية.';
  static const clearRecentSearches = 'مسح سجل البحث';
  static const recentCleared = 'تم مسح سجل البحث';
  static const privacyPolicy = 'سياسة الخصوصية';
  static const terms = 'شروط الاستخدام';
  static String versionLabel(String version) => 'دوري — الإصدار $version';

  // Support
  static const searchHelp = 'ابحث في الأسئلة الشائعة';
  static const faq = 'الأسئلة الشائعة';
  static const contactUs = 'تواصل معنا';
  static const callUs = 'اتصل بنا';
  static const newTicket = 'فتح تذكرة دعم';
  static const myTickets = 'تذاكري';
  static const noTickets = 'لا توجد تذاكر.';
  static const linkedOrder = 'الطلب المرتبط';
  static const ticketTopic = 'الموضوع';
  static const ticketTopics = ['طلب', 'دفع', 'توصيل', 'حساب', 'أخرى'];
  static const ticketSubject = 'العنوان';
  static const ticketMessage = 'الرسالة';
  static const ticketMessageHint = 'اشرح المشكلة بالتفصيل';
  static const subjectInvalid = 'أدخل عنوانًا من 4 أحرف على الأقل.';
  static const messageInvalid = 'اكتب 10 أحرف على الأقل.';
  static const attachPhoto = 'إرفاق صورة';
  static const sendTicket = 'إرسال';

  // Server actions named in «لم يتم الربط بعد»
  static const whatsappChannel = 'إرسال الرمز عبر واتساب';
  static const passwordLogin = 'الدخول بكلمة المرور';
  static const submitPaymentFeature = 'إرسال إثبات الدفع';
  static const cancelCheckoutFeature = 'إلغاء الطلب قبل الدفع';
  static const cancelRequestFeature = 'إرسال طلب الإلغاء';
  static const reviewFeature = 'نشر التقييم';
  static const returnFeature = 'طلب الإرجاع';
  static const messageStoreFeature = 'مراسلة المتجر';
  static const changePhoneFeature = 'تغيير رقم الجوال';
  static const setPasswordFeature = 'تعيين كلمة المرور';
  static const sessionsFeature = 'إدارة الأجهزة المسجّلة';
  static const dataRequestFeature = 'طلب نسخة البيانات';
  static const deleteAccountFeature = 'حذف الحساب';
  static const mapPinFeature = 'تحديد الموقع على الخريطة';
  static const backInStockFeature = 'تنبيه التوفّر';
  static const questionFeature = 'أسئلة المنتج';
  static const reportFeature = 'الإبلاغ';
  static const openWhatsappFeature = 'فتح محادثة واتساب';
  static const dialFeature = 'الاتصال المباشر';
  static const ticketFeature = 'إرسال تذكرة الدعم';
  static const ticketThreadFeature = 'عرض محادثة التذكرة';
  static const attachmentsFeature = 'رفع المرفقات';
  static const pagesFeature = 'صفحات السياسات';
}
