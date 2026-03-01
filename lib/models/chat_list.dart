class ChatRoom {
  final String roomId;
  final String otherMember;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final int lastSeqNumber;

  ChatRoom({
    required this.roomId,
    required this.otherMember,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.lastSeqNumber,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      roomId: json['room_id'] ?? '',
      otherMember: json['other_member'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
      lastSeqNumber: json['last_seq_number'] ?? 0,
    );
  }
}