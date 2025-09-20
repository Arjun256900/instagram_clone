import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class CollapsibleCaption extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int maxLines; // collapsed max lines
  final Duration animationDuration;

  const CollapsibleCaption({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 2,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<CollapsibleCaption> createState() => _CollapsibleCaptionState();
}

class _CollapsibleCaptionState extends State<CollapsibleCaption>
    with TickerProviderStateMixin {
  bool _expanded = false;
  late TapGestureRecognizer _tapMore;
  late TapGestureRecognizer _tapLess;

  @override
  void initState() {
    super.initState();
    _tapMore = TapGestureRecognizer()..onTap = _handleTapMore;
    _tapLess = TapGestureRecognizer()..onTap = _handleTapLess;
  }

  @override
  void dispose() {
    _tapMore.dispose();
    _tapLess.dispose();
    super.dispose();
  }

  void _handleTapMore() {
    setState(() {
      _expanded = true;
    });
  }

  void _handleTapLess() {
    setState(() {
      _expanded = false;
    });
  }

  // Returns null if text fits inside maxLines (so we can show full text without 'more')
  String? _computeTruncatedText({
    required String text,
    required TextStyle style,
    required double maxWidth,
    required int maxLines,
    required String moreLabel, // e.g. ' more'
    required BuildContext context,
  }) {
    final tp = TextPainter(
      textDirection: Directionality.of(context),
      maxLines: maxLines,
    );

    // Quick: if full text fits, return null
    tp.text = TextSpan(text: text, style: style);
    tp.layout(maxWidth: maxWidth);
    if (!tp.didExceedMaxLines) return null;

    // Otherwise binary search the largest substring that fits with '... more'
    final ellipsis = '...';
    final suffix = '$ellipsis$moreLabel';
    int low = 0, high = text.length;
    String? candidate;

    while (low <= high) {
      final mid = (low + high) ~/ 2;
      final substr = text.substring(0, mid).trimRight();
      tp.text = TextSpan(text: substr + suffix, style: style);
      tp.layout(maxWidth: maxWidth);

      if (tp.didExceedMaxLines) {
        // too long, reduce
        high = mid - 1;
      } else {
        // fits — try to grow
        candidate = substr;
        low = mid + 1;
      }
    }

    return candidate ??
        text.substring(0, (text.length * 0.6).floor()).trimRight();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = widget.style ?? DefaultTextStyle.of(context).style;
    final moreLabel = ' more';
    final lessLabel = ' show less';

    return LayoutBuilder(
      builder: (context, constraints) {
        final truncated = _computeTruncatedText(
          text: widget.text,
          style: effectiveStyle,
          maxWidth: constraints.maxWidth,
          maxLines: widget.maxLines,
          moreLabel: moreLabel,
          context: context,
        );

        // If text fits, just show it normally (no toggles).
        if (truncated == null) {
          return Text(widget.text, style: effectiveStyle);
        }

        return AnimatedSize(
          duration: widget.animationDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child:
              _expanded
                  // Expanded state: full text + "show less"
                  ? RichText(
                    text: TextSpan(
                      style: effectiveStyle,
                      children: [
                        TextSpan(text: widget.text),
                        TextSpan(
                          text: lessLabel,
                          style: effectiveStyle.copyWith(color: Colors.grey),
                          recognizer: _tapLess,
                        ),
                      ],
                    ),
                  )
                  // Collapsed state: truncated + '... more'
                  : RichText(
                    text: TextSpan(
                      style: effectiveStyle,
                      children: [
                        TextSpan(text: truncated),
                        const TextSpan(text: '...'),
                        TextSpan(
                          text: moreLabel,
                          style: effectiveStyle.copyWith(color: Colors.grey),
                          recognizer: _tapMore,
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
