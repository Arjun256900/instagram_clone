import 'package:flutter/material.dart';
import '../../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message; // message model
  final bool showAvatar; // show avatar on left side (for incoming messages)

  const MessageBubble({
    super.key,
    required this.message,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    final maxWidth = MediaQuery.of(context).size.width * 0.72;

    final otherGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2D2D2D), Color(0xFF1F1F1F)],
    );

    Widget bubbleContent() {
      // This widget remains the same. It just holds the text.
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if ((message.text ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 12,
                ),
                child: Text(
                  message.text!,
                  style: TextStyle(
                    color: isMine ? Colors.white : Colors.grey[200],
                    fontSize: 15,
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
      // We use a Stack to layer the text on top of the gradient.

      // We create the actual content first to know the bubble's size.
      final content = bubbleContent();

      // create an invisible copy of the content to correctly size the background.
      final invisibleSizingContent = Opacity(opacity: 0.0, child: content);

      final borderRadius = BorderRadius.only(
        topLeft: Radius.circular(isMine ? 18 : 22),
        topRight: Radius.circular(isMine ? 22 : 18),
        bottomLeft: const Radius.circular(22),
        bottomRight: const Radius.circular(22),
      );

      bubble = Stack(
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
                  Color(0xFFC34199),
                  Color(0xFF8B3AB4),
                  Color(0xFF5D51D8),
                  Color(0xFF5D51D8),
                ],
                stops: const [0.0, 0.15, 0.45, 0.75, 0.90, 1.0],
              );

              if (renderBox == null || !renderBox.hasSize) {
                // Simple fallback for the first frame
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
                    color: Colors.white, // Shape color for the mask
                    borderRadius: borderRadius,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  // This invisible child gives the container its size
                  child: invisibleSizingContent,
                ),
              );
            },
          ),

          // LAYER 2: The Visible Text Content
          content,
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
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMine && showAvatar)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 4.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage:
                    message.avatarUrl != null
                        ? NetworkImage(message.avatarUrl!)
                        : null,
                backgroundColor: Colors.grey[800],
              ),
            ),
          if (!isMine && !showAvatar) const SizedBox(width: 44),
          Flexible(child: bubble),
        ],
      ),
    );
  }
}
