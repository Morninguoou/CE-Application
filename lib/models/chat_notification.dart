class ChatNotification {
  final String roomId;
  final String otherMemberId;
  final String titleContent;
  final String fullNameTh;

  ChatNotification({
    required this.roomId,
    required this.otherMemberId,
    required this.titleContent,
    required this.fullNameTh,
  });

  factory ChatNotification.fromJson(Map<String, dynamic> json) {
    return ChatNotification(
      roomId: json['RoomID'] ?? '',
      otherMemberId: json['OtherMemberID'] ?? '',
      titleContent: json['TitleContent'] ?? '',
      fullNameTh: json['FullNameTh'] ?? '',
    );
  }
}