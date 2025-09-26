class NotiItem {
  final String id;
  final String courseId;
  final DateTime creationTime;
  final DateTime updateTime;
  final String text;
  final String state;
  final String alternateLink;
  final String name;

  NotiItem({
    required this.id,
    required this.courseId,
    required this.creationTime,
    required this.updateTime,
    required this.text,
    required this.state,
    required this.alternateLink,
    required this.name,
  });

  factory NotiItem.fromJson(Map<String, dynamic> json) {
    return NotiItem(
      id: json['id'] ?? '',
      courseId: json['courseId'] ?? '',
      creationTime: DateTime.tryParse(json['creationTime'] ?? '') ?? DateTime.now(),
      updateTime: DateTime.tryParse(json['updateTime'] ?? '') ?? DateTime.now(),
      text: json['text'] ?? '',
      state: json['state'] ?? '',
      alternateLink: json['alternateLink'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class NotiSection {
  final String headerTime; //24 Sep 2025 (Today) หรือ Previously
  final List<NotiItem> detail;

  NotiSection({required this.headerTime, required this.detail});

  factory NotiSection.fromJson(Map<String, dynamic> json) {
    final List<dynamic> detailList = (json['Detail'] ?? []) as List<dynamic>;
    return NotiSection(
      headerTime: json['HeaderTime'] ?? '',
      detail: detailList.map((e) => NotiItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class NotiAnnouncementsResponse {
  final NotiSection today;
  final NotiSection yesterday;
  final NotiSection previously;

  NotiAnnouncementsResponse({
    required this.today,
    required this.yesterday,
    required this.previously,
  });

  factory NotiAnnouncementsResponse.fromJson(Map<String, dynamic> json) {
    return NotiAnnouncementsResponse(
      today: NotiSection.fromJson(json['Today'] ?? {}),
      yesterday: NotiSection.fromJson(json['Yesterday'] ?? {}),
      previously: NotiSection.fromJson(json['Previously'] ?? {}),
    );
  }
}