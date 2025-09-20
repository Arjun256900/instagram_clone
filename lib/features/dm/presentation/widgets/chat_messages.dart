import 'package:flutter/material.dart';
import '../../models/message.dart';
import 'message_bubble.dart';
import '../../data/mock_messages.dart';

class ChatMessages extends StatefulWidget {
  final String? peerAvatar;
  final ValueChanged<Message>? onReplyRequested;

  const ChatMessages({super.key, this.peerAvatar, this.onReplyRequested});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final ScrollController _scrollController = ScrollController();

  late final List<Message> messages;

  @override
  void initState() {
    super.initState();
    messages = messagesFromMock;
    // rebuild the widget on scroll to update bubble gradients
    _scrollController.addListener(() {
      setState(() {});
    });

    // auto scroll to bottom on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // IMPORTANT: Dispose of the controller!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: [
        const SizedBox(height: 20),
        // Profile header
        Column(
          children: [
            if (widget.peerAvatar != null)
              CircleAvatar(
                radius: 50,
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

          return MessageBubble(
            message: msg,
            showAvatar: showAvatar,
            onReply: (message) {
              widget.onReplyRequested?.call(message);
            },
            prevMsgByYou:
                index > 0 ? messages[index - 1].senderId == msg.senderId : null,
          );
        }),
      ],
    );
  }
}
