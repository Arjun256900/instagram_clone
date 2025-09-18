import 'package:flutter/material.dart';
import 'package:instagram/features/dm/models/chat_list_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/features/dm/presentation/widgets/chat_messages.dart';

class ChatScreen extends StatefulWidget {
  final ChatListItem? chatListItem;
  const ChatScreen({super.key, this.chatListItem});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.chatListItem!.avatarUrl),
            ),
            const SizedBox(width: 15),
            // Name and username (if exists) Groups and Channels don't have an username
            // Expanded to prevent overflow to the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chatListItem!.name,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 15.8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.chatListItem!.username != null)
                    Text(
                      widget.chatListItem!.username!,
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.phone, size: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.video, size: 22),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Expanded(
                child: ChatMessages(
                  peerAvatar:
                      "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800&q=80",
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  //  Expanded widget contains the text field and its internal icons
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          // Camera Icon with GestureDetector
                          GestureDetector(
                            onTap: () {
                              // Camera action
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                color: Colors.pinkAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // The actual text input field
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              decoration: const InputDecoration(
                                hintText: "Write a message...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          // Microphone Icon
                          GestureDetector(
                            onTap: () {
                              // Microphone action
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.microphone,
                                color: isDark ? Colors.white : Colors.black,
                                size: 20,
                              ),
                            ),
                          ),

                          // Gallery Icon
                          GestureDetector(
                            onTap: () {
                              // Gallery action
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.image,
                                color: isDark ? Colors.white : Colors.black,
                                size: 20,
                              ),
                            ),
                          ),

                          // Emoji Icon
                          GestureDetector(
                            onTap: () {
                              // Emoji action
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.faceSmile,
                                color: isDark ? Colors.white : Colors.black,
                                size: 20,
                              ),
                            ),
                          ),

                          // Plus Icon
                          GestureDetector(
                            onTap: () {
                              // Plus action
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.circlePlus,
                                color: isDark ? Colors.white : Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
