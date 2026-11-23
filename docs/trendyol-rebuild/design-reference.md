# المرجع البصري لكل شاشة

كل صف يربط شاشة في دوري بلقطات ترينديول المرجعية (في `ref/`، والنسخ الكاملة PNG مع XML في `trendyol-ref/screens/`) وبمقاساتها الأساسية، ويحدد ما يأخذ مكانه من هوية دوري. التفاصيل الرقمية الكاملة في [`dimensions.md`](dimensions.md).

| الشاشة | اللقطات | البنية والمقاسات | بديل دوري | المرحلة |
|---|---|---|---|---|
| تسجيل الدخول | [30-login-email](ref/30-login-email.jpg)<br>[31-login-email-focused](ref/31-login-email-focused.jpg)<br>[53-cart-checkout-gate](ref/53-cart-checkout-gate.jpg) | زر إغلاق، ثم الشعار، ثم العنوان، ثم زر اجتماعي 45 dp، ثم «أو»، ثم حقل 44 dp، ثم «متابعة» 36 dp، ثم «الاستمرار من دون إنشاء حساب»، ثم الشروط | كلمة «دوري» بدل شعار Trendyol. حقل جوال +963 بدل البريد. بلا كوبونات ولا Facebook | P1 |
| الرئيسية: الأعلى | [01-home-top](ref/01-home-top.jpg)<br>[06-home-women-top](ref/06-home-women-top.jpg) | قنوات 76×66 dp، وبحث 38 dp، وزر دخول، وبانر 105 dp، وشبكة بلاطات صفين | قنوات = فئات دوري الرئيسية. بانرات دوري الثابتة. زر الدخول برتقالي ثابت بلا تدرّج | P2 |
| الرئيسية: الأقسام | [02-home-scroll1](ref/02-home-scroll1.jpg)<br>[03-home-scroll2](ref/03-home-scroll2.jpg)<br>[04-home-scroll3](ref/04-home-scroll3.jpg)<br>[07-home-women-scroll1](ref/07-home-women-scroll1.jpg) | بلاطات فئات، ودوائر ماركات 66 dp، ورفوف منتجات 137 dp مع «اكتشف المزيد»، وشبكة أفضل الماركات | دوائر = متاجر دوري. بلا «تنزيلات خاطفة» ولا «رمز خاص» | P2 |
| الفئات | [10-categories](ref/10-categories.jpg)<br>[11-categories-rail-clothes](ref/11-categories-rail-clothes.jpg)<br>[12-categories-women-tab](ref/12-categories-women-tab.jpg) | Chips 30 dp، وعمود 104 dp (عنصر 52 dp)، وشبكة 3×(77 dp) بصور مربعة و«عرض الكل» | فئات دوري (parent/children) وصورها من الـ API أو الـ Mock | P3 |
| البحث: البداية | [35-search-landing](ref/35-search-landing.jpg)<br>[35b-search-landing-history](ref/35b-search-landing-history.jpg) | سجل البحث مع «مسح»، والبحث الشائع Chips | نصوص دوري الشائعة | P4 |
| البحث: الاقتراحات | [36-search-suggest](ref/36-search-suggest.jpg) | صفوف 48 dp بنص مطابق عريض ونوع الاقتراح | النوع: منتج، فئة، متجر | P4 |
| نتائج البحث | [37-search-results](ref/37-search-results.jpg) | نفس القائمة مع «الكلمة | العدد» | — | P4/P5 |
| قائمة المنتجات | [13-listing](ref/13-listing.jpg)<br>[14-listing-scrolled](ref/14-listing-scrolled.jpg) | فرز/فلترة 34 dp، وChips سريعة، وشبكة عمودين 193.5 dp بنسبة 2:3، وعدّاد تمرير | بلا شريط «Trendyol Plus» ولا «رمز خاص». الأسعار ل.س | P5 |
| ورقة الفرز | [15-sort-sheet](ref/15-sort-sheet.jpg) | 7 صفوف Radio بارتفاع 56 dp | نفس الخيارات بنصوص دوري | P5 |
| الفلترة | [16-filter](ref/16-filter.jpg)<br>[17-filter-price](ref/17-filter-price.jpg)<br>[18-filter-brand](ref/18-filter-brand.jpg) | صفوف 56 dp، وزر «القائمة (n)» 49.5 dp، والسعر والماركة صفحات فرعية | «الماركة» = المتجر أو الماركة حسب بيانات دوري. بلا «منتجات ترويجية» | P5 |
| صفحة المنتج: الأعلى | [40-pdp-top](ref/40-pdp-top.jpg)<br>[41-pdp-scroll1](ref/41-pdp-scroll1.jpg) | معرض 411×617 dp، والعنوان، والتقييم، وموعد التسليم، والشريط السفلي 73 dp | بلا شريط Plus ولا «Share & Win» | P6 |
| صفحة المنتج: الوسط | [42-pdp-scroll2](ref/42-pdp-scroll2.jpg)<br>[43-pdp-scroll3](ref/43-pdp-scroll3.jpg) | الشحن، واللون بصور مصغّرة، والمقاس Dropdown 48 dp | «التزامات Trendyol» والحملات تُستبدل ببطاقة توصيل ودفع دوري | P6 |
| صفحة المنتج: البائع والأسئلة | [44-pdp-scroll4](ref/44-pdp-scroll4.jpg) | بطاقة بائع 73 dp مع «تابع»، وأسئلة وأجوبة أفقية | المتجر في دوري مع رابط لصفحته | P6 |
| صفحة المنتج: التقييمات والمشابهة | [45-pdp-scroll5](ref/45-pdp-scroll5.jpg)<br>[46-pdp-scroll6](ref/46-pdp-scroll6.jpg) | ملخص التقييم، وبطاقات تقييم، ورفوف «منتجات مشابهة» | — | P6 |
| صفحة التقييمات | [47-pdp-reviews](ref/47-pdp-reviews.jpg) | Toolbar 56 dp، وملخص، وفلاتر 48 dp، وصور التقييمات، والقائمة | بلا فلاتر الطول والوزن، لأنها خاصة بالملابس | P6 |
| ورقة المقاس | [48-pdp-variant-sheet](ref/48-pdp-variant-sheet.jpg) | ملخص المنتج، وChips 39 dp، وزر 48 dp | بلا سطر الكوبون | P6 |
| السلة بمنتج | [51-cart-with-item](ref/51-cart-with-item.jpg)<br>[52-cart-scrolled](ref/52-cart-scrolled.jpg) | مجموعة متجر، وبطاقة 142 dp، والملخص، وشريط 73 dp مع «الدفع» 53 dp | بلا «رموز الخصم» ولا «خصومات خاصة» ولا شعارات الدفع السعودية | P7 |
| السلة الفارغة | [50-cart-empty](ref/50-cart-empty.jpg) | أيقونة، وعنوان، ورسالة، و«متابعة التسوق» 45 dp، ثم «منتجات مقترحة» | بلا بانر الكوبونات | P7 |
| تأكيد الحذف | [54-cart-delete-dialog](ref/54-cart-delete-dialog.jpg) | ورقة سفلية: السؤال، و«حذف»، و«إلغاء» (56 dp) | — | P7 |
| المفضلات للضيف | [60-favorites-guest](ref/60-favorites-guest.jpg) | بطاقة دعوة للدخول فيها 3 مزايا، ثم «منتجات محبوبة» | المزايا بنصوص دوري | P8 |
| الحساب للضيف | [20-account-guest](ref/20-account-guest.jpg)<br>[21-account-guest-scrolled](ref/21-account-guest-scrolled.jpg) | «مرحباً،» وزر 43 dp، وصفوف التسليم واللغة، ومجموعات بطاقات صفوفها 42 dp | بلا كوبونات ولا Coins ولا بانرات الألعاب ولا المحفظة ولا «مساعد Trendyol» | P9 |
| اللغة | [23-language](ref/23-language.jpg) | صفوف 50 dp | العربية فقط حالياً | P9 |
| الحساب للمسجّل | [70-account-signed](ref/70-account-signed.jpg)<br>[71-account-signed-scrolled](ref/71-account-signed-scrolled.jpg) | دائرة أحرف 56 dp، والاسم والبريد، وجرس الإشعارات، ثم نفس المجموعات | بلا «كوبوناتي» ولا Coins ولا طلب رقم WhatsApp ولا بانرات الألعاب | P9 |
| البيانات الشخصية | [73-personal-info](ref/73-personal-info.jpg) | حقول 44 dp بإطار، ورمز البلد 99 dp، وزر «تحديث» 48 dp | +963 والجوال السوري، والبريد اختياري | P9 |
| الإعدادات | [77-settings](ref/77-settings.jpg) | صفوف 69 dp بأيقونة وسهم، ورقم الإصدار | صفوف دوري: كلمة السر، والجلسات، والإشعارات، والبيانات | P9 |
| تفضيلات الإشعارات | [77b-notification-prefs](ref/77b-notification-prefs.jpg) | أقسام وبطاقات 73.5 dp بـ Checkbox، وزر «تحديث» | قنوات دوري (SMS وWhatsApp)، بلا التسويق | P9 |
| الطلبات (فارغة) | [72-orders](ref/72-orders.jpg) | Toolbar 56 dp، وحالة فراغ بزر 45 dp | «ابدأ التسوق» | P10 |
| العناوين (فارغة) | [74-addresses](ref/74-addresses.jpg) | حالة فراغ، وإجراء «أضف عنواناً» في شريط العنوان | — | P10 |
| اختيار العنوان | [75-address-form](ref/75-address-form.jpg) | بحث 40 dp، و«عرض موقعي» 52 dp، وخريطة بدبوس، و«تأكيد العنوان» 40 dp | خريطة حمص، والأحياء من بيانات دوري | P10/P11 |
| الإشعارات | [80-notifications](ref/80-notifications.jpg) | تبويبات 48 dp، ولافتة، وصفوف 102 dp بأيقونة دائرية | تبويبان: «الكل» و«طلبياتي» | P10 |
| المساعدة | [78-support](ref/78-support.jpg)<br>[78b-support-topics](ref/78b-support-topics.jpg) | «كل المواضيع» 48 dp، وChips 34 dp | مواضيع دوري، و«تواصل معنا» يفتح التذاكر | P10 |
| المفضلات للمسجّل | [81-favorites-signed](ref/81-favorites-signed.jpg) | بلاطات علوية، وفراغ «المس القلب»، و«قطع لك خصيصاً» | بلاطتان: «المفضلات» و«سجل التصفح» | P8 |
| السلة للمسجّل والدفع | [82-cart-signed](ref/82-cart-signed.jpg)<br>[84-checkout-address-gate](ref/84-checkout-address-gate.jpg) | الملخص، و«الدفع» يفتح اختيار العنوان أولاً عندما لا يوجد عنوان | بلا رموز الخصم ولا «العروض المميزة» | P7/P11 |
| البلد | [24-country](ref/24-country.jpg) | شبكة 3 أعمدة 99×50 dp | تصبح «منطقة التوصيل» في دوري | P9 |

## بدائل الهوية

| عنصر ترينديول | في دوري |
|---|---|
| شعار `trendyol` | الكلمة «دوري» بخط Cairo Bold بلون `#F27A1A` (`DooryWordmark`) |
| الخط | Cairo من `assets/fonts` |
| البرتقالي `#F27A1A` | `DooryColors.primary`، وهو نفس القيمة |
| تدرّج زر الدخول، والوردي `#FF4988` | `primary` ثابت |
| أخضر الشحن `#0BC15C` | `success` `#137333` على `#E7F9EF` |
| SAR | ل.س بتنسيق `price_syp` |
| البريد وFacebook | الجوال +963 مع رمز أو كلمة سر |
| «يرجى التسليم إلى» (البلد) | منطقة التوصيل أو الحي |
| البائع (Seller) | المتجر في دوري، مع صفحة `s/:slug` |
| شعارات الدفع (mada وtabby وtamara) | طرق الدفع في دوري (الدفع عند الاستلام) |
| «التزامات Trendyol» | بطاقة ضمانات دوري (التوصيل والدفع) |

## ما لم يُلتقط

- **صفحة الأسئلة الكاملة.** الأسئلة ظاهرة كقسم داخل صفحة المنتج (`44-pdp-scroll4`)، والصفحة الكاملة تُبنى بقالب صفحة التقييمات.
- **حالة «لا نتائج» في البحث.** بحث ترينديول تقريبي ويعرض نتائج حتى لنص عشوائي، فحالة الفراغ تُبنى بنمط فراغ الطلبات (`72-orders`).
- **تفاصيل الطلب.** الحساب لا يحوي طلبات سابقة، فتفاصيل الطلب تُبنى من بطاقات السلة وصفوف الملخص.
- **نموذج تفاصيل العنوان وملخص الدفع وطرق الدفع.** كلاهما يأتي بعد خطوة الخريطة (`75-address-form`، `84-checkout-address-gate`)، والخريطة تحتاج Google Play Services غير الموجودة على هذا المحاكي. تُبنى من أنماط حقول البيانات الشخصية وبطاقات السلة.
- **شاشات الرمز وإنشاء الحساب.** الحساب مسجّل مسبقاً، فشاشات دوري تُبنى من نمط شاشة الدخول المقاسة.
- **شجرة العناصر لبعض اللقطات.** الشاشات التي فيها حركة مستمرة (الرئيسية بعد التمرير، وبعض أقسام صفحة المنتج، والمفضلات، والبحث) قيست من الصور مباشرة.
