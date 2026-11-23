# P0 · سلّم Cairo

الخط Cairo بالأوزان 400 و600 و700، من `assets/fonts/`. الاحتياط Tahoma ثم sans للمنصة. `letterSpacing` يبقى 0. `TextStyle.height` = ارتفاع السطر ÷ حجم الخط. الأحجام بالـ sp، وارتفاعات السطر بالـ dp.

هذا السلّم يحل محل أدوار `DESIGN.md` §2 في الواجهة الجديدة. الأسماء القديمة تبقى دوالاً تشير إلى الدور الجديد حتى تنتهي الشاشات القديمة، بحسب جدول الربط في أسفل الملف.

## السلّم

| الدور | الدالة المقترحة | الحجم / السطر | الوزن | رمز اللون |
|---|---|---|---|---|
| `wordmark` | `wordmark` | 24 / 32 | 700 | `primary` |
| `wordmarkDisplay` | `wordmarkDisplay` | 40 / 52 | 700 | `primary` |
| `toolbarTitle` | `toolbarTitle` | 18 / 24 | 700 | `textPrimary` |
| `sectionTitle` | `sectionTitle` | 16 / 22 | 700 | `textPrimary` |
| `rowLabel` | `rowLabel` | 15 / 22 | 400 | `textPrimary` |
| `rowLabelStrong` | `rowLabelStrong` | 15 / 22 | 700 | `textPrimary` |
| `body` | `body` | 14 / 20 | 400 | `textPrimary` |
| `bodySecondary` | `bodySecondary` | 14 / 20 | 400 | `textSecondary` |
| `cardTitle` | `cardTitle` | 12 / 16 | 400 | `textPrimary` |
| `cardBrand` | `cardBrand` | 12 / 16 | 700 | `textPrimary` |
| `price` | `price` | 14 / 18 | 700 | `cardPrice` |
| `priceLarge` | `priceLarge` | 18 / 24 | 700 | `primary` (افتراض §3 في القرارات) |
| `priceCompact` | `priceCompact` | 16 / 20 | 700 | `cardPrice` |
| `strike` | `strike` | 11 / 14 | 400 | `textSecondary`، مع `TextDecoration.lineThrough` |
| `caption` | `caption` | 12 / 16 | 400 | `textSecondary` |
| `captionStrong` | `captionStrong` | 11 / 14 | 600 | `textPrimary` |
| `chipLabel` | `chipLabel` | 13 / 18 | 600 | حسب حالة الـ Chip |
| `tabLabel` | `tabLabel` | 11 / 14 | 600 | `primary` أو `textPrimary` |
| `button` | `button` | 16 / 22 | 700 | `textOnStrong` أو `primary` أو `textPrimary` |
| `buttonCompact` | `buttonCompact` | 14 / 18 | 700 | لون الزر نفسه على ارتفاع 36 |
| `link` | `link` | 14 / 20 | 700 | `cardPrice` |

لون `chipLabel` و`button` و`tabLabel` يأتي من حالة المكوّن، والجدول يثبت الحجم والوزن.

## أين يُستخدم كل دور

| الدور | المكان |
|---|---|
| `wordmark` | الشعار في رأس الرئيسية وفي أي شريط 56 dp |
| `wordmarkDisplay` | شاشة الدخول في P1. القياس لشعار رسومي، والرقم افتراض [`p0-decisions.md`](p0-decisions.md) §7 |
| `toolbarTitle` | عنوان `DooryAppBar` وعنوان حالة الفراغ |
| `sectionTitle` | `SectionHeader` وعنوان `GroupCard` |
| `rowLabel` | صف قائمة عادي |
| `rowLabelStrong` | عنوان صف فلتر أو عنوان مجموعة سطرين |
| `body` / `bodySecondary` | رسالة الفراغ والوصف |
| `cardBrand` ثم `cardTitle` | سطر عنوان البطاقة: المتجر أو الماركة عريض، ثم الاسم عادي، وسطران كحد أقصى |
| `price` | سعر بطاقة العمود وبطاقة الرف |
| `priceCompact` | سعر سطر السلة والشريط اللاصق حين يضيق 18sp |
| `priceLarge` | سعر صفحة المنتج وملخص السلة |
| `strike` | السعر المرجعي المشطوب |
| `caption` | «سعر تقريبي»، ووصف ثانوي، وتاريخ |
| `captionStrong` | رقم التقييم وعدد الألوان |
| `chipLabel` | `DooryChip` |
| `tabLabel` | تسمية التبويب |
| `button` | أزرار 40 و45 و48 و53 |
| `buttonCompact` | زر 36 |
| `link` | «رؤية الكل» و«اكتشف المزيد» و«مسح» |

## قواعد الكتابة

- العربي يلتف. لا `FittedBox` يصغّر النص تحت هذا السلّم.
- عند مقياس خط النظام 1.3× تبقى الأوزان والألوان، ويزداد ارتفاع السطر مع المقياس. البطاقة تطول. التبويب سطر واحد مع حذف `ellipsis` إن ضاق العرض.
- اسم لاتيني أو سعر داخل جملة عربية يُعزل باتجاه LTR (`\u2066` … `\u2069`) كما يفعل `formatSyp` اليوم.
- العملة «ل.س» جزء من سلسلة السعر، لا عنصر مستقل. التنسيق في [`p0-decisions.md`](p0-decisions.md) §1 و§2.
- «بيانات تجريبية» بالدور `captionStrong` داخل `DemoLabel`.

## ربط الأسماء القديمة

[#6](https://github.com/Doory-Store/mobile-flutter/issues/6) يحدّث الدوال القائمة حتى لا تبقى الشاشات الحالية على السلّم الكبير بالخطأ بعد اعتماد P0.

| الدالة القائمة | تشير بعد التحديث إلى |
|---|---|
| `wordmark` | `wordmark` |
| `page` | `toolbarTitle` |
| `section` | `sectionTitle` |
| `shelf` | `sectionTitle` |
| `body` | `body` |
| `productTitle` | `rowLabel` |
| `cardTitle` | `cardTitle` |
| `cardBrand` | `cardBrand` |
| `pdpPrice` | `priceLarge` |
| `cardPrice` | `price` |
| `compactPrice` | `priceCompact` |
| `cta` | `button` |
| `label` | `bodySecondary` |
| `labelStrong` | `link` |
| `cardMeta` | `caption` |
| `navLabel` | `tabLabel` |
| `shortcut` | تبقى 10 / 13 / 600 للنص فوق صور صغيرة لاحقة، وخارج مكوّنات P0 |

`TextTheme` في `dooryTheme()` يتبع السلّم الجديد: `titleLarge` ← `toolbarTitle`، `titleMedium` ← `sectionTitle`، `bodyLarge` ← `body`، `bodyMedium` ← `rowLabel` بحجم 15، `labelLarge` ← `button` بحجم 16 ووزن 700، `labelSmall` ← `caption`.
