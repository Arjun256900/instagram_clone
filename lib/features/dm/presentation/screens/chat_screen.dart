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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [ChatMessages()]),
      ),
    );
  }
}
