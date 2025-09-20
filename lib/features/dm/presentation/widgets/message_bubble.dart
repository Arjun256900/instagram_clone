import 'package:flutter/material.dart';
import '../../models/message.dart';

class MessageBubble extends StatefulWidget {
  final Message message; // message model
  final bool showAvatar; // show avatar on left side (for incoming messages)
  final bool? prevMsgByYou;

  const MessageBubble({
    super.key,
    required this.message,
    this.showAvatar = true,
    this.prevMsgByYou,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _liftAnimation; // <-- New animation for movement
  bool _isLiked = false;

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
      // When the animation is done, call setState to redraw the widget
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    // Part 1: The "lift up" phase with a fast-out curve
    final liftUp = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.5),
    ).chain(CurveTween(curve: Curves.easeOut));

    // Part 2: The "settle down" phase with a slow-in curve
    final settleDown = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeIn));

    _liftAnimation = TweenSequence<Offset>([
      TweenSequenceItem(tween: liftUp, weight: 55.0),
      TweenSequenceItem(tween: settleDown, weight: 45.0),
    ]).animate(_controller);

    // Do the same for the scale animation
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    final isMine = widget.message.isMine;
    final maxWidth = MediaQuery.of(context).size.width * 0.71;

    final otherGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2D2D2D), Color(0xFF1F1F1F)],
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
                    color: isMine ? Colors.white : Colors.grey[200],
                    fontSize: 15.5,
                    height: 1.2,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    Widget bubble;

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
              onDoubleTap: () {
                setState(() {
                  _isLiked = true;
                  // Only play the animation if the message is liked
                  if (_isLiked) {
                    _controller.forward(from: 0.0);
                  }
                });
              },
              child: Stack(children: [bubble, _buildAnimatedHeart()]),
            ),
          ),
        ],
      ),
    );
  }
}
