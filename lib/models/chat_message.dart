class ChatMessage {
  final String id;
  final String roomId;
  final String sender;
  final String content;
  final String createdAt;
  final String type;
  final int? seqNumber;

  ChatMessage({
    required this.id,
    required this.roomId,
    required this.sender,
    required this.content,
    required this.createdAt,
    required this.type,
    this.seqNumber,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: (json['message_id'] ?? '').toString(),
      roomId: (json['room_id'] ?? '').toString(),
      sender: (json['sender'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? '').toString(),
      type: (json['type'] ?? 'message').toString(),
      seqNumber: json['seq_number'],
    );
  }
}