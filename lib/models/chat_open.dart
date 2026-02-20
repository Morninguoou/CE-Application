class ChatOpenResponse {
  final String roomId;
  final String member;
  final bool endTitleStatus;
  final String fullNameEn;

  ChatOpenResponse({
    required this.roomId,
    required this.member,
    required this.endTitleStatus,
    required this.fullNameEn,
  });

  factory ChatOpenResponse.fromJson(Map<String, dynamic> json) {
    return ChatOpenResponse(
      roomId: json['RoomID'] ?? '',
      member: json['Member'] ?? '',
      endTitleStatus: json['EndTitleStatus'] ?? false,
      fullNameEn: json['FullNameEn'] ?? '',
    );
  }
}