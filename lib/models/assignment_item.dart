class AssignmentItem {
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
  final num maxPoints;
  final String workType;
  final String alternateLink;
  final String name;

  AssignmentItem({
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

  factory AssignmentItem.fromJson(Map<String, dynamic> j) => AssignmentItem(
    id: j['id'] as String,
    courseId: j['courseId'] as String,
    createdAt: DateTime.parse(j['CreatedAt'] as String),
    updatedAt: DateTime.parse(j['UpdatedAt'] as String),
    title: j['title'] as String,
    description: (j['description'] ?? '') as String,
    state: j['state'] as String,
    creationTime: DateTime.parse(j['creationTime'] as String),
    updateTime: DateTime.parse(j['updateTime'] as String),
    dueDate: DateTime.parse(j['dueDate'] as String),
    dueTime: (j['dueTime'] ?? '') as String,
    maxPoints: j['maxPoints'] as num,
    workType: j['workType'] as String,
    alternateLink: j['alternateLink'] as String,
    name: j['name'] as String,
  );
}