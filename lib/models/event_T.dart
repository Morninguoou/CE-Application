class ApiEventT {
  final String id;
  final String name;
  final String location;
  final DateTime start;
  final DateTime end;
  final bool isAllDay;

  ApiEventT({
    required this.id,
    required this.name,
    required this.location,
    required this.start,
    required this.end,
    required this.isAllDay,
  });

  factory ApiEventT.fromJson(Map<String, dynamic> json) {
    return ApiEventT(
      id: json['event_id'],
      name: json['name'],
      location: json['location'] ?? '',
      start: DateTime.parse(json['start_date_time']),
      end: DateTime.parse(json['end_date_time']),
      isAllDay: json['all_day_checked'] ?? false,
    );
  }
}