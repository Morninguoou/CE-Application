class Assignment {
  final String id;
  final String courseId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String description;
  final String state;
  final DateTime creationTime;
  final DateTime updateTime;
  final DateTime dueDate;
  final String dueTime;
  final num? maxPoints;
  final String workType;
  final String alternateLink;
  final String name;

  Assignment({
    required this.id,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.description,
    required this.state,
    required this.creationTime,
    required this.updateTime,
    required this.dueDate,
    required this.dueTime,
    required this.maxPoints,
    required this.workType,
    required this.alternateLink,
    required this.name,
  });

  factory Assignment.fromJson(Map<String, dynamic> j) {
    DateTime _parseDT(dynamic v) =>
        v == null ? DateTime.now() : DateTime.parse(v as String).toLocal();

    return Assignment(
      id: j['id'] ?? '',
      courseId: j['courseId'] ?? '',
      createdAt: _parseDT(j['CreatedAt']),
      updatedAt: _parseDT(j['UpdatedAt']),
      title: j['title'] ?? '',
      description: j['description'] ?? '',
      state: j['state'] ?? '',
      creationTime: _parseDT(j['creationTime']),
      updateTime: _parseDT(j['updateTime']),
      dueDate: _parseDT(j['dueDate']),
      dueTime: j['dueTime'] ?? '',
      maxPoints: j['maxPoints'],
      workType: j['workType'] ?? '',
      alternateLink: j['alternateLink'] ?? '',
      name: j['name'] ?? '',
    );
  }
}