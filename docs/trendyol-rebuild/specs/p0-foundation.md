# P0 · مواصفة الأساس ونظام التصميم

هذه المواصفة هي مرجع مهندس Flutter للمراحل [#6](https://github.com/Doory-Store/mobile-flutter/issues/6) حتى [#13](https://github.com/Doory-Store/mobile-flutter/issues/13). الشاشة تُبنى من هذا المجلد ومن لقطات `docs/trendyol-rebuild/ref/` وحدهما.

الهوية هوية دوري، والبنية بنية تطبيق Trendyol العربي للسعودية (7.71.1) كما في [`dimensions.md`](../dimensions.md). عند اختلاف `DESIGN.md` عن وثائق `docs/trendyol-rebuild/` تُعتمد وثائق إعادة البناء، ويُذكر الفرق في الجدول أدناه. قاعدة التباين في `DESIGN.md` تبقى سارية على النص الصغير: `#F27A1A` على الأبيض 2.77:1، لذلك سعر البطاقة يستخدم `cardPrice`.

## الملفات

| الملف | المحتوى | الـ Issue |
|---|---|---|
| [`p0-tokens.md`](p0-tokens.md) | الألوان، التباعد، أنصاف الأقطار، الحدود، الظل، الأيقونات، الحركة | [#6](https://github.com/Doory-Store/mobile-flutter/issues/6) |
| [`p0-typography.md`](p0-typography.md) | سلّم Cairo | [#6](https://github.com/Doory-Store/mobile-flutter/issues/6) |
| [`p0-components-chrome.md`](p0-components-chrome.md) | `DooryWordmark`، `SearchPill`، `DooryAppBar`، `DooryButton` | [#7](https://github.com/Doory-Store/mobile-flutter/issues/7) |
| [`p0-components-product.md`](p0-components-product.md) | البطاقات، `PriceBlock`، `RatingRow`، `FavoriteButton`، `DooryBadge` | [#8](https://github.com/Doory-Store/mobile-flutter/issues/8) |
| [`p0-components-lists.md`](p0-components-lists.md) | `DooryChip`، `ListRow`، `GroupCard`، `DoorySheet`، `SectionHeader` | [#9](https://github.com/Doory-Store/mobile-flutter/issues/9) |
| [`p0-components-states.md`](p0-components-states.md) | `EmptyState`، `ErrorState`، `SkeletonBox`، `DemoLabel` | [#10](https://github.com/Doory-Store/mobile-flutter/issues/10) |
| [`p0-components-tabs.md`](p0-components-tabs.md) | `BottomTabBar` وهيكل التبويبات الخمسة | [#11](https://github.com/Doory-Store/mobile-flutter/issues/11) |
| [`p0-mock-images.md`](p0-mock-images.md) | قاعدة الصورة 2:3 و`DooryImage` | [#12](https://github.com/Doory-Store/mobile-flutter/issues/12) |
| [`p0-catalog.md`](p0-catalog.md) | شاشة كتالوج المكوّنات | [#13](https://github.com/Doory-Store/mobile-flutter/issues/13) |
| [`p0-decisions.md`](p0-decisions.md) | قرارات مفتوحة مع افتراض معتمد لكل واحدة | [#5](https://github.com/Doory-Store/mobile-flutter/issues/5) |

المهندس يبني الافتراض المعتمد في [`p0-decisions.md`](p0-decisions.md) ويترك القرار قابلاً للتبديل من مكان واحد (منسّق أرقام، أو رمز لون).

## ما يقرأه المهندس قبل الكود

- الألوان والخطوط والأبعاد من `DooryTokens` و`DooryTypography` و`Theme.of(context)`. لا قيمة hex داخل `lib/features/` ولا داخل `lib/core/widgets/`.
- الاتجاه `Locale('ar')` و`TextDirection.rtl`. الحواف `EdgeInsetsDirectional` والمحاذاة `AlignmentDirectional` و`PositionedDirectional`.
- القوائم الأفقية تبدأ من البداية الخطية (اليمين). الأسهم الاتجاهية تنقلب. الشعار والصور وأيقونات البحث والسلة والتقييم تبقى كما رُسمت.
- النصوص الجديدة في `lib/core/l10n/`. المصطلحات القائمة في `DooryStrings` تُعاد كما هي: «الرئيسية» و«الفئات» و«المفضلة» و«السلة» و«حسابي» و«بيانات تجريبية» و«سعر تقريبي» و«نفدت الكمية».
- هدف المقاس هو الرقم المكتوب هنا. قبول المرحلة ±2 dp في الارتفاعات والهوامش و±1sp في الخطوط. قبول [#7](https://github.com/Doory-Store/mobile-flutter/issues/7) للمكوّنات الأساسية ±1 dp.
- Golden بمقاس 411×914 dp لكل مكوّن وحالة. معاينة النص الكبير عند 1.3× من غير فيضان ومن غير تمرير أفقي للصفحة.

## الصدق

- السعر المعروض هو `price_syp`. القيمة `null` تُخفي السعر، ولا تُرسم صفراً.
- السعر المقارن وشارة الخصم يظهران عندما تكون القيمة المرجعية أكبر من السعر الحالي. غير ذلك يُحذف الصف.
- التقييم وعدد المراجعات يظهران عند وجود قيمة حقيقية، أو داخل بطاقة تحمل «بيانات تجريبية».
- كل fixture تجريبي يحمل `sample: true`، والبطاقة تعرض `DemoLabel`. الـ Widgets لا تستورد ملفات الـ fixtures.
- الإجراء الذي لم يُربط بعد يفتح الحوار القائم «لم يتم الربط بعد». الواجهة تبقى قابلة للعرض.

## الوصول

- هدف اللمس 44–48 dp. عنصر أقصر من 44 dp (مثل `DooryChip` بارتفاع مرئي 30) يوسّع منطقة الضغط إلى 44 مع إبقاء الرسم بالمقاس المقاس.
- كل زر أيقونة له `Semantics` بالعربي: اسم، وحالة إن وُجدت (محدد، مفضّل).
- ترتيب التركيز يتبع ترتيب الرسم من البداية إلى النهاية.
- `MediaQuery.disableAnimations` يوقف الوميض والظهور التدريجي. تغيّر الحالة يبقى ظاهراً بلون أو نص.
- النص يتمدّد مع خط النظام ويلتف. الأزرار تحافظ على ارتفاعها، والبطاقات تطول إلى الأسفل. لا تصغير للخط تحت السلّم.

## الإبهام

الإجراء الأساسي في أسفل الشاشة: شريط التبويبات، وأزرار التأكيد في الأوراق السفلية. البحث يبقى في الرأس لأنه بدء التصفّح. الحذف المؤكد صف كامل في الورقة، وارتفاعه 56 dp.

## فروق محسومة

| الموضوع | `DESIGN.md` الحالي | المعتمد في P0 | السبب |
|---|---|---|---|
| ارتفاع الشريط السفلي | 64 dp مع حبة مؤشر `primarySubtle` | 56 dp، بلا حبة مؤشر. النشط `primary` والخامل `textPrimary` | [`dimensions.md`](../dimensions.md) §1 ولقطة `01-home-top` |
| البحث | ارتفاع 44، نصف قطر 20 | ارتفاع 38، حافة دائرية كاملة، تعبئة `surfaceSubtle` بلا حد | §2 |
| سلّم الخط | عناوين 24/22/20 ونص 16 | سلّم §11: عنوان شاشة 18، قسم 16، بطاقة 12، سعر بطاقة 14 | كثافة ترينديول هي هدف إعادة البناء |
| سعر البطاقة | `cardPrice` `#C2410C` | يبقى `cardPrice` | 2.77:1 تحت AA. هذا يتفق مع DESIGN ويخالف لون السعر المقاس `#F27A1A` |
| السعر المشطوب | `textMuted` `#999999` | `textSecondary` `#666666` | §6 يقيس `#666666`، و`#999999` على الأبيض يقارب 2.8:1 |
| خلفية صفحة المجموعات | `surface` | `surfaceCanvas` `#FAFAFA` | §9 و§10، رمز جديد |
| حدود بطاقة المنتج | حد 1 dp ونصف قطر 8 | بلا حد وبلا ظل، والصورة بحافة قائمة | لقطتا `13-listing` و`02-home-scroll1`. الفراغ 8 dp هو الفاصل |
| صورة المنتج | `BoxFit.contain` | `BoxFit.cover` داخل بئر 2:3 | اللقطات ممتلئة، وأصول الـ mock تُرسم بالنسبة نفسها فلا يُقصّ المحتوى |
| تسميات التبويب في `phases.md` | «المفضلات» و«الحساب» في نص المرحلة | «المفضلة» و«حسابي» | `DooryStrings` ونص المهمة. ترتيب RTL واحد: الرئيسية على البداية |
| `previewPlus` وألوان البلاطات | مستخدمة في الواجهة السابقة | تبقى في الرموز ولا تُستخدم في مكوّنات P0 | Plus والوردي خارج الإصدار الأول |
| زر الدخول الاجتماعي وأيقونة الكاميرا | — | غير موجودين في المكوّنات | بحث بالصورة ودخول اجتماعي خارج النطاق |

تحديث `DESIGN.md` نفسه جزء من [#6](https://github.com/Doory-Store/mobile-flutter/issues/6)، بعد تنفيذ الرموز والسلّم. هذه المواصفة هي المصدر الذي يُنسخ إليه.

## هيكل التطبيق في P0

خمسة تبويبات في `StatefulShellRoute.indexedStack`. كل تبويب يحتفظ بمكدسه. جسم التبويب في هذه المرحلة شاشة فارغة بـ `EmptyState` حتى تأتي مراحل الشاشات. التفاصيل في [`p0-components-tabs.md`](p0-components-tabs.md).

## ما يُترك من ترينديول في كل المكوّنات

الكوبونات، والتنزيلات الخاطفة، والعدّادات، وPlus وGo وElite، والمحفظة، والإعلانات، والدخول الاجتماعي، والبحث بالصورة، ومساعد الذكاء الاصطناعي، وشريط «رمز خاص»، وشعارات الدفع. مكان الشريط الترويجي يُغلق ويُضم المحتوى الذي تحته إلى ما فوقه.
