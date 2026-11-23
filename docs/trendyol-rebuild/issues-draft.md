# مسودة الـ Milestones والـ Labels والـ Issues

جاهزة للإنشاء في المستودع `Doory-Store/mobile-flutter`. فيها 13 Milestone، و27 Label، و65 Issue. النسخة الآلية في [`issues-draft.json`](issues-draft.json) بنفس المحتوى، للإنشاء عبر سكربت.

## المستودع

الـ Issues مكانها `Doory-Store/mobile-flutter`. هو مستودع مستقل للموبايل (الويب في `Doory-Store/frontend` والخادم في `Doory-Store/backend`)، وفيه كل الكود الذي تغيّره هذه المراحل، فتُغلق الـ Issues تلقائياً من الـ PRs بـ `Closes #n`. المستودع فيه حالياً الـ Labels الافتراضية فقط، ولا يوجد Milestones ولا Issues مفتوحة.

## Milestones

| المفتاح | العنوان | الوصف |
|---|---|---|
| P0 | P0 · الأساس ونظام التصميم | الرموز، والخط، والشعار، والمكوّنات المشتركة، وهيكل التبويبات، وطبقة Mock |
| P1 | P1 · تسجيل الدخول والدخول الأول | شاشات الجوال والرمز وكلمة السر وبوابة الدخول بأسلوب ترينديول |
| P2 | P2 · الرئيسية | رأس القنوات والبحث، والبانر، وبلاطات الفئات، ودوائر المتاجر، ورفوف المنتجات |
| P3 | P3 · الفئات | Chips المستوى الأول، والعمود الجانبي، وشبكة المستوى الثالث |
| P4 | P4 · البحث | سجل البحث، والبحث الشائع، والاقتراحات، والانتقال للنتائج |
| P5 | P5 · قائمة المنتجات والفرز والفلترة | الشبكة، وورقة الفرز، وشاشة الفلترة وصفحاتها الفرعية |
| P6 | P6 · صفحة المنتج | المعرض، والخيارات، والمتجر، والأسئلة، والتقييمات، وشريط الشراء، وورقة المقاس |
| P7 | P7 · السلة | مجموعات المتاجر، وبطاقة المنتج، والملخص، والفارغة، وتأكيد الحذف |
| P8 | P8 · المفضلات | حالتا الضيف والمسجّل، والفارغة |
| P9 | P9 · الحساب والإعدادات | رأس الحساب، ومجموعات البطاقات، واللغة، والإعدادات، والبيانات الشخصية |
| P10 | P10 · شاشات الحساب الفرعية | الطلبات، والعناوين، والإشعارات، والدعم، وصفحة المتجر |
| P11 | P11 · إتمام الطلب | صفحة الدفع وأقسامها، وتأكيد الطلب |
| P12 | P12 · المراجعة الشاملة | RTL، وإمكانية الوصول، والأداء، والـ Golden، وقائمة الربط بالـ API |

## Labels

| الاسم | اللون | الوصف |
|---|---|---|
| `type:feature` | `#1D76DB` | شاشة أو مكوّن جديد |
| `type:design-spec` | `#C5DEF5` | مواصفة تصميم من Mobile Designer |
| `type:qa` | `#5319E7` | فحص ومطابقة من Mobile QA |
| `type:bug` | `#D73A4A` | خطأ وجده QA أو المستخدم |
| `type:docs` | `#0075CA` | وثائق المسار |
| `type:chore` | `#EDEDED` | تنظيف وإعداد |
| `area:foundation` | `#F27A1A` | الرموز والمكوّنات المشتركة والهيكل |
| `area:auth` | `#FBCA04` | تسجيل الدخول والبوابة |
| `area:home` | `#FF9F43` | الرئيسية |
| `area:categories` | `#FEC89A` | الفئات |
| `area:search` | `#BFD4F2` | البحث |
| `area:listing` | `#A2EEEF` | القوائم والفرز والفلترة |
| `area:product` | `#C2E0C6` | صفحة المنتج |
| `area:cart` | `#0E8A16` | السلة |
| `area:favorites` | `#F9D0C4` | المفضلات |
| `area:account` | `#D4C5F9` | الحساب والإعدادات وشاشاته الفرعية |
| `area:checkout` | `#006B75` | إتمام الطلب |
| `role:designer` | `#E99695` | مسؤولية Mobile Designer |
| `role:flutter` | `#02569B` | مسؤولية Flutter Engineer |
| `role:qa` | `#6F42C1` | مسؤولية Mobile QA |
| `role:api` | `#8A6D3B` | مسؤولية API Integration |
| `status:spec-ready` | `#BFE5BF` | المواصفة جاهزة للتنفيذ |
| `status:in-progress` | `#FFF3E8` | قيد التنفيذ |
| `status:needs-approval` | `#FBCA04` | بانتظار اعتماد المستخدم |
| `status:approved` | `#0E8A16` | اعتمدها المستخدم |
| `status:blocked` | `#B60205` | متوقفة، والسبب في التعليق وINCOMPLETE.md |
| `ui-only` | `#F5F5F5` | واجهة على بيانات Mock من غير ربط API |

