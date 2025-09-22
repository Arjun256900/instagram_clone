import 'package:flutter/material.dart';
import 'package:instagram/features/stories/presentation/widgets/story_avatar.dart';

class StoryItem extends StatefulWidget {
  final bool isYou;
  final Map<String, dynamic> storyItem;
  const StoryItem({super.key, required this.isYou, required this.storyItem});

  @override
  State<StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<StoryItem> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () {
        // story on tap
        if (widget.isYou) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Open camera / create story (stub)')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Open ${widget.storyItem['name']}\'s story (stub)'),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 86,
            width: 86,
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.expand,
              children: [
                // The main avatar widget with conditional rings
                StoryAvatar(story: widget.storyItem),

                // '+' badge for "Your story"
                if (widget.isYou)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white : Colors.black,
                        shape: BoxShape.circle,
                        // This border creates the separation from the avatar
                        border: Border.all(color: scaffoldBgColor, width: 3.5),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Username label below avatar
          SizedBox(
            width: 80,
            child: Text(
              widget.storyItem['name'],
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black87,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
