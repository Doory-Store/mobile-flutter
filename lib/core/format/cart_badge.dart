/// Turns a cart quantity total into the tab badge, or null when it is hidden.
///
/// The count is the sum of line quantities. Zero hides the badge. Values
/// above 99 read `99+`. This is the only place that rule lives.
String? cartBadgeLabel(int quantityTotal) {
  if (quantityTotal <= 0) return null;
  final text = quantityTotal > 99 ? '99+' : '$quantityTotal';
  // LTR isolate so «99+» is not reordered to «+99» in RTL.
  return '\u2066$text\u2069';
}