## Issues


### P0 · الأساس ونظام التصميم

#### [P0] مواصفة نظام التصميم والمكوّنات المشتركة
- **Labels:** `type:design-spec`, `area:foundation`, `role:designer`, `ui-only`
- **الوصف:** مواصفة الرموز (ألوان، خطوط، تباعد، أنصاف أقطار) والمكوّنات المشتركة من dimensions.md §10–11.
- **المرجع:** `dimensions.md`
- **معايير القبول:** كل رمز له اسم وقيمة ومصدر؛ كل مكوّن له حالاته ومقاساته؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P0] تحديث رموز دوري وسلّم الخطوط
- **Labels:** `type:feature`, `area:foundation`, `role:flutter`, `ui-only`
- **الوصف:** إضافة surfaceCanvas وsuccessSurface وأنصاف الأقطار 4/6/8/12/pill والتباعد 4/6/8/12/16 وسلّم Cairo إلى DooryColors وDooryTokens وDooryTypography، وتحديث DESIGN.md.
- **معايير القبول:** لا قيم hex في الشاشات؛ Golden لسلّم الخطوط؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P0] المكوّنات الأساسية: DooryWordmark وSearchPill وDooryAppBar والأزرار
- **Labels:** `type:feature`, `area:foundation`, `role:flutter`, `ui-only`
- **الوصف:** SearchPill 38 dp، وAppBar 56 dp، والأزرار 36/40/45/48/53 dp.
- **المرجع:** `ref/10-categories.jpg`
- **معايير القبول:** المقاسات ±1 dp؛ حالات ثابت ومفعّل ومعطّل؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P0] بطاقات المنتج: ProductCardVertical وProductCardRail مع PriceBlock وRatingRow وFavoriteButton
- **Labels:** `type:feature`, `area:foundation`, `role:flutter`, `ui-only`
- **الوصف:** بطاقة 2:3 بعرض نصف الشاشة، ورف 137 dp، وسعر نهائي ومشطوب، وتقييم، وقلب.
- **المرجع:** `ref/13-listing.jpg`
- **معايير القبول:** نسبة الصورة 2:3؛ العنوان سطران بحد أقصى؛ Golden للحالتين؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P0] مكوّنات القوائم والأوراق: DooryChip وListRow وGroupCard وDoorySheet وSectionHeader
- **Labels:** `type:feature`, `area:foundation`, `role:flutter`, `ui-only`
- **الوصف:** Chip 30 dp، وصف 56 dp، وبطاقة مجموعة بزاوية 8 dp، وورقة سفلية بعنوان وإغلاق.
- **المرجع:** `ref/15-sort-sheet.jpg`
- **معايير القبول:** الأسهم تنقلب في RTL؛ Golden لكل مكوّن؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P0] حالات الشاشات: EmptyState وErrorState وSkeleton
- **Labels:** `type:feature`, `area:foundation`, `role:flutter`, `ui-only`
- **الوصف:** مكوّنات موحّدة للفراغ والخطأ مع إعادة المحاولة، والتحميل.
- **المرجع:** `ref/50-cart-empty.jpg`
- **معايير القبول:** تُستعمل في كل المراحل؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P0] الشريط السفلي وهيكل التبويبات الخمسة
- **Labels:** `type:feature`, `area:foundation`, `role:flutter`, `ui-only`
- **الوصف:** BottomTabBar بارتفاع 56 dp: الرئيسية، والفئات، والمفضلات، والسلة (مع شارة)، والحساب.
- **المرجع:** `ref/01-home-top.jpg`
- **معايير القبول:** أيقونة 24 dp ونص 11sp؛ النشط #F27A1A؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P0] طبقة Mock للمراحل وصور منتجات 2:3
- **Labels:** `type:feature`, `area:foundation`, `role:flutter`, `ui-only`
- **الوصف:** Fixtures للقنوات والفئات والمنتجات والمتاجر والسلة والمفضلات عبر repositories، مع إمكانية فرض حالة خطأ أو فراغ.
- **معايير القبول:** الـ Widgets لا تستورد الـ fixtures؛ مفتاح لتبديل الحالات؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P0] شاشة كتالوج المكوّنات (debug)
- **Labels:** `type:feature`, `area:foundation`, `role:flutter`, `ui-only`
- **الوصف:** شاشة تعرض كل مكوّن بكل حالاته، للمراجعة واللقطات.
- **معايير القبول:** متاحة في debug فقط؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P0] فحص المرحلة 0 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:foundation`, `role:qa`, `ui-only`
- **الوصف:** مطابقة المكوّنات والهيكل مع المرجع.
- **معايير القبول:** تقرير بالأرقام؛ لقطات الكتالوج والهيكل؛ وتعريف الإنجاز المشترك في `phases.md`.


### P1 · تسجيل الدخول والدخول الأول

#### [P1] مواصفة شاشات الدخول والبوابة
- **Labels:** `type:design-spec`, `area:auth`, `role:designer`, `ui-only`
- **الوصف:** تحويل 30-login-email و53-cart-checkout-gate إلى دخول بالجوال والرمز وكلمة السر.
- **المرجع:** `ref/30-login-email.jpg`
- **معايير القبول:** كل الحالات موصوفة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P1] شاشة الدخول برقم الجوال
- **Labels:** `type:feature`, `area:auth`, `role:flutter`, `ui-only`
- **الوصف:** إغلاق، والشعار، والعنوان، وحقل +963 بارتفاع 44 dp، و«متابعة»، و«الاستمرار من دون إنشاء حساب»، والشروط. المنطق الحالي في session_controller يبقى كما هو.
- **المرجع:** `ref/31-login-email-focused.jpg`
- **معايير القبول:** فارغ ومُركّز وخطأ وتحميل؛ الأزرار بهامش 16 dp؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P1] شاشتا الرمز وكلمة السر
- **Labels:** `type:feature`, `area:auth`, `role:flutter`, `ui-only`
- **الوصف:** OtpField بست خانات مع عدّاد إعادة الإرسال، وPasswordField مع إظهار وإخفاء.
- **معايير القبول:** رمز خاطئ؛ انتهاء المحاولات؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P1] بوابة الدخول من السلة والمفضلات
- **Labels:** `type:feature`, `area:auth`, `role:flutter`, `ui-only`
- **الوصف:** فتح شاشة الدخول كبوابة من «الدفع» ومن القلب ومن تبويب المفضلات، والرجوع للشاشة الأصلية بعد الدخول.
- **المرجع:** `ref/53-cart-checkout-gate.jpg`
- **معايير القبول:** الإغلاق يعيد للشاشة السابقة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P1] شاشة الدخول الأول (اختيار الاهتمام)
- **Labels:** `type:feature`, `area:auth`, `role:flutter`, `ui-only`
- **الوصف:** شاشة اختيارية على نمط 90-onboarding-1 بفئات دوري. تُبنى بعد موافقة المستخدم على وجودها.
- **المرجع:** `ref/90-onboarding-1.jpg`
- **معايير القبول:** تظهر مرة واحدة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P1] فحص المرحلة 1 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:auth`, `role:qa`, `ui-only`
- **الوصف:** فحص الحالات على المحاكي ومقارنتها.
- **معايير القبول:** لقطات الجوال والرمز وكلمة السر والبوابة؛ وتعريف الإنجاز المشترك في `phases.md`.


