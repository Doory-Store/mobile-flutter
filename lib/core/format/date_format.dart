/// Short Arabic dates without an intl dependency. Latin digits, matching
/// the price format.
const _months = [
  'كانون الثاني',
  'شباط',
  'آذار',
  'نيسان',
  'أيار',
  'حزيران',
  'تموز',
  'آب',
  'أيلول',
  'تشرين الأول',
  'تشرين الثاني',
  'كانون الأول',
];

String formatDate(DateTime? value) {
  if (value == null) return '';
  final local = value.toLocal();
  return '${local.day} ${_months[local.month - 1]} ${local.year}';
}

String formatTime(DateTime? value) {
  if (value == null) return '';
  final local = value.toLocal();
  final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
  final minute = local.minute.toString().padLeft(2, '0');
  final period = local.hour < 12 ? 'ص' : 'م';
  return '$hour:$minute $period';
}

String formatDateTime(DateTime? value) {
  if (value == null) return '';
  return '${formatDate(value)}، ${formatTime(value)}';
}

/// «منذ 5 دقيقة», «منذ 3 ساعة», then a date after a week.
String formatRelative(DateTime? value, {DateTime? now}) {
  if (value == null) return '';
  final diff = (now ?? DateTime.now()).difference(value);
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  if (diff.inDays < 7) return 'منذ ${diff.inDays} يوم';
  return formatDate(value);
}
