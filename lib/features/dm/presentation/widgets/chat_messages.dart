import 'package:flutter/material.dart';
import '../../models/message.dart';
import 'message_bubble.dart';
import '../../data/mock_messages.dart';

class ChatMessages extends StatefulWidget {
  final String? peerAvatar;
  const ChatMessages({super.key, this.peerAvatar});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final ScrollController _controller = ScrollController();

  late final List<Message> messages;

  @override
  void initState() {
    super.initState();
    messages = messagesFromMock;
    // rebuild the widget on scroll to update bubble gradients
    _controller.addListener(() {
      setState(() {});
    });

    // auto scroll to bottom on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // IMPORTANT: Dispose of the controller!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _controller,
      children: [
        // Profile header
        Column(
          children: [
            if (widget.peerAvatar != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(widget.peerAvatar!),
              ),
            const SizedBox(height: 15),
            Text(
              messages.firstWhere((m) => !m.isMine).senderName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              messages.firstWhere((m) => !m.isMine).senderUsername,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                elevation: 0,
              ),
              child: const Text(
                "View profile",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
        // Messages
        ...messages.map((msg) {
          final index = messages.indexOf(msg);
          final showAvatar =
              !msg.isMine &&
              (index == 0 || messages[index - 1].senderId != msg.senderId);

          return MessageBubble(message: msg, showAvatar: showAvatar);
        }),
      ],
    );
  }
}