### P2 · الرئيسية

#### [P2] مواصفة الرئيسية
- **Labels:** `type:design-spec`, `area:home`, `role:designer`, `ui-only`
- **الوصف:** الرأس الثابت والأقسام من 01–07، مع استبعاد العناصر الترويجية.
- **المرجع:** `ref/01-home-top.jpg`
- **معايير القبول:** شجرة الأقسام وارتفاعاتها؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P2] رأس الرئيسية: تبويبات القنوات وصف البحث
- **Labels:** `type:feature`, `area:home`, `role:flutter`, `ui-only`
- **الوصف:** ChannelTabs بحجم 76×66 dp، وSearchPill بتلميح متحرك، وزر دخول للضيف. الرأس ثابت أثناء التمرير.
- **المرجع:** `ref/06-home-women-top.jpg`
- **معايير القبول:** تبديل القناة يغيّر الأقسام؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P2] البانر الرئيسي وبلاطات الفئات
- **Labels:** `type:feature`, `area:home`, `role:flutter`, `ui-only`
- **الوصف:** HeroCarousel بارتفاع 105 dp مع عدّاد، وCategoryTileGrid بصفين وبلاطة 83×104 dp.
- **المرجع:** `ref/02-home-scroll1.jpg`
- **معايير القبول:** التمرير يبدأ من اليمين؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P2] دوائر المتاجر ورفوف المنتجات
- **Labels:** `type:feature`, `area:home`, `role:flutter`, `ui-only`
- **الوصف:** StoreCircleRow بدوائر 66 dp، وProductRail مع «اكتشف المزيد» إلى products?collection=.
- **المرجع:** `ref/04-home-scroll3.jpg`
- **معايير القبول:** «عرض الكل» يفتح القائمة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P2] حالات الرئيسية: التحميل والخطأ
- **Labels:** `type:feature`, `area:home`, `role:flutter`, `ui-only`
- **الوصف:** Skeleton لكل قسم، وخطأ مع إعادة المحاولة.
- **معايير القبول:** Golden للحالتين؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P2] فحص المرحلة 2 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:home`, `role:qa`, `ui-only`
- **الوصف:** مطابقة الرئيسية.
- **معايير القبول:** 3 لقطات على الأقل؛ وتعريف الإنجاز المشترك في `phases.md`.


### P3 · الفئات

#### [P3] مواصفة الفئات
- **Labels:** `type:design-spec`, `area:categories`, `role:designer`, `ui-only`
- **الوصف:** من 10 و11 و12.
- **المرجع:** `ref/10-categories.jpg`
- **معايير القبول:** الطبقات الثلاث موصوفة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P3] شاشة الفئات: Chips وعمود جانبي وشبكة
- **Labels:** `type:feature`, `area:categories`, `role:flutter`, `ui-only`
- **الوصف:** Chips بارتفاع 30 dp، وعمود 104 dp (عنصر 52 dp)، وشبكة 3 أعمدة مع «عرض الكل». البيانات parent/children.
- **المرجع:** `ref/11-categories-rail-clothes.jpg`
- **معايير القبول:** النشط بخلفية #FFF3E8؛ الضغط يفتح القائمة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P3] حالات الفئات
- **Labels:** `type:feature`, `area:categories`, `role:flutter`, `ui-only`
- **الوصف:** تحميل، وفئة بلا أبناء، وخطأ.
- **معايير القبول:** Golden للحالات؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P3] فحص المرحلة 3 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:categories`, `role:qa`, `ui-only`
- **الوصف:** مطابقة الفئات.
- **معايير القبول:** 3 لقطات؛ وتعريف الإنجاز المشترك في `phases.md`.


