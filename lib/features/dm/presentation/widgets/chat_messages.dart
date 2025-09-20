import 'package:flutter/material.dart';
import '../../models/message.dart';
import 'message_bubble.dart';

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

    // Mock data taken from the screenshot (left = other, right = mine)
    final now = DateTime.now();
    messages = [
      Message(
        id: '1',
        senderId: 'peer',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        avatarUrl: widget.peerAvatar,
        text: 'Nala irukum edhiiii',
        timestamp: now.subtract(const Duration(minutes: 60)),
        isMine: false,
      ),
      Message(
        id: '2',
        senderId: 'peer',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        avatarUrl: widget.peerAvatar,
        text: 'Oru naal vandhu paruu 😂',
        timestamp: now.subtract(const Duration(minutes: 58)),
        isMine: false,
      ),
      Message(
        id: '3',
        senderId: 'me',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        text: 'Aama 🤭',
        timestamp: now.subtract(const Duration(minutes: 55)),
        isMine: true,
      ),
      Message(
        id: '4',
        senderId: 'me',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        text: 'En clg romba small, bore adikuthu',
        timestamp: now.subtract(const Duration(minutes: 54)),
        isMine: true,
      ),
      Message(
        id: '5',
        senderId: 'peer',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        avatarUrl: widget.peerAvatar,
        text: 'Vaaa apooo',
        timestamp: now.subtract(const Duration(minutes: 50)),
        isMine: false,
      ),
      Message(
        id: '6',
        senderId: 'me',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        text: 'Culturals lam nadakuma? Appo varalam',
        timestamp: now.subtract(const Duration(minutes: 47)),
        isMine: true,
      ),
      Message(
        id: '7',
        senderId: 'peer',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        avatarUrl: widget.peerAvatar,
        text: 'Nooo boyssss😂',
        timestamp: now.subtract(const Duration(minutes: 44)),
        isMine: false,
      ),
      Message(
        id: '8',
        senderId: 'me',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        text: 'Ada aama laa 😂',
        timestamp: now.subtract(const Duration(minutes: 42)),
        isMine: true,
      ),
      Message(
        id: '9',
        senderId: 'me',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        text: 'Aprm enna koopudra 😂',
        timestamp: now.subtract(const Duration(minutes: 41)),
        isMine: true,
      ),
      Message(
        id: '10',
        senderId: 'peer',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        avatarUrl: widget.peerAvatar,
        text: 'Temple varalaam',
        timestamp: now.subtract(const Duration(minutes: 36)),
        isMine: false,
      ),
      Message(
        id: '11',
        senderId: 'me',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        text: 'Ooooh, appo oru naal leave irukumbodhu solren',
        timestamp: now.subtract(const Duration(minutes: 22)),
        isMine: true,
      ),
      Message(
        id: '12',
        senderId: 'peer',
        senderName: "✨xhi🪄",
        senderUsername: "__.mxhi._75",
        receiverName: "Arjun",
        receiverUsername: "arjuncm104",
        avatarUrl: widget.peerAvatar,
        text: 'Haaaa seriiii',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isMine: false,
      ),
    ];

    // auto scroll to bottom on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
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
