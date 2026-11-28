/// Search screens copy (Trendyol-style layout). Formal MSA.
abstract final class SearchStrings {
  static const hint = 'البحث عن ماركة، أو منتج، أو فئة';
  static const back = 'رجوع';
  static const clearField = 'مسح النص';
  static const visualSearch = 'البحث بالصورة';
  static const visualSearchFeature = 'البحث بالصورة';
  static const historyTitle = 'سجل البحث';
  static const clearHistory = 'مسح';
  static const removeEntry = 'حذف من السجل';
  static const popularTitle = 'عمليات بحث مقترحة';
  static const unsupported = 'غير مدعوم';
  static const clearHistoryConfirm =
      'هل أنت متأكد من أنك تريد حذف سجل البحث السابق بالكامل؟';
  static const viewAll = 'عرض الكل';
  static const browsingHistory = 'سجّل التصفح';
  static const showMore = 'عرض المزيد';
  static const recommendedTitle = 'قطع لك خصيصًا';
  static String discountStrip(int percent) => 'خصم $percent%';
  static const historyDeleteAll = 'حذف الكل';
  static const historySwitchLabel = 'تشغيل/إيقاف السجل';
  static const historySwitchOffTitle = 'إيقاف سجل التصفح؟';
  static const historySwitchOffBody =
      'لن تُحفظ المنتجات التي تتصفحها بعد الآن. ما حفظناه سيبقى حتى تحذفه.';
  static const historySwitchOff = 'إيقاف';
  static const historyInfoTitle = 'سجل التصفح';
  static const historyInfoBody =
      'يحفظ التطبيق على هذا الجهاز آخر 30 منتجًا فتحتها لتعود إليها بسهولة. عند الإيقاف لا تُحفظ منتجات جديدة.';
  static const historyInfoLocal =
      'الحذف من هذا الجهاز فقط (غير مدعوم على الخادم)';
  static const historyPaused = 'السجل متوقف';
  static const chipPriceDrop = 'المنتجات التي انخفضت أسعارها';
  static const chipCategory = 'الفئة';
  static const categoryAll = 'الكل';
  static const filteredEmpty = 'لا توجد منتجات مطابقة';
  static const clearFilter = 'إزالة التصفية';
  static const rowDeleted = 'تم الحذف';
  static const rowDelete = 'حذف من السجل';
  static const rowUnavailable = 'غير متوفر';
  static const favorite = 'المفضلة';
  static const infoTooltip = 'معلومات';
  static const historyClearTitle = 'حذف السجل؟';
  static const historyClearBody =
      'سيؤدي ذلك إلى حذف كل المنتجات من سجل تصفحك الحالي.';
  static const historyClearLocalOnly =
      'غير مدعوم على الخادم: يُحذف من هذا الجهاز فقط';
  static const historyDelete = 'حذف';
  static const historyEmpty = 'سجل تصفحك فارغ.';
  static const historyEmptyHint = 'المنتجات التي تتصفحها ستظهر هنا.';
  static const startShopping = 'ابدأ التسوق';
  static const fillSuggestion = 'إدراج في البحث';
  static const noSuggestionMatch = 'لا توجد اقتراحات أخرى مطابقة.';
  static const relatedTitle = 'النتائج ذات الصلة';
  static const categoryTag = 'الفئة';
  static const storeTag = 'المتجر';
  static const keywordTag = 'بحث سابق';
  static const sort = 'الفرز';
  static const filter = 'فلترة';
  static const priceChip = 'السعر';
  static String resultsCount(int count) => '$count من المنتجات';
  static String noResultsFor(String query) =>
      'لم نعثر على أي منتجات تطابق بحثك عن «$query»، لكننا نظن أن المنتجات التالية قد تهمك.';
  static const browseCategories = 'تصفّح الفئات';
}