### P4 · البحث

#### [P4] مواصفة البحث
- **Labels:** `type:design-spec`, `area:search`, `role:designer`, `ui-only`
- **الوصف:** من 35 و35b و36 و37.
- **المرجع:** `ref/35b-search-landing-history.jpg`
- **معايير القبول:** الحالات موصوفة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P4] صفحة البحث الأولى: السجل والشائع
- **Labels:** `type:feature`, `area:search`, `role:flutter`, `ui-only`
- **الوصف:** السجل محفوظ محلياً مع «مسح» وحذف كل عنصر، والشائع Chips بارتفاع 32 dp.
- **المرجع:** `ref/35b-search-landing-history.jpg`
- **معايير القبول:** الصف 48 dp؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P4] الاقتراحات أثناء الكتابة والانتقال للنتائج
- **Labels:** `type:feature`, `area:search`, `role:flutter`, `ui-only`
- **الوصف:** SuggestionRow بالجزء المطابق عريض ونوع الاقتراح، مع دعم الكتابة بالعربي.
- **المرجع:** `ref/36-search-suggest.jpg`
- **معايير القبول:** الكتابة العربية تعمل؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P4] فحص المرحلة 4 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:search`, `role:qa`, `ui-only`
- **الوصف:** مطابقة البحث.
- **معايير القبول:** 4 لقطات؛ وتعريف الإنجاز المشترك في `phases.md`.


### P5 · قائمة المنتجات والفرز والفلترة

#### [P5] مواصفة القائمة والفرز والفلترة
- **Labels:** `type:design-spec`, `area:listing`, `role:designer`, `ui-only`
- **الوصف:** من 13 إلى 18.
- **المرجع:** `ref/16-filter.jpg`
- **معايير القبول:** كل الأوراق والصفحات موصوفة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P5] شاشة القائمة: الشبكة وشريط الفرز والفلترة
- **Labels:** `type:feature`, `area:listing`, `role:flutter`, `ui-only`
- **الوصف:** شريط 34 dp مع Chips سريعة، وشبكة عمودين، وعدّاد تمرير، وتحميل الصفحة التالية.
- **المرجع:** `ref/13-listing.jpg`
- **معايير القبول:** البطاقة 193.5 dp؛ الفراغ 8 dp؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P5] ورقة الفرز
- **Labels:** `type:feature`, `area:listing`, `role:flutter`, `ui-only`
- **الوصف:** 7 خيارات Radio بارتفاع 56 dp.
- **المرجع:** `ref/15-sort-sheet.jpg`
- **معايير القبول:** الاختيار يحدّث القائمة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P5] شاشة الفلترة والفلاتر الفرعية
- **Labels:** `type:feature`, `area:listing`, `role:flutter`, `ui-only`
- **الوصف:** صفوف 56 dp، و«مسح»، وزر «القائمة (n)»، وصفحات السعر والماركة/المتجر والفئة والتقييم.
- **المرجع:** `ref/17-filter-price.jpg`
- **معايير القبول:** شارة العدد على «فلترة»؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P5] حالات القائمة: لا نتائج وخطأ
- **Labels:** `type:feature`, `area:listing`, `role:flutter`, `ui-only`
- **الوصف:** رسالة واقتراح تعديل الفلاتر.
- **معايير القبول:** Golden للحالات؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P5] فحص المرحلة 5 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:listing`, `role:qa`, `ui-only`
- **الوصف:** مطابقة القائمة والفلاتر.
- **معايير القبول:** 7 لقطات؛ وتعريف الإنجاز المشترك في `phases.md`.


