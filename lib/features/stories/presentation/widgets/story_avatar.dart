import 'package:flutter/material.dart';

class StoryAvatar extends StatefulWidget {
  final Map<String, dynamic> story;
  const StoryAvatar({super.key, required this.story});

  @override
  State<StoryAvatar> createState() => _StoryAvatarState();
}

class _StoryAvatarState extends State<StoryAvatar> {
  // A predefined gradient for new story rings.
  static const _storyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Colors.yellow, Colors.orange, Colors.red, Colors.purple],
  );

  @override
  Widget build(BuildContext context) {
    // Extract boolean flags from the widget's story data for easier access.
    final bool isYou = widget.story['isYou'] == true;
    final bool isNew = widget.story['isNew'] == true;
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Handle "Your story" avatar size separately and return early.
    // It doesn't have a status ring.
    if (isYou) {
      return CircleAvatar(
        radius:
            32, // Use a smaller, fixed radius for the user's own story avatar.
        backgroundImage: NetworkImage(widget.story['avatar']),
        // Set a fallback background color while the image loads.
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
      );
    }

    // Build the avatar for other users' stories.
    final Widget avatar = CircleAvatar(
      radius: 35, // Standard radius for other stories.
      backgroundImage: NetworkImage(widget.story['avatar']),
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
    );

    // This outer container holds the ring (which can be a gradient or a solid color).
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Apply a gradient if the story is new, otherwise use a solid color.
        gradient: isNew ? _storyGradient : null,
        color:
            !isNew
                ? (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300)
                : null,
      ),
      // This padding creates the space between the ring and the avatar's background.
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // The inner background color matches the screen's background to create a "gap" effect.
            color: scaffoldBgColor,
          ),
          // This padding is the final gap between the inner background and the avatar image itself.
          child: Padding(padding: const EdgeInsets.all(4.0), child: avatar),
        ),
      ),
    );
  }
}
