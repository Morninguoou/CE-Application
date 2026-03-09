class CourseModel {
  final String courseId;
  final String name;
  final String section;
  final String room;
  final String subjectNameEn;
  final String subjectId;
  final String credit;
  final String practiceHr;
  final String theoryHr;
  final String selfLearnHr;

  CourseModel({
    required this.courseId,
    required this.name,
    required this.section,
    required this.room,
    required this.subjectNameEn,
    required this.subjectId,
    required this.credit,
    required this.practiceHr,
    required this.theoryHr,
    required this.selfLearnHr,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseId: json['Course_id'] ?? '',
      name: json['Name'] ?? '',
      section: json['Section'] ?? '',
      room: json['Room'] ?? '',
      subjectNameEn: json['Subject_name_en'] ?? '',
      subjectId: json['Subject_id'] != null && json['Subject_id'].isNotEmpty
          ? json['Subject_id'][0]
          : '',
      credit: json['Credit'].toString(),
      practiceHr: json['Practice_hr'] ?? '',
      theoryHr: json['Theory_hr'] ?? '',
      selfLearnHr: json['Self_learning_hr'] ?? '',
    );
  }
}