### P6 · صفحة المنتج

#### [P6] مواصفة صفحة المنتج
- **Labels:** `type:design-spec`, `area:product`, `role:designer`, `ui-only`
- **الوصف:** من 40 إلى 48، مع استبدال الأقسام الترويجية.
- **المرجع:** `ref/40-pdp-top.jpg`
- **معايير القبول:** ترتيب الأقسام وارتفاعاتها؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P6] المعرض والعنوان والتقييم وموعد التسليم
- **Labels:** `type:feature`, `area:product`, `role:flutter`, `ui-only`
- **الوصف:** ProductGallery بحجم 411×617 dp مع النقاط، والعنوان، وRatingRow، وبطاقة التسليم.
- **المرجع:** `ref/41-pdp-scroll1.jpg`
- **معايير القبول:** نسبة 2:3؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P6] اختيار اللون والمقاس وورقة المقاس
- **Labels:** `type:feature`, `area:product`, `role:flutter`, `ui-only`
- **الوصف:** VariantThumbs، وSizeSelector بارتفاع 48 dp، وVariantSheet بـ Chips 39 dp وزر 48 dp.
- **المرجع:** `ref/48-pdp-variant-sheet.jpg`
- **معايير القبول:** المختار بحدّ برتقالي؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P6] بطاقة المتجر والأسئلة والتقييمات والمشابهة
- **Labels:** `type:feature`, `area:product`, `role:flutter`, `ui-only`
- **الوصف:** SellerCard بارتفاع 73 dp مع «تابع»، وQuestionCard وReviewCard أفقية، ورفوف مشابهة.
- **المرجع:** `ref/44-pdp-scroll4.jpg`
- **معايير القبول:** «الكل (n)» يفتح الصفحة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P6] الشريط السفلي الثابت والإضافة للسلة
- **Labels:** `type:feature`, `area:product`, `role:flutter`, `ui-only`
- **الوصف:** StickyBuyBar بارتفاع 73 dp مع زر 40 dp، والإضافة تحدّث شارة السلة.
- **المرجع:** `ref/40-pdp-top.jpg`
- **معايير القبول:** نفاد المخزون يعطّل الزر؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P6] صفحة التقييمات الكاملة وصفحة الأسئلة
- **Labels:** `type:feature`, `area:product`, `role:flutter`, `ui-only`
- **الوصف:** Toolbar، وملخص، وفلاتر 48 dp، وصور التقييمات، والقائمة. والأسئلة بنفس القالب.
- **المرجع:** `ref/47-pdp-reviews.jpg`
- **معايير القبول:** قائمة طويلة بلا تقطيع؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P6] فحص المرحلة 6 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:product`, `role:qa`, `ui-only`
- **الوصف:** مطابقة صفحة المنتج.
- **معايير القبول:** 7 لقطات؛ وتعريف الإنجاز المشترك في `phases.md`.


### P7 · السلة

#### [P7] مواصفة السلة
- **Labels:** `type:design-spec`, `area:cart`, `role:designer`, `ui-only`
- **الوصف:** من 50 إلى 54، من غير الكوبونات والخصومات.
- **المرجع:** `ref/51-cart-with-item.jpg`
- **معايير القبول:** الحالات موصوفة؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P7] السلة بمنتجات: مجموعات المتاجر والبطاقات والملخص
- **Labels:** `type:feature`, `area:cart`, `role:flutter`, `ui-only`
- **الوصف:** CartSellerGroup، وCartItemCard بارتفاع 142 dp، وQuantityStepper، وOrderSummary، وCheckoutBar بارتفاع 73 dp وزر 53 dp.
- **المرجع:** `ref/52-cart-scrolled.jpg`
- **معايير القبول:** المجموع يتحدث فوراً؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P7] السلة الفارغة وتأكيد الحذف
- **Labels:** `type:feature`, `area:cart`, `role:flutter`, `ui-only`
- **الوصف:** EmptyState مع «متابعة التسوق» و«منتجات مقترحة»، وConfirmSheet للحذف.
- **المرجع:** `ref/50-cart-empty.jpg`
- **معايير القبول:** Golden للحالتين؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P7] فحص المرحلة 7 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:cart`, `role:qa`, `ui-only`
- **الوصف:** مطابقة السلة.
- **معايير القبول:** 5 لقطات؛ وتعريف الإنجاز المشترك في `phases.md`.


### P8 · المفضلات

#### [P8] مواصفة المفضلات
- **Labels:** `type:design-spec`, `area:favorites`, `role:designer`, `ui-only`
- **الوصف:** من 60-favorites-guest.
- **المرجع:** `ref/60-favorites-guest.jpg`
- **معايير القبول:** الحالات الثلاث؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P8] المفضلات: الضيف والمسجّل والفارغة
- **Labels:** `type:feature`, `area:favorites`, `role:flutter`, `ui-only`
- **الوصف:** LoginPromptCard بثلاث مزايا، وشبكة المفضلات، والحالة الفارغة، ومزامنة القلب في كل الشاشات.
- **المرجع:** `ref/60-favorites-guest.jpg`
- **معايير القبول:** القلب متزامن؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P8] فحص المرحلة 8 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:favorites`, `role:qa`, `ui-only`
- **الوصف:** مطابقة المفضلات.
- **معايير القبول:** 3 لقطات؛ وتعريف الإنجاز المشترك في `phases.md`.


### P9 · الحساب والإعدادات

#### [P9] مواصفة الحساب والإعدادات
- **Labels:** `type:design-spec`, `area:account`, `role:designer`, `ui-only`
- **الوصف:** من 20 و21 و23 و24، من غير الكوبونات وCoins والمحفظة.
- **المرجع:** `ref/20-account-guest.jpg`
- **معايير القبول:** المجموعات وصفوفها؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P9] تبويب الحساب: الرأس ومجموعات البطاقات
- **Labels:** `type:feature`, `area:account`, `role:flutter`, `ui-only`
- **الوصف:** AccountHeader للضيف وللمسجّل، وصفوف التسليم واللغة، ومجموعات نظرة عامة والحساب والمزيد، وتسجيل الخروج.
- **المرجع:** `ref/21-account-guest-scrolled.jpg`
- **معايير القبول:** الصف 42–52 dp؛ الخلفية #FAFAFA؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P9] شاشات اللغة والإعدادات والبيانات الشخصية
- **Labels:** `type:feature`, `area:account`, `role:flutter`, `ui-only`
- **الوصف:** RadioListScreen بصفوف 50 dp، والإعدادات، والبيانات الشخصية.
- **المرجع:** `ref/23-language.jpg`
- **معايير القبول:** نفس أنماط الصفوف؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P9] فحص المرحلة 9 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:account`, `role:qa`, `ui-only`
- **الوصف:** مطابقة الحساب.
- **معايير القبول:** 5 لقطات؛ وتعريف الإنجاز المشترك في `phases.md`.


