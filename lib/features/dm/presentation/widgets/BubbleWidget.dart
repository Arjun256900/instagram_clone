import 'package:flutter/material.dart';

class BubbleWidget extends StatelessWidget {
  final bool isMine;
  final bool isLiked;
  final AnimationController controller;
  final Widget Function(BorderRadius borderRadius) bubbleContentBuilder;
  final Gradient myGradient;
  final Gradient otherGradient;

  const BubbleWidget({
    super.key,
    required this.isMine,
    required this.isLiked,
    required this.controller,
    required this.bubbleContentBuilder,
    required this.myGradient,
    required this.otherGradient,
  });

  @override
  Widget build(BuildContext context) {
    if (isMine) {
      // your own message bubble
      final borderRadius = BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(22),
        bottomLeft: const Radius.circular(22),
        bottomRight: const Radius.circular(22),
      );
      final builtContent = bubbleContentBuilder(borderRadius);
      final invisibleSizingContent = Opacity(opacity: 0.0, child: builtContent);

      return Stack(
        clipBehavior: Clip.none, // Allow drawing outside bounds
        children: [
          // Gradient Background using a ShaderMask
          Builder(
            builder: (context) {
              final screenSize = MediaQuery.of(context).size;
              final renderBox = context.findRenderObject() as RenderBox?;
              if (renderBox == null || !renderBox.hasSize) {
                // Fallback container while the size is not yet available
                return Container(
                  decoration: BoxDecoration(
                    gradient: myGradient,
                    borderRadius: borderRadius,
                  ),
                  child: invisibleSizingContent,
                );
              }
              final position = renderBox.localToGlobal(Offset.zero);
              return ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback:
                    (bounds) => myGradient.createShader(
                      Rect.fromLTWH(
                        -position.dx,
                        -position.dy,
                        screenSize.width,
                        screenSize.height,
                      ),
                    ),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Colors.white, // This color is masked with the gradient
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

          // The actual content, visible on top
          builtContent,

          // The 'liked' heart icon
          if (isLiked)
            Positioned(
              bottom: -20,
              left: 8,
              child: Container(
                height: 29,
                width: 29,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF2D2D2D),
                ),
                child: Center(
                  child:
                      controller.isAnimating
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
      // the other person's message bubble
      final borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(18),
        bottomLeft: Radius.circular(22),
        bottomRight: Radius.circular(22),
      );
      return Container(
        decoration: BoxDecoration(
          gradient: otherGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
        ),
        child: bubbleContentBuilder(borderRadius),
      );
    }
  }
}
