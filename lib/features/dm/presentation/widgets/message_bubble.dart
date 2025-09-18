import 'package:flutter/material.dart';
import '../../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
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

    // Colors / gradients
    final mineGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF8A2BE2), Color(0xFF7B61FF)], // purple-ish gradient
    );

    final otherGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2D2D2D), Color(0xFF1F1F1F)],
    );

    // String _formatTime(DateTime t) {
    //   final h = t.hour.toString().padLeft(2, '0');
    //   final m = t.minute.toString().padLeft(2, '0');
    //   return '$h:$m';
    // }

    Widget bubbleContent() {
      // For now we only render text type. Attachments like post/reel can be implemented later.
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // message text
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // Left side avatar for other messages
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

          // Bubble
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                gradient: isMine ? mineGradient : otherGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMine ? 18 : 22),
                  topRight: Radius.circular(isMine ? 22 : 18),
                  bottomLeft: const Radius.circular(22),
                  bottomRight: const Radius.circular(22),
                ),
                boxShadow: [
                  if (isMine)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                ],
              ),
              child: bubbleContent(),
            ),
          ),
        ],
      ),
    );
  }
}