### P10 · شاشات الحساب الفرعية

#### [P10] مواصفة شاشات الحساب الفرعية
- **Labels:** `type:design-spec`, `area:account`, `role:designer`, `ui-only`
- **الوصف:** الطلبات، والعناوين، والإشعارات، والدعم، والمتجر، بأنماط المراحل السابقة.
- **معايير القبول:** لكل شاشة حالاتها؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P10] الطلبات وتفاصيل الطلب
- **Labels:** `type:feature`, `area:account`, `role:flutter`, `ui-only`
- **الوصف:** OrderCard وStatusChip وتفاصيل الطلب.
- **معايير القبول:** فارغة وخطأ؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P10] العناوين ونموذج العنوان
- **Labels:** `type:feature`, `area:account`, `role:flutter`, `ui-only`
- **الوصف:** AddressCard، وحقول بإطار 44 dp.
- **معايير القبول:** التحقق من الحقول؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P10] الإشعارات والدعم وصفحة المتجر
- **Labels:** `type:feature`, `area:account`, `role:flutter`, `ui-only`
- **الوصف:** NotificationRow، وشاشات الدعم، وStoreHeader لصفحة s/:slug.
- **معايير القبول:** فارغة وخطأ؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P10] فحص المرحلة 10 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:account`, `role:qa`, `ui-only`
- **الوصف:** مطابقة الشاشات الفرعية.
- **معايير القبول:** لقطة لكل حالة؛ وتعريف الإنجاز المشترك في `phases.md`.


### P11 · إتمام الطلب

#### [P11] مواصفة إتمام الطلب
- **Labels:** `type:design-spec`, `area:checkout`, `role:designer`, `ui-only`
- **الوصف:** صفحة بأقسام من أنماط السلة والحساب.
- **معايير القبول:** الأقسام والحالات؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P11] صفحة إتمام الطلب وتأكيده
- **Labels:** `type:feature`, `area:checkout`, `role:flutter`, `ui-only`
- **الوصف:** العنوان، وموعد التوصيل، وطريقة الدفع، والملخص، وشريط «تأكيد الطلب»، وشاشة التأكيد. الإرسال يبقى «لم يتم الربط بعد».
- **معايير القبول:** لا عنوان؛ إرسال؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P11] فحص المرحلة 11 ولقطات الاعتماد
- **Labels:** `type:qa`, `area:checkout`, `role:qa`, `ui-only`
- **الوصف:** مطابقة إتمام الطلب.
- **معايير القبول:** 3 لقطات؛ وتعريف الإنجاز المشترك في `phases.md`.


### P12 · المراجعة الشاملة

#### [P12] تدقيق RTL والمقاسات وإمكانية الوصول
- **Labels:** `type:qa`, `area:foundation`, `role:qa`, `ui-only`
- **الوصف:** جولة على كل الشاشات بحجم خط 1.3×، وSemantics، والتباين.
- **معايير القبول:** تقرير شامل؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P12] تحديث الـ Golden tests والأداء
- **Labels:** `type:chore`, `area:foundation`, `role:flutter`, `ui-only`
- **الوصف:** تحديث كل الـ Golden tests وقياس التمرير.
- **معايير القبول:** flutter test ناجح؛ وتعريف الإنجاز المشترك في `phases.md`.

#### [P12] قائمة الربط بالـ API لكل شاشة
- **Labels:** `type:docs`, `area:foundation`, `role:api`, `ui-only`
- **الوصف:** لكل شاشة: الـ endpoint، والمستودع، والحالات. تسلّم لمسار الربط.
- **معايير القبول:** تغطي كل المستودعات Mock؛ وتعريف الإنجاز المشترك في `phases.md`.

