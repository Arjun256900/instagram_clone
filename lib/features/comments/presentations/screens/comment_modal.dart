import 'package:flutter/material.dart';

class CommentModal extends StatefulWidget {
  const CommentModal({super.key});

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.55,
      maxChildSize: 0.97,
      expand: false,
      builder: (context, scrollController) {
        // (placeholder comments list remains the same)
        final comments = [
          {
            'avatar': null,
            'user': 'tishahhhhh',
            'time': '6w.',
            'text': 'my dreams be like😭😭😭',
            'likes': '11421',
            'hasImage': false,
          },
          {
            'avatar': null,
            'user': 'sagarchauhan3161',
            'time': '6w',
            'text': 'Bhagg tu raha hai.. fatt meri rahi hai 😂😂',
            'likes': '46457',
            'hasImage': false,
          },
          {
            'avatar': null,
            'user': 'dosbol_201401',
            'time': '15w.',
            'text': '',
            'likes': '6578',
            'hasImage': true,
          },
          {
            'avatar': null,
            'user': 'tishahhhhh',
            'time': '6w.',
            'text': 'my dreams be like😭😭😭',
            'likes': '11421',
            'hasImage': false,
          },
          {
            'avatar': null,
            'user': 'sagarchauhan3161',
            'time': '6w',
            'text': 'Bhagg tu raha hai.. fatt meri rahi hai 😂😂',
            'likes': '46457',
            'hasImage': false,
          },
          {
            'avatar': null,
            'user': 'dosbol_201401',
            'time': '15w.',
            'text': '',
            'likes': '6578',
            'hasImage': true,
          },
          {
            'avatar': null,
            'user': 'tishahhhhh',
            'time': '6w.',
            'text': 'my dreams be like😭😭😭',
            'likes': '11421',
            'hasImage': false,
          },
          {
            'avatar': null,
            'user': 'sagarchauhan3161',
            'time': '6w',
            'text': 'Bhagg tu raha hai.. fatt meri rahi hai 😂😂',
            'likes': '46457',
            'hasImage': false,
          },
          {
            'avatar': null,
            'user': 'dosbol_201401',
            'time': '15w.',
            'text': '',
            'likes': '6578',
            'hasImage': true,
          },
          {
            'avatar': null,
            'user': 'tishahhhhh',
            'time': '6w.',
            'text': 'my dreams be like😭😭😭',
            'likes': '11421',
            'hasImage': false,
          },
          {
            'avatar': null,
            'user': 'sagarchauhan3161',
            'time': '6w',
            'text': 'Bhagg tu raha hai.. fatt meri rahi hai 😂😂',
            'likes': '46457',
            'hasImage': false,
          },
          {
            'avatar': null,
            'user': 'dosbol_201401',
            'time': '15w.',
            'text': '',
            'likes': '6578',
            'hasImage': true,
          },
        ];

        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Drag handle
              Center(
                child: Container(
                  height: 4,
                  width: 72,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                'Comments',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),

              // Comments list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final c = comments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              color:
                                  isDarkMode ? Colors.white24 : Colors.black26,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Comment column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Username + time
                                Row(
                                  children: [
                                    Text(
                                      c['user'] as String,
                                      style: TextStyle(
                                        color:
                                            isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      c['time'] as String,
                                      style: TextStyle(
                                        color:
                                            isDarkMode
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // If the comment has an image/gif
                                if (c['hasImage'] as bool) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      height: 150,
                                      width: double.infinity,
                                      color:
                                          isDarkMode
                                              ? Colors.grey[800]
                                              : Colors.grey[200],
                                      child: Center(
                                        child: Text(
                                          'GIF / Image',
                                          style: TextStyle(
                                            color:
                                                isDarkMode
                                                    ? Colors.white54
                                                    : Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],

                                // Comment text (if any)
                                if ((c['text'] as String).isNotEmpty)
                                  Text(
                                    c['text'] as String,
                                    style: TextStyle(
                                      color:
                                          isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),

                                const SizedBox(height: 8),

                                // "Reply" text
                                Text(
                                  'Reply',
                                  style: TextStyle(
                                    // ✨ MODIFIED: Dynamic reply text color
                                    color:
                                        isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Like count + heart icon
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.favorite_border),
                                color: isDarkMode ? Colors.white : Colors.black,
                                iconSize: 22,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                c['likes'] as String,
                                style: TextStyle(
                                  color:
                                      isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Divider above input
              Container(
                height: 1,
                color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
              ),

              // Bottom input bar
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 8,
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom > 0
                            ? MediaQuery.of(context).viewInsets.bottom
                            : 12,
                  ),
                  child: Row(
                    children: [
                      // small user avatar
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            isDarkMode ? Colors.grey[700] : Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          color: isDarkMode ? Colors.white24 : Colors.black26,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // TextField
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? const Color(0xFF2A2A2A)
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    color:
                                        isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Add a comment',
                                    hintStyle: TextStyle(
                                      color:
                                          isDarkMode
                                              ? Colors.white60
                                              : Colors.black54,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              // Emoji button
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.emoji_emotions_outlined),
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),

                              // Gift / sticker button
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.card_giftcard_outlined),
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
