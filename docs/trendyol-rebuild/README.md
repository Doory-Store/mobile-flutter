# إعادة بناء واجهة دوري على نمط ترينديول العربي

هذا المجلد هو المرجع الوحيد لمسار إعادة بناء واجهة تطبيق دوري (Flutter). الهدف أن يطابق تطبيق دوري تطبيق Trendyol العربي الموجّه للسعودية في البنية والتخطيط والتنقل وتشريح المكوّنات والمقاسات، مع الحفاظ على هوية دوري الخاصة.

## الهدف

- كل شاشة في دوري تتبع ترتيب الشاشة المقابلة في ترينديول ومقاساتها بالـ dp، من الرئيسية إلى الحساب.
- العمل مقسوم إلى مراحل مستقلة (`phases.md`). كل مرحلة تُفهم وتُختبر وتُعتمد وحدها، وبعدها ننتقل للتالية.
- المرحلة الحالية **واجهات فقط**: كل شاشة جديدة تقرأ بياناتها من مستودعات Mock عبر الـ providers الموجودة. الربط الحي (تسجيل الدخول والكتالوج) يبقى كما هو في الكود، والربط الكامل بالـ API يأتي لاحقاً بدور «API Integration».
- الميزات الأساسية الموجودة حالياً في دوري، مثل المتاجر والعناوين والطلبات والإشعارات والدعم، تُحفظ ويُعاد تصميمها بنفس الأسلوب.

## هوية دوري

| العنصر | قيمة دوري | المصدر |
|---|---|---|
| الشعار | الكلمة «دوري» بخط Cairo Bold وبلون `#F27A1A`. لا يوجد ملف شعار رسومي في المشروع حالياً، والكلمة هي الشعار المعتمد إلى أن يصل ملف SVG رسمي | `FrontEnd/lib/home/demo-home.ts` (`wordmark: "دوري"`)، و`FrontEnd/components/site/site-header.tsx` |
| الخط | Cairo (عربي ولاتيني)، بالأوزان 400 و600 و700 | الويب: `FrontEnd/app/layout.tsx` (`next/font/google` Cairo). الموبايل: `mobile-flutter/assets/fonts/Cairo-*.ttf` و`pubspec.yaml` |
| اللون الأساسي | `#F27A1A`، والـ hover `#D56B17`، والخلفية الخفيفة `#FFF3E8` | `FrontEnd/app/globals.css` (`--primary`)، و`mobile-flutter/lib/core/theme/doory_colors.dart` |
| الحيادي والنصوص | `#FFFFFF` و`#F5F5F5` و`#333333` و`#666666` و`#999999` و`#E6E6E6` | نفس الملفين |
| الحالات | الخصم والخطأ `#BB0000`، والنجاح `#137333`، والتقييم `#FFC000` | نفس الملفين |
| العملة | الليرة السورية (`ل.س`)، والسعر من `price_syp` | `PRODUCT.md` |
| الدخول | رقم جوال سوري (+963) ثم رمز OTP أو كلمة سر | `lib/features/auth/login_screen.dart` |

ألوان دوري قريبة أصلاً من ألوان ترينديول، فالمطابقة البصرية تتحقق عبر رموز دوري من غير نسخ أي قيمة علامة تجارية.

## ما ننقله من ترينديول

- بنية الشاشات وترتيب أقسامها والتنقل بينها: 5 تبويبات (الرئيسية، الفئات، المفضلات، السلة، الحساب)، والشاشات الفرعية، والأوراق السفلية.
- تشريح المكوّنات: بطاقة المنتج العمودية 2:3، وحقل البحث الـ Pill، والعمود الجانبي للفئات، وصفوف الفلاتر، وشريط الشراء الثابت، وبطاقات مجموعات الحساب، وحالات الفراغ.
- المقاسات بالـ dp، والتباعد، وأنصاف الأقطار، وسلّم الخطوط (`dimensions.md`).
- الحالات: الضيف والمسجّل، والفراغ، والتحميل، والخطأ، وبوابة تسجيل الدخول.

## خارج الإصدار الأول

الإصدار الأول من دوري يركّز على التسوق الأساسي. هذه العناصر موجودة في ترينديول، وتبقى خارج كل المراحل والـ Issues:

- **الحملات المؤقتة.** التنزيلات الخاطفة، والعدّادات التنازلية، وعروض المواسم (الجمعة البيضاء، عروض نوفمبر)، و«رمز خاص لك»، و«العروض المميزة» في السلة، ونوافذ «أضف المزيد للتوفير».
- **الكوبونات والخصومات.** كروت «30% خصم»، و«رموز الخصم» في السلة، و«كوبوناتي» في الحساب، وتبويبا «كوبوناتي» و«الحملات» في الإشعارات، والبانرات الترويجية.
- **العضويات والمحافظ.** Trendyol Plus وGo وElite، والمحفظة، والتقسيط.
- **الألعاب والمكافآت.** Coins، وبانرات «العب واربح»، و«شارك واربح».
- **ميزات إضافية.** اختيار الاهتمام (نساء/رجال) عند أول تشغيل، و«مساعِد Trendyol» بالذكاء الاصطناعي، والدخول بحسابات التواصل الاجتماعي، والبحث بالصورة، و«المجموعات» و«عروض لك خصيصاً» في المفضلات، وطلب رقم WhatsApp للتسويق، ومشاركة السلة.
- **علامة ترينديول.** الشعار والخط والتدرّجات والوردي `#FF4988` والإعلانات.

مكان كل عنصر من هذه، يأخذ مكوّن دوري المكافئ أو يُحذف ويُغلق الفراغ. وعندما يدخل أي منها خطة إصدار لاحق، يُضاف كمرحلة جديدة بمرجعه من اللقطات المحفوظة.

## المراجع

| المرجع | المكان |
|---|---|
| لقطات ترينديول الكاملة (PNG وXML) | `C:\Users\bahaa\Desktop\Doory\trendyol-ref\screens\` على الكمبيوتر، و`/workspace/shots/trendyol-app/screens/` على الـ box |
| لقطات مصغّرة منتقاة للمراجعة (البيانات الشخصية مموّهة) | `docs/trendyol-rebuild/ref/` |
| المقاسات والألوان | [`dimensions.md`](dimensions.md) |
| المرجع لكل شاشة | [`design-reference.md`](design-reference.md) |
| المراحل | [`phases.md`](phases.md) |
| سير العمل | [`workflow.md`](workflow.md) |
| مهام فريق المساعدين | [`roles.md`](roles.md) |
| مسودة الـ Issues والـ Milestones | [`issues-draft.md`](issues-draft.md) |
| القرارات البصرية السابقة | `DESIGN.md` و`design-plans/`. المرحلة 0 تحدّث `DESIGN.md` ليطابق هذا المسار |

التطبيق المرجعي هو Trendyol 7.71.1 (`trendyol.com`)، مثبّت على المحاكي `emulator-5554`، بلغة عربية وبلد السعودية. الشاشات العامة ملتقطة كضيف، وشاشات الحساب والطلبات والعناوين والإشعارات والإعدادات والمساعدة ملتقطة بحساب المستخدم للقراءة فقط. ملفات التثبيت في `C:\Users\bahaa\Desktop\Doory\trendyol-ref\` خارج المستودع.

## فهرس الـ Issues

64 Issue في [`Doory-Store/mobile-flutter`](https://github.com/Doory-Store/mobile-flutter/issues)، والتفاصيل في [`issues-map.md`](issues-map.md).

| المرحلة | الـ Issues |
|---|---|
| P0 · الأساس ونظام التصميم | [#5](https://github.com/Doory-Store/mobile-flutter/issues/5)، [#6](https://github.com/Doory-Store/mobile-flutter/issues/6)، [#7](https://github.com/Doory-Store/mobile-flutter/issues/7)، [#8](https://github.com/Doory-Store/mobile-flutter/issues/8)، [#9](https://github.com/Doory-Store/mobile-flutter/issues/9)، [#10](https://github.com/Doory-Store/mobile-flutter/issues/10)، [#11](https://github.com/Doory-Store/mobile-flutter/issues/11)، [#12](https://github.com/Doory-Store/mobile-flutter/issues/12)، [#13](https://github.com/Doory-Store/mobile-flutter/issues/13)، [#14](https://github.com/Doory-Store/mobile-flutter/issues/14) |
| P1 · تسجيل الدخول | [#15](https://github.com/Doory-Store/mobile-flutter/issues/15)، [#16](https://github.com/Doory-Store/mobile-flutter/issues/16)، [#17](https://github.com/Doory-Store/mobile-flutter/issues/17)، [#18](https://github.com/Doory-Store/mobile-flutter/issues/18)، [#19](https://github.com/Doory-Store/mobile-flutter/issues/19) |
| P2 · الرئيسية | [#20](https://github.com/Doory-Store/mobile-flutter/issues/20)، [#21](https://github.com/Doory-Store/mobile-flutter/issues/21)، [#22](https://github.com/Doory-Store/mobile-flutter/issues/22)، [#23](https://github.com/Doory-Store/mobile-flutter/issues/23)، [#24](https://github.com/Doory-Store/mobile-flutter/issues/24)، [#25](https://github.com/Doory-Store/mobile-flutter/issues/25) |
| P3 · الفئات | [#26](https://github.com/Doory-Store/mobile-flutter/issues/26)، [#27](https://github.com/Doory-Store/mobile-flutter/issues/27)، [#28](https://github.com/Doory-Store/mobile-flutter/issues/28)، [#29](https://github.com/Doory-Store/mobile-flutter/issues/29) |
| P4 · البحث | [#30](https://github.com/Doory-Store/mobile-flutter/issues/30)، [#31](https://github.com/Doory-Store/mobile-flutter/issues/31)، [#32](https://github.com/Doory-Store/mobile-flutter/issues/32)، [#33](https://github.com/Doory-Store/mobile-flutter/issues/33) |
| P5 · قائمة المنتجات والفرز والفلترة | [#34](https://github.com/Doory-Store/mobile-flutter/issues/34)، [#35](https://github.com/Doory-Store/mobile-flutter/issues/35)، [#36](https://github.com/Doory-Store/mobile-flutter/issues/36)، [#37](https://github.com/Doory-Store/mobile-flutter/issues/37)، [#38](https://github.com/Doory-Store/mobile-flutter/issues/38)، [#39](https://github.com/Doory-Store/mobile-flutter/issues/39) |
| P6 · صفحة المنتج | [#40](https://github.com/Doory-Store/mobile-flutter/issues/40)، [#41](https://github.com/Doory-Store/mobile-flutter/issues/41)، [#42](https://github.com/Doory-Store/mobile-flutter/issues/42)، [#43](https://github.com/Doory-Store/mobile-flutter/issues/43)، [#44](https://github.com/Doory-Store/mobile-flutter/issues/44)، [#45](https://github.com/Doory-Store/mobile-flutter/issues/45)، [#46](https://github.com/Doory-Store/mobile-flutter/issues/46) |
| P7 · السلة | [#47](https://github.com/Doory-Store/mobile-flutter/issues/47)، [#48](https://github.com/Doory-Store/mobile-flutter/issues/48)، [#49](https://github.com/Doory-Store/mobile-flutter/issues/49)، [#50](https://github.com/Doory-Store/mobile-flutter/issues/50) |
| P8 · المفضلات | [#51](https://github.com/Doory-Store/mobile-flutter/issues/51)، [#52](https://github.com/Doory-Store/mobile-flutter/issues/52)، [#53](https://github.com/Doory-Store/mobile-flutter/issues/53) |
| P9 · الحساب والإعدادات | [#54](https://github.com/Doory-Store/mobile-flutter/issues/54)، [#55](https://github.com/Doory-Store/mobile-flutter/issues/55)، [#56](https://github.com/Doory-Store/mobile-flutter/issues/56)، [#57](https://github.com/Doory-Store/mobile-flutter/issues/57) |
| P10 · شاشات الحساب الفرعية | [#58](https://github.com/Doory-Store/mobile-flutter/issues/58)، [#59](https://github.com/Doory-Store/mobile-flutter/issues/59)، [#60](https://github.com/Doory-Store/mobile-flutter/issues/60)، [#61](https://github.com/Doory-Store/mobile-flutter/issues/61)، [#62](https://github.com/Doory-Store/mobile-flutter/issues/62) |
| P11 · إتمام الطلب | [#63](https://github.com/Doory-Store/mobile-flutter/issues/63)، [#64](https://github.com/Doory-Store/mobile-flutter/issues/64)، [#65](https://github.com/Doory-Store/mobile-flutter/issues/65) |
| P12 · المراجعة الشاملة | [#66](https://github.com/Doory-Store/mobile-flutter/issues/66)، [#67](https://github.com/Doory-Store/mobile-flutter/issues/67)، [#68](https://github.com/Doory-Store/mobile-flutter/issues/68) |
