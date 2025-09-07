import 'package:flutter/material.dart';

class Stories extends StatefulWidget {
  const Stories({super.key});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  // (Dummy stories list and gradient remain the same)
  final List<Map<String, dynamic>> _stories = [
    {
      'id': 'you',
      'name': 'Your story',
      'avatar': 'https://i.pravatar.cc/200?img=5',
      'isNew': false,
      'isYou': true,
    },
    {
      'id': '1',
      'name': 'runwaylayla',
      'avatar': 'https://i.pravatar.cc/200?img=11',
      'isNew': true,
      'isYou': false,
    },
    {
      'id': '2',
      'name': 'prince_of_wale',
      'avatar': 'https://i.pravatar.cc/200?img=12',
      'isNew': true,
      'isYou': false,
    },
    {
      'id': '3',
      'name': '_bha._.rat',
      'avatar': 'https://i.pravatar.cc/200?img=13',
      'isNew': false,
      'isYou': false,
    },
    {
      'id': '4',
      'name': 'wanderer',
      'avatar': 'https://i.pravatar.cc/200?img=14',
      'isNew': true,
      'isYou': false,
    },
    {
      'id': '5',
      'name': 'tech_savvy',
      'avatar': 'https://i.pravatar.cc/200?img=15',
      'isNew': false,
      'isYou': false,
    },
    {
      'id': '6',
      'name': 'art_by_mia',
      'avatar': 'https://i.pravatar.cc/200?img=16',
      'isNew': true,
      'isYou': false,
    },
  ];

  final Gradient _storyGradient = const SweepGradient(
    colors: [
      Color(0xFFFFD600),
      Color(0xFFFF7A00),
      Color(0xFFFF0069),
      Color(0xFFFFD600),
    ],
    startAngle: 0.0,
    endAngle: 6.28,
  );
  // Helper widget to build the avatar with its correct style ring
  Widget _buildStoryAvatar(
    Map<String, dynamic> story, {
    required bool isDarkMode,
  }) {
    final bool isYou = story['isYou'] == true;
    final bool isNew = story['isNew'] == true;
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    Widget avatar = CircleAvatar(
      radius: 35,
      backgroundImage: NetworkImage(story['avatar']),
      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
    );

    // Case 1: Your story (no ring needed, just the avatar)
    if (isYou) {
      return avatar;
    }

    // This container will hold the ring (gradient or grey)
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Case 2: New story (apply gradient)
        gradient: isNew ? _storyGradient : null,
        // Case 3: Viewed story (apply grey border)
        border:
            !isNew // viewed story ring
                ? Border.all(
                  color:
                      isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                  width: 3.5,
                )
                : null,
      ),
      // This padding creates the space between the ring and the avatar
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scaffoldBgColor, // Inner background to match the screen
          ),
          // Final padding for the avatar itself
          child: Padding(padding: const EdgeInsets.all(5.0), child: avatar),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;

    return SizedBox(
      height: 130, // Adjusted height for a more compact look
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: _stories.length,
        // gap between stories
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _stories[index];
          final bool isYou = item['isYou'] == true;
          final bool isNew = item['isNew'] == true;

          return GestureDetector(
            onTap: () {
              // story on tap
              if (isYou) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Open camera / create story (stub)'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Open ${item['name']}\'s story (stub)'),
                  ),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 95,
                  width: 95,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      // The main avatar widget with conditional rings
                      _buildStoryAvatar(item, isDarkMode: isDarkMode),

                      // '+' badge for "Your story"
                      if (isYou)
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
                              border: Border.all(
                                color: scaffoldBgColor,
                                width: 3.5,
                              ),
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
                    item['name'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
