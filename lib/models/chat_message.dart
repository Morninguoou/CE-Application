class ChatMessage {
  final String id;
  final String roomId;
  final String sender;
  final String content;
  final String createdAt;
  final String type;

  ChatMessage({
    required this.id,
    required this.roomId,
    required this.sender,
    required this.content,
    required this.createdAt,
    required this.type,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['message_id'] ?? '',
      roomId: json['room_id'] ?? '',
      sender: json['sender'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
      type: json['type'] ?? 'message',
    );
  }
}