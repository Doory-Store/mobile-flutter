import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

/// One app-wide beat for every product card's social-proof line.
///
/// Cards do not own timers. They subscribe to this clock only while they are
/// visible and animating, and the single [Timer] runs only while at least one
/// card is subscribed (no cards on screen → no timer). All cards flip on the
/// same beat, so a long grid costs one timer and one cheap listener call per
/// built card every [interval].
class SocialProofClock extends ValueNotifier<int> {
  SocialProofClock({this.interval = const Duration(seconds: 2)}) : super(0);

  final Duration interval;
  Timer? _timer;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _timer ??= Timer.periodic(interval, (_) => value++);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) _stop();
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }
}

final socialProofClockProvider = Provider<SocialProofClock>((ref) {
  final clock = SocialProofClock();
  ref.onDispose(clock.dispose);
  return clock;
});

/// One rotating line: an icon plus rich text.
///
/// [missing] marks a line whose data the server does not send; it is painted
/// in the review colour by the caller through [color].
class SocialProofMessage {
  const SocialProofMessage({
    required this.icon,
    required this.spans,
    this.color,
  });

  final IconData icon;
  final List<InlineSpan> spans;

  /// Overrides icon and text colour (used for the red `BACKEND: MISSING` line).
  final Color? color;
}

/// A single-line vertical ticker.
///
/// - 2+ messages: after every clock beat the next message slides in from the
///   top while the old one leaves downward.
/// - 1 message, or reduced motion ([MediaQuery.disableAnimationsOf]): the
///   first message is shown, static, and the clock is not subscribed.
/// - Not subscribed while [TickerMode] is off (the route is covered or the
///   tab is hidden), and it resumes on the current beat when it is back.
class SocialProofTicker extends ConsumerStatefulWidget {
  const SocialProofTicker({
    required this.messages,
    required this.style,
    required this.iconColor,
    this.height = 14,
    super.key,
  });

  final List<SocialProofMessage> messages;
  final TextStyle style;
  final Color iconColor;
  final double height;

  @override
  ConsumerState<SocialProofTicker> createState() => _SocialProofTickerState();
}

class _SocialProofTickerState extends ConsumerState<SocialProofTicker> {
  static const _slide = Duration(milliseconds: 350);

  late final SocialProofClock _clock = ref.read(socialProofClockProvider);
  bool _subscribed = false;
  int _index = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(SocialProofTicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final count = widget.messages.length;
    final animate =
        count >= 2 &&
        TickerMode.valuesOf(context).enabled &&
        !MediaQuery.disableAnimationsOf(context);
    if (animate) {
      _index = _clock.value % count;
    } else if (count < 2 || MediaQuery.disableAnimationsOf(context)) {
      _index = 0;
    }
    if (animate && !_subscribed) {
      _clock.addListener(_onBeat);
      _subscribed = true;
    } else if (!animate && _subscribed) {
      _clock.removeListener(_onBeat);
      _subscribed = false;
    }
  }

  void _onBeat() {
    final next = _clock.value % widget.messages.length;
    if (next != _index) setState(() => _index = next);
  }

  @override
  void dispose() {
    if (_subscribed) _clock.removeListener(_onBeat);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) return SizedBox(height: widget.height);
    final index = _index.clamp(0, widget.messages.length - 1);
    final current = ValueKey<int>(index);
    return SizedBox(
      height: widget.height,
      child: ClipRect(
        child: AnimatedSwitcher(
          duration: _slide,
          reverseDuration: _slide,
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeOut,
          layoutBuilder: (child, previous) => Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [...previous, ?child],
          ),
          transitionBuilder: (child, animation) {
            // Incoming: from above to rest. Outgoing: the same animation runs
            // 1→0, so mapping it to a downward offset sends it off the bottom.
            final entering = child.key == current;
            final offset = Tween<Offset>(
              begin: entering ? const Offset(0, -1) : const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(position: offset, child: child);
          },
          child: _Line(
            key: current,
            message: widget.messages[index],
            style: widget.style,
            iconColor: widget.iconColor,
            height: widget.height,
          ),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.message,
    required this.style,
    required this.iconColor,
    required this.height,
    super.key,
  });

  final SocialProofMessage message;
  final TextStyle style;
  final Color iconColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = message.color;
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Icon(message.icon, size: 12, color: color ?? iconColor),
          const SizedBox(width: 3),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: color == null ? style : style.copyWith(color: color),
                children: message.spans,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
