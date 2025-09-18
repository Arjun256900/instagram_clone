class ChatListItem {
  final String name;
  final String? username;
  final String chatType;
  final String avatarUrl;
  final String lastMessage;
  final String timeAgo;
  final int unseen;
  final bool showCamera;

  ChatListItem({
    required this.name,
    this.username,
    required this.chatType,
    required this.avatarUrl,
    required this.lastMessage,
    required this.timeAgo,
    this.unseen = 0,
    this.showCamera = false,
  });
}
