class SubjectModel {
  final String subjectId;
  final String nameTh;
  final String nameEn;
  final int credit;
  final String theoryHr;
  final String practiceHr;
  final String selfLearningHr;
  final String prerequisiteTh;
  final String prerequisiteEn;
  final List<String>? teacherNameTh;
  final List<String>? teacherNameEn;
  final String descriptionTh;
  final String descriptionEn;
  final String platform;

  SubjectModel({
    required this.subjectId,
    required this.nameTh,
    required this.nameEn,
    required this.credit,
    required this.theoryHr,
    required this.practiceHr,
    required this.selfLearningHr,
    required this.prerequisiteTh,
    required this.prerequisiteEn,
    this.teacherNameTh,
    this.teacherNameEn,
    required this.descriptionTh,
    required this.descriptionEn,
    required this.platform,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['subjectId'],
      nameTh: json['name_th'],
      nameEn: json['name_en'],
      credit: json['credit'],
      theoryHr: json['theoryHr'],
      practiceHr: json['practiceHr'],
      selfLearningHr: json['selfLearningHr'],
      prerequisiteTh: json['prerequisite_th'],
      prerequisiteEn: json['prerequisite_en'],

      teacherNameTh: json['teacher_name_th'] != null
          ? List<String>.from(json['teacher_name_th'])
          : null,

      teacherNameEn: json['teacher_name_en'] != null
          ? List<String>.from(json['teacher_name_en'])
         : null,

      descriptionTh: json['description_th'],
      descriptionEn: json['description_en'],
      platform: json['platform'] ?? '',
    );
  }
}