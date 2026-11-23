# سير العمل

كل مرحلة تمر بنفس الخط: **مواصفات التصميم، ثم التنفيذ، ثم الفحص، ثم اعتماد المستخدم، ثم الدمج.** المنسّق (doory mobile) يوزّع المهام على المساعدين وينقل النتائج بينهم، لأن كل مساعد يعمل بسياق منفصل.

## دورة المرحلة

1. **فتح المرحلة.** المنسّق يفتح الـ Milestone ويتأكد أن الـ Issues جاهزة (`issues-draft.md`). بعدها ينشئ فرع المرحلة من `rebuild/main`.
2. **مواصفات التصميم (Mobile Designer).** لكل شاشة في المرحلة يكتب المصمم ملفاً بالاسم `docs/trendyol-rebuild/specs/pN-<screen>.md`، فيه:
   - لقطة ترينديول المرجعية من `ref/`.
   - شجرة المكوّنات من الأعلى للأسفل.
   - المقاسات بالـ dp والرموز من `dimensions.md`.
   - النصوص العربية النهائية.
   - الحالات (تحميل، فراغ، خطأ، ضيف، مسجّل).
   - ما يُستبدل بهوية دوري.

   المواصفة تُضاف كتعليق على الـ Issue، ويُضاف لها Label `status:spec-ready`.
3. **التنفيذ (Flutter Engineer).** يعمل المهندس على المواصفة في فرع المرحلة، بـ commits صغيرة مرتبطة بالـ Issue. ويكتب Widget tests وGolden tests. قبل التسليم يشغّل `dart format .` و`flutter analyze` و`flutter test`، ثم يفتح أو يحدّث الـ PR.
4. **الفحص (Mobile QA).**
   - يشغّل التطبيق على `emulator-5554`.
   - يلتقط كل حالة بـ `adb exec-out screencap`، ويضعها جنب لقطة ترينديول.
   - يقيس العناصر الأساسية من `uiautomator dump`.
   - يكتب تقريراً في الـ PR: ما يطابق، والفروق بالأرقام، والأخطاء.

   كل خطأ يصير Issue بـ Label `type:bug` في نفس الـ Milestone.
5. **اعتماد المستخدم.** المنسّق يرسل للمستخدم لقطات الاعتماد المذكورة في `phases.md` لهذه المرحلة، كل لقطة جنب مرجعها. الملاحظات ترجع للخطوة 2 أو 3. الموافقة تضيف Label `status:approved`.
6. **الدمج.** يُدمج PR المرحلة في `rebuild/main`، وتُغلق الـ Issues والـ Milestone، ويُضاف Tag `rebuild-pN`.

المرحلة التالية تبدأ بعد الدمج. أما مواصفات المرحلة التالية، فيكتبها المصمم بالتوازي أثناء فحص المرحلة الحالية لتوفير الوقت.

## الفروع

| الفرع | الغرض |
|---|---|
| `main` | النسخة المستقرة |
| `rebuild/main` | فرع التكامل لإعادة البناء، يتفرع من `main`، وفيه تُدمج المراحل |
| `rebuild/pN-<slug>` | فرع المرحلة، مثل `rebuild/p0-foundation` و`rebuild/p2-home`، ومنه PR واحد إلى `rebuild/main` |
| `rebuild/pN-<issue>-<slug>` | فرع اختياري لمهمة كبيرة داخل المرحلة، يُدمج في فرع المرحلة |
| `mobile/trendyol-rebuild-docs` | هذه الوثائق |

عندما تكتمل المراحل وتُعتمد، يُفتح PR من `rebuild/main` إلى `main`.

## الـ Commits

بصيغة Conventional Commits بالإنكليزية، مع رقم الـ Issue:

```
feat(home): add channel tabs header (#12)
fix(listing): keep 8dp gutter in RTL grid (#31)
test(cart): golden for empty cart (#44)
docs(rebuild): phase 3 category specs (#20)
```

الأنواع: `feat` و`fix` و`refactor` و`test` و`docs` و`chore` و`style`. والنطاق (scope) هو اسم الـ feature أو `core` أو `rebuild`.

## الـ Pull Requests

- العنوان: `[P2] الرئيسية: رأس القنوات والأقسام`.
- الوصف فيه:
  - `Closes #..` لكل Issue.
  - جدول لقطات: Trendyol | Doory لكل حالة.
  - نتائج `flutter analyze` و`flutter test`.
  - أي بند انتقل إلى `INCOMPLETE.md`.
- يحتاج PR المرحلة تقرير QA وموافقة المستخدم قبل الدمج.

## الـ Issues

- عنوانها بالعربية مع بادئة المرحلة: `[P5] ورقة الفرز`.
- جسمها فيه:
  - **الهدف**، و**المرجع** (روابط `ref/`)، و**المقاسات**.
  - **الحالات**، و**معايير القبول** كـ Checklist.
  - **خارج النطاق**.
- كل Issue لها Label نوع، وLabel منطقة، وLabel دور، وتتبع Milestone مرحلتها.

## الـ Labels

القائمة الكاملة مع الألوان في `issues-draft.md`. التصنيف:

- **النوع** `type:*`: feature أو design-spec أو qa أو bug أو docs أو chore.
- **المنطقة** `area:*`: foundation، وauth، وhome، وcategories، وsearch، وlisting، وproduct، وcart، وfavorites، وaccount، وcheckout.
- **الدور** `role:*`: designer أو flutter أو qa أو api.
- **الحالة** `status:*`: spec-ready، وin-progress، وneeds-approval، وapproved، وblocked.
- **النطاق**: `ui-only` لكل عمل هذا المسار.

## الـ Milestones

Milestone لكل مرحلة، باسم `P0 · الأساس ونظام التصميم` حتى `P12 · المراجعة الشاملة`. وصفها هو هدف المرحلة من `phases.md` ورابط له.

## العوائق

- أي بند لا يمكن إنجازه في المرحلة يُكتب في `mobile-flutter/INCOMPLETE.md` تحت عنوان `## Trendyol rebuild`، مع: المرحلة، والسبب، والخطوة التالية. والعمل يستمر في باقي البنود.
- الـ Issue المتوقفة تأخذ Label `status:blocked` وتعليقاً بالسبب.
- المنسّق يذكر العوائق المفتوحة في كل رسالة اعتماد.

## أوامر مرجعية

```powershell
$adb="$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
& $adb -s emulator-5554 exec-out screencap -p > shot.png
& $adb -s emulator-5554 shell uiautomator dump /sdcard/ui.xml; & $adb pull /sdcard/ui.xml
& $adb -s emulator-5554 shell am start -n trendyol.com/com.trendyol.international.main.impl.ui.InternationalActivity
```

لتحويل البكسل إلى dp على هذا المحاكي: `dp = px / 2.625`. وسكربت الالتقاط الجاهز موجود في `C:\Users\bahaa\Desktop\Doory\trendyol-ref\cap.ps1`، ويوفّر الدالتين `cap <name>` و`els <name>`.
