import 'package:flutter/material.dart';
import '../../models/message.dart';
import 'package:flutter/services.dart';

class MessageBubble extends StatefulWidget {
  final Message message; // message model
  final bool showAvatar; // show avatar on left side (for incoming messages)
  final bool? prevMsgByYou;
  final ValueChanged<Message>? onReply;

  const MessageBubble({
    super.key,
    required this.message,
    this.showAvatar = true,
    this.prevMsgByYou,
    this.onReply,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _liftAnimation; // <-- New animation for movement
  bool _isLiked = false;
  bool _hapticTriggered = false;

  // for swipe detection with a fixed threshold
  double _dragDx = 0.0;
  static const double _replyThreshold = 45.0;

  // for drag reset
  late AnimationController _dragResetController;
  late Animation<double> _dragResetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 620,
      ), // A slightly shorter duration
    );

    _controller.addStatusListener((status) {
      // call setState to redraw the widget when the animation is done
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    // For double tap to like
    // The "lift up" phase with a fast-out curve
    final liftUp = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.5),
    ).chain(CurveTween(curve: Curves.easeOut));

    // The "settle down" phase with a slow-in curve
    final settleDown = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeIn));

    _liftAnimation = TweenSequence<Offset>([
      TweenSequenceItem(tween: liftUp, weight: 55.0),
      TweenSequenceItem(tween: settleDown, weight: 45.0),
    ]).animate(_controller);

    // the same for the scale animation
    final scaleUp = Tween<double>(
      begin: 1.0,
      end: 1.6,
    ).chain(CurveTween(curve: Curves.easeOut));
    final scaleDown = Tween<double>(
      begin: 1.6,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeIn));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: scaleUp, weight: 55.0),
      TweenSequenceItem(tween: scaleDown, weight: 45.0),
    ]).animate(_controller);

    _dragResetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _dragResetController.addListener(() {
      setState(() {
        _dragDx = _dragResetAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _dragResetController.dispose();
    super.dispose();
  }

  void _runSnapBackAnimation() {
    final startDx = _dragDx;
    _dragResetAnimation = Tween<double>(begin: startDx, end: 0.0).animate(
      CurvedAnimation(parent: _dragResetController, curve: Curves.easeOut),
    );
    _dragResetController.forward(from: 0.0);
  }

  // This widget now handles the "lifted" heart animation
  Widget _buildAnimatedHeart() {
    // We only want to show the animation when the message is already liked
    if (!_isLiked) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.isAnimating) {
          // This is the heart that "lifts off"
          return Positioned(
            bottom: -20,
            left: 10,
            child: SlideTransition(
              position: _liftAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: SizedBox(
                  height: 29,
                  width: 29,
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 35,
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMine = widget.message.isMine;
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.71;

    final maxDragDistance = screenWidth * 0.15;
    final otherGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors:
          isDark
              ? [Color(0xFF2D2D2D), Color(0xFF1F1F1F)]
              : [
                Color.fromRGBO(239, 239, 239, 1),
                Color.fromRGBO(239, 239, 239, 1),
              ],
    );

    Widget bubbleContent() {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((widget.message.text ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10,
                ),
                child: Text(
                  widget.message.text!,
                  style: TextStyle(
                    color:
                        isMine
                            ? Colors.white
                            : isDark
                            ? Colors.grey[200]
                            : Colors.black,
                    fontSize: 15.5,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    Widget bubble = Container();

    if (isMine) {
      final content = bubbleContent();
      final invisibleSizingContent = Opacity(opacity: 0.0, child: content);
      final borderRadius = BorderRadius.only(
        topLeft: Radius.circular(isMine ? 18 : 22),
        topRight: Radius.circular(isMine ? 22 : 18),
        bottomLeft: const Radius.circular(22),
        bottomRight: const Radius.circular(22),
      );

      bubble = Stack(
        clipBehavior: Clip.none, // Allow drawing outside bounds
        children: [
          // Gradient Background
          Builder(
            builder: (context) {
              final screenSize = MediaQuery.of(context).size;
              final renderBox = context.findRenderObject() as RenderBox?;
              final screenGradient = LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: const [
                  Color(0xFFE4436F),
                  Color(0xFFE4436F),
                  Color(0xFFAA3AC1),
                  Color(0xFF5D51D8),
                  Color(0xFF5D51D8),
                  Color(0xFF5D51D8),
                ],
                stops: const [0.0, 0.15, 0.45, 0.75, 0.90, 1.0],
              );
              if (renderBox == null || !renderBox.hasSize) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE4436F), Color(0xFFC34199)],
                    ),
                    borderRadius: borderRadius,
                  ),
                  child: invisibleSizingContent,
                );
              }
              final position = renderBox.localToGlobal(Offset.zero);
              return ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback:
                    (bounds) => screenGradient.createShader(
                      Rect.fromLTWH(
                        -position.dx,
                        -position.dy,
                        screenSize.width,
                        screenSize.height,
                      ),
                    ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadius,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: invisibleSizingContent,
                ),
              );
            },
          ),
          content,

          if (_isLiked)
            Positioned(
              bottom: -20,
              left: 8,
              child: Container(
                height: 29,
                width: 29,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF2D2D2D),
                ),
                child: Center(
                  // Show the placeholder ONLY when animating
                  child:
                      _controller.isAnimating
                          ? Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          )
                          : const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 19,
                          ),
                ),
              ),
            ),
        ],
      );
    } else {
      bubble = Container(
        decoration: BoxDecoration(
          gradient: otherGradient,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMine ? 18 : 22),
            topRight: Radius.circular(isMine ? 22 : 18),
            bottomLeft: const Radius.circular(22),
            bottomRight: const Radius.circular(22),
          ),
        ),
        child: bubbleContent(),
      );
    }

    final reveal = (_dragDx.abs() / _replyThreshold).clamp(0.0, 1.0);
    final showReplyPreview = reveal > 0.02;
    final previewWidth = (reveal * 96.0).clamp(0.0, 96.0);

    return Padding(
      padding: EdgeInsets.only(
        top: 3.0,
        bottom: _isLiked ? 29 : (widget.prevMsgByYou == true ? 8 : 0),
        // spacing between bubbles
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine && widget.showAvatar)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 4.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage:
                    widget.message.avatarUrl != null
                        ? NetworkImage(widget.message.avatarUrl!)
                        : null,
                backgroundColor: Colors.grey[800],
              ),
            ),
          if (!isMine && !widget.showAvatar) const SizedBox(width: 44),
          Flexible(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragUpdate: (details) {
                setState(() {
                  // left swipe for my messages
                  if (isMine) {
                    // accept negative dx, which is left swipe
                    _dragDx = (_dragDx + details.delta.dx).clamp(
                      -maxDragDistance,
                      0.0,
                    );
                  } else {
                    // right swipe for peer messages
                    _dragDx = (_dragDx + details.delta.dx).clamp(
                      0.0,
                      maxDragDistance,
                    );
                  }

                  // trigger haptic when threshold crossed
                  if (_dragDx.abs() >= _replyThreshold && !_hapticTriggered) {
                    HapticFeedback.lightImpact();
                    _hapticTriggered = true;
                  }
                });
              },
              onHorizontalDragEnd: (details) {
                // if the drag threshold crossed, trigger reply
                if (isMine && _dragDx <= -_replyThreshold) {
                  widget.onReply?.call(widget.message);
                } else if (!isMine && _dragDx >= _replyThreshold) {
                  widget.onReply?.call(widget.message);
                }

                // run snap back after drag has stopped
                _hapticTriggered = false;
                _runSnapBackAnimation();
              },
              onDoubleTap: () {
                setState(() {
                  _isLiked = !_isLiked;
                  // Only play the animation if the message is liked
                  if (_isLiked) {
                    _controller.forward(from: 0.0);
                  }
                });
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (showReplyPreview && !isMine)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: SizedBox(
                        width: previewWidth,
                        child: Opacity(
                          opacity: reveal,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.reply, size: 20),
                              const SizedBox(height: 6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (showReplyPreview && isMine)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: SizedBox(
                        width: previewWidth,
                        child: Opacity(
                          opacity: reveal,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: isMine ? 16 : 0,
                                  right: !isMine ? 16 : 0,
                                ),
                                child: const Icon(Icons.reply, size: 23),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // The actual bubble, translated by drag
                  Transform.translate(
                    offset: Offset(_dragDx, 0),
                    child: Stack(children: [bubble, _buildAnimatedHeart()]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
