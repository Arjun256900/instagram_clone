class ChatListItem {
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String timeAgo;
  final int unseen;
  final bool showCamera;

  ChatListItem({
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.timeAgo,
    this.unseen = 0,
    this.showCamera = false,
  });
}
