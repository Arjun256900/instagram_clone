enum MessageType { text, post, reel, image }

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String senderUsername;
  final String receiverName;
  final String receiverUsername;
  final String? avatarUrl;
  final String? text;
  final DateTime timestamp;
  final bool isMine;
  final MessageType type;
  final Map<String, int>? reactions; // emoji, count (can be dynamic)
  final Map<String, dynamic>? attachment; // for post/reel metadata later TODO
  final Message? replyingTo;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderUsername,
    required this.receiverName,
    required this.receiverUsername,
    this.avatarUrl,
    this.text,
    required this.timestamp,
    required this.isMine,
    this.type = MessageType.text,
    this.reactions,
    this.attachment,
    this.replyingTo,
  });
}
