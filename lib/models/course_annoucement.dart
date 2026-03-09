class AnnouncementModel {
  final String id;
  final String content;
  final String type;
  final String? title;
  final DateTime createdAt;

  AnnouncementModel({
    required this.id,
    required this.content,
    required this.type,
    this.title,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json["ID"] ?? "",
      content: json["content"] ?? "",
      type: json["Type"] ?? "",
      title: json["title"],
      createdAt: DateTime.parse(json["Creation_time"]),
    );
  }
}