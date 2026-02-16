class HomeCalendarItem {
  final String subjectId;
  final String subjectTName;
  final String subjectEName;
  final int section;
  final int teachDay;
  final String teachTime;
  final String roomNo;
  final String buildingNo;

  HomeCalendarItem({
    required this.subjectId,
    required this.subjectTName,
    required this.subjectEName,
    required this.section,
    required this.teachDay,
    required this.teachTime,
    required this.roomNo,
    required this.buildingNo,
  });

  factory HomeCalendarItem.fromJson(Map<String, dynamic> json) {
    return HomeCalendarItem(
      subjectId: json['subject_id'],
      subjectTName: json['subject_tname'],
      subjectEName: json['subject_ename'],
      section: json['section'],
      teachDay: json['teach_day'],
      teachTime: json['teach_time'],
      roomNo: json['room_no'],
      buildingNo: json['building_no'],
    );
  }
}