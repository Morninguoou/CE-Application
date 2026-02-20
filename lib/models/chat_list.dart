class ChatRoom {
  final String roomId;
  final String otherMember;
  final String lastMessage;
  final String lastMessageTime;

  ChatRoom({
    required this.roomId,
    required this.otherMember,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomId: json['room_id'] ?? '',
      otherMember: json['other_member'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
    );
  }
}