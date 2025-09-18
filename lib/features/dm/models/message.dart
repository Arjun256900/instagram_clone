enum MessageType { text, post, reel, image }

class Message {
  final String id;
  final String senderId;
  final String? senderName;
  final String? avatarUrl;
  final String? text;
  final DateTime timestamp;
  final bool isMine;
  final MessageType type;
  final Map<String, int>? reactions; // emoji, count (can be dynamic)
  final Map<String, dynamic>? attachment; // for post/reel metadata later TODO

  Message({
    required this.id,
    required this.senderId,
    this.senderName,
    this.avatarUrl,
    this.text,
    required this.timestamp,
    required this.isMine,
    this.type = MessageType.text,
    this.reactions,
    this.attachment,
  });
}
