#!/usr/bin/env bash
# ينشئ الـ Milestones من issues-draft.json ويربط كل Issue بها حسب issues-map.md.
# يتطلب: gh مسجّل الدخول (gh auth login) و jq. آمن للتكرار: يتخطى الموجود.
set -euo pipefail
REPO=Doory-Store/mobile-flutter
DIR="$(cd "$(dirname "$0")" && pwd)"
jq -c ".milestones[]" "$DIR/issues-draft.json" | while read -r m; do
  t=$(jq -r .title <<<"$m"); desc=$(jq -r .description <<<"$m")
  if gh api "repos/$REPO/milestones?state=all&per_page=100" --jq ".[].title" | grep -Fxq "$t"; then echo "exists: $t"; else gh api "repos/$REPO/milestones" -f title="$t" -f description="$desc" >/dev/null; echo "created: $t"; sleep 1; fi
done
declare -A MS
while IFS=$'\t' read -r num title; do MS["$title"]=$num; done < <(gh api "repos/$REPO/milestones?state=all&per_page=100" --jq '.[] | "\(.number)\t\(.title)"')
# issue -> milestone title
while IFS=$'\t' read -r issue mtitle; do
  gh api -X PATCH "repos/$REPO/issues/$issue" -F milestone="${MS[$mtitle]}" >/dev/null && echo "#$issue -> $mtitle"; sleep 0.5
done <<'EOF'
5	P0 · الأساس ونظام التصميم
6	P0 · الأساس ونظام التصميم
7	P0 · الأساس ونظام التصميم
8	P0 · الأساس ونظام التصميم
9	P0 · الأساس ونظام التصميم
10	P0 · الأساس ونظام التصميم
11	P0 · الأساس ونظام التصميم
12	P0 · الأساس ونظام التصميم
13	P0 · الأساس ونظام التصميم
14	P0 · الأساس ونظام التصميم
15	P1 · تسجيل الدخول
16	P1 · تسجيل الدخول
17	P1 · تسجيل الدخول
18	P1 · تسجيل الدخول
19	P1 · تسجيل الدخول
20	P2 · الرئيسية
21	P2 · الرئيسية
22	P2 · الرئيسية
23	P2 · الرئيسية
24	P2 · الرئيسية
25	P2 · الرئيسية
26	P3 · الفئات
27	P3 · الفئات
28	P3 · الفئات
29	P3 · الفئات
30	P4 · البحث
31	P4 · البحث
32	P4 · البحث
33	P4 · البحث
34	P5 · قائمة المنتجات والفرز والفلترة
35	P5 · قائمة المنتجات والفرز والفلترة
36	P5 · قائمة المنتجات والفرز والفلترة
37	P5 · قائمة المنتجات والفرز والفلترة
38	P5 · قائمة المنتجات والفرز والفلترة
39	P5 · قائمة المنتجات والفرز والفلترة
40	P6 · صفحة المنتج
41	P6 · صفحة المنتج
42	P6 · صفحة المنتج
43	P6 · صفحة المنتج
44	P6 · صفحة المنتج
45	P6 · صفحة المنتج
46	P6 · صفحة المنتج
47	P7 · السلة
48	P7 · السلة
49	P7 · السلة
50	P7 · السلة
51	P8 · المفضلات
52	P8 · المفضلات
53	P8 · المفضلات
54	P9 · الحساب والإعدادات
55	P9 · الحساب والإعدادات
56	P9 · الحساب والإعدادات
57	P9 · الحساب والإعدادات
58	P10 · شاشات الحساب الفرعية
59	P10 · شاشات الحساب الفرعية
60	P10 · شاشات الحساب الفرعية
61	P10 · شاشات الحساب الفرعية
62	P10 · شاشات الحساب الفرعية
63	P11 · إتمام الطلب
64	P11 · إتمام الطلب
65	P11 · إتمام الطلب
66	P12 · المراجعة الشاملة
67	P12 · المراجعة الشاملة
68	P12 · المراجعة الشاملة
EOF
