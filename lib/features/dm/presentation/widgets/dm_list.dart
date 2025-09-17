import 'package:flutter/material.dart';
import 'package:instagram/features/dm/presentation/screens/chat_screen.dart';
import '../../models/chat_list_item.dart';

class DmList extends StatelessWidget {
  DmList({super.key});

  final List<ChatListItem> chats = [
    ChatListItem(
      name: "Namastejuli ka Parivar ❤️",
      avatarUrl:
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&q=80",
      lastMessage: "hey bro, check this out",
      timeAgo: "25m",
      unseen: 2,
      showCamera: false,
    ),
    ChatListItem(
      name: "IELTS Lesson 👩‍🏫",
      avatarUrl:
          "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800&q=80",
      lastMessage: "uploaded new exercise",
      timeAgo: "39m",
      unseen: 2,
      showCamera: false,
    ),
    ChatListItem(
      name: "Lindane",
      avatarUrl:
          "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=800&q=80",
      lastMessage: "Sent a reel by shrutzgupt...",
      timeAgo: "54m",
      unseen: 2,
      showCamera: true,
    ),
    ChatListItem(
      name: "OursColorfully Main Channel",
      avatarUrl:
          "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800&q=80",
      lastMessage: "New episode uploaded",
      timeAgo: "1h",
      unseen: 2,
      showCamera: false,
    ),
    ChatListItem(
      name: "Unsuccessful abortions.",
      avatarUrl:
          "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?w=800&q=80",
      lastMessage: "Sent a reel by crypto_tra...",
      timeAgo: "1h",
      unseen: 0,
      showCamera: true,
    ),
    ChatListItem(
      name: "Subba jully",
      avatarUrl:
          "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800&q=80",
      lastMessage: "Sent a reel by shrutzgupt...",
      timeAgo: "3h",
      unseen: 0,
      showCamera: true,
    ),
    ChatListItem(
      name: "Namastejuli ka Parivar ❤️",
      avatarUrl:
          "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&q=80",
      lastMessage: "hey bro, check this out",
      timeAgo: "25m",
      unseen: 2,
      showCamera: false,
    ),
    ChatListItem(
      name: "IELTS Lesson 👩‍🏫",
      avatarUrl:
          "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800&q=80",
      lastMessage: "uploaded new exercise",
      timeAgo: "39m",
      unseen: 2,
      showCamera: false,
    ),
    ChatListItem(
      name: "Lindane",
      avatarUrl:
          "https://images.unsplash.com/photo-1547425260-76bcadfb4f2c?w=800&q=80",
      lastMessage: "Sent a reel by shrutzgupt...",
      timeAgo: "54m",
      unseen: 2,
      showCamera: true,
    ),
    ChatListItem(
      name: "OursColorfully Main Channel",
      avatarUrl:
          "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800&q=80",
      lastMessage: "New episode uploaded",
      timeAgo: "1h",
      unseen: 2,
      showCamera: false,
    ),
    ChatListItem(
      name: "Unsuccessful abortions.",
      avatarUrl:
          "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?w=800&q=80",
      lastMessage: "Sent a reel by crypto_tra...",
      timeAgo: "1h",
      unseen: 0,
      showCamera: true,
    ),
    ChatListItem(
      name: "Subba jully",
      avatarUrl:
          "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800&q=80",
      lastMessage: "Sent a reel by shrutzgupt...",
      timeAgo: "3h",
      unseen: 0,
      showCamera: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Messages",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Requests",
                  style: TextStyle(
                    color: Color(0xFF6EA8FF),
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          // Expanded to give ListView a fixed height, othersise this WILL overflow.
          Expanded(
            child: ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final chat = chats[index];

                // If unseen > 0, show "[n] new messages" otherwise show lastMessage
                final messageLine =
                    chat.unseen > 0
                        ? "${chat.unseen} new messages"
                        : chat.lastMessage;

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(name: chat.name),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 76,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Profile pic + name and message details
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 29,
                              backgroundImage: NetworkImage(chat.avatarUrl),
                            ),
                            const SizedBox(width: 12),
                            // Name and message details
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                Text(
                                  chat.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15.5,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // message details + time ago
                                Row(
                                  children: [
                                    Text(
                                      messageLine,
                                      style: TextStyle(
                                        color:
                                            isDark
                                                ? Colors.white
                                                : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "· ${chat.timeAgo}",
                                      style: TextStyle(
                                        color:
                                            isDark
                                                ? Colors.white
                                                : Colors.black,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // trailing: camera and new message indicator
                        Row(
                          children: [
                            // Blue dot if unseen > 0
                            chat.unseen > 0
                                ? Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2EA3FF),
                                    shape: BoxShape.circle,
                                  ),
                                )
                                : const SizedBox(width: 10, height: 10),
                            if (chat.showCamera) SizedBox(width: 10),
                            if (chat.showCamera)
                              const Icon(
                                Icons.camera_alt_outlined,
                                size: 20,
                                color: Color(0xFFBFC6CE),
                              )
                            else
                              const SizedBox(height: 20),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
