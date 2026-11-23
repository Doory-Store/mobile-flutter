import 'package:material_ui/material_ui.dart';

import '../l10n/doory_strings.dart';
import '../theme/doory_tokens.dart';
import '../theme/doory_typography.dart';

enum SearchPillMode { idle, active, summary }

/// Shared search field. The painted pill is 38 dp; the touch height is 48.
class SearchPill extends StatefulWidget {
  const SearchPill({
    this.mode = SearchPillMode.idle,
    this.hint = DooryStrings.searchHint,
    this.text = '',
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  final SearchPillMode mode;
  final String hint;
  final String text;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;
  final bool enabled;

  /// Painted pill, so tests can measure 38 dp apart from the 48 dp target.
  static const visualKey = ValueKey<String>('search-pill-visual');

  @override
  State<SearchPill> createState() => _SearchPillState();
}

class _SearchPillState extends State<SearchPill> {
  late final TextEditingController _controller;
  final FocusNode _focus = FocusNode();
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _focus.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(SearchPill oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text && widget.text != _controller.text) {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  bool get _showClear =>
      widget.enabled &&
      widget.mode == SearchPillMode.active &&
      _controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final tokens = DooryTokens.of(context);
    final scheme = Theme.of(context).colorScheme;
    final disabled = !widget.enabled;
    final focused = widget.mode == SearchPillMode.active && _focus.hasFocus;
    final fill = disabled
        ? tokens.surfaceSubtle
        : _pressed
        ? tokens.primarySubtle
        : tokens.surfaceSubtle;
    final textColor = disabled ? tokens.textMuted : scheme.onSurface;
    final hintColor = disabled ? tokens.textMuted : scheme.onSurfaceVariant;

    final pill = AnimatedContainer(
      key: SearchPill.visualKey,
      duration: DooryMotion.press,
      curve: Curves.easeOut,
      height: 38,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(19),
        border: focused ? Border.all(color: scheme.primary, width: 2) : null,
      ),
      padding: const EdgeInsetsDirectional.only(start: 4),
      child: Row(
        children: [
          const SizedBox(
            width: 40,
            child: Icon(Icons.search, size: DooryIconSize.chrome),
          ),
          Expanded(child: _field(textColor, hintColor)),
          if (_showClear)
            SizedBox(
              width: 40,
              height: 38,
              child: IconButton(
                tooltip: DooryStrings.clearSearch,
                onPressed: () {
                  _controller.clear();
                  widget.onClear?.call();
                  widget.onChanged?.call('');
                  _focus.requestFocus();
                  setState(() {});
                },
                icon: Icon(
                  Icons.close,
                  size: DooryIconSize.chrome,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );

    return SizedBox(
      height: 48,
      child: Center(
        child: Semantics(
          button: widget.mode != SearchPillMode.active,
          textField: widget.mode == SearchPillMode.active,
          enabled: widget.enabled,
          label: DooryStrings.searchAction,
          hint: widget.mode == SearchPillMode.active ? widget.hint : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: widget.enabled && widget.mode != SearchPillMode.active
                ? (_) => setState(() => _pressed = true)
                : null,
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            onTap: !widget.enabled || widget.mode == SearchPillMode.active
                ? null
                : widget.onTap,
            child: pill,
          ),
        ),
      ),
    );
  }

  Widget _field(Color textColor, Color hintColor) {
    final style = DooryTypography.body(context).copyWith(color: textColor);
    if (widget.mode == SearchPillMode.active) {
      return TextField(
        controller: _controller,
        focusNode: _focus,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        textAlign: TextAlign.start,
        style: style,
        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          isCollapsed: true,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: widget.hint,
          hintStyle: DooryTypography.body(context).copyWith(color: hintColor),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          setState(() {});
          widget.onChanged?.call(value);
        },
        onSubmitted: widget.onSubmitted,
      );
    }
    final shown =
        widget.mode == SearchPillMode.summary && widget.text.isNotEmpty
        ? widget.text
        : widget.hint;
    final color =
        widget.mode == SearchPillMode.summary && widget.text.isNotEmpty
        ? textColor
        : hintColor;
    return Text(
      shown,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: DooryTypography.body(context).copyWith(color: color),
    );
  }
}
