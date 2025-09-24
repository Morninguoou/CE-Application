class Announcement {
  final String name;
  final String id;
  final String courseId;
  final String text;
  final String state;
  final DateTime creationTime;
  final DateTime updateTime;
  final String alternateLink;

  Announcement({
    required this.name,
    required this.id,
    required this.courseId,
    required this.text,
    required this.state,
    required this.creationTime,
    required this.updateTime,
    required this.alternateLink,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      text: json['text'] ?? '',
      state: json['state'] ?? '',
      creationTime: DateTime.tryParse(json['creationTime'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      updateTime: DateTime.tryParse(json['updateTime'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      alternateLink: json['alternateLink'] ?? '',
    );
  }

  static List<Announcement> listFromJson(dynamic data) {
    if (data is List) {
      return data.map((e) => Announcement.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  String get firstLine => text.split('\n').first.trim();
}
