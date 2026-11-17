import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/doory_colors.dart';

/// Square product photo for list rows (cart, orders, favorites).
class ProductThumb extends StatelessWidget {
  const ProductThumb({this.url, this.size = 72, super.key});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: DooryColors.surfaceSubtle,
      child: Icon(
        Icons.image_outlined,
        color: DooryColors.textMuted,
        size: size * 0.4,
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        height: size,
        child: url == null || url!.isEmpty
            ? placeholder
            : CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                memCacheWidth: (size * 3).round(),
                placeholder: (context, _) => placeholder,
                errorWidget: (context, _, _) => placeholder,
              ),
      ),
    );
  }
}
