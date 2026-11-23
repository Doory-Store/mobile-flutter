/// Turns a cart quantity total into the tab badge, or null when it is hidden.
///
/// The count is the sum of line quantities. Zero hides the badge. Values
/// above 99 read `99+`. This is the only place that rule lives.
String? cartBadgeLabel(int quantityTotal) {
  if (quantityTotal <= 0) return null;
  if (quantityTotal > 99) return '99+';
  return '$quantityTotal';
}
