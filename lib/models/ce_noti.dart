class CeWebResponse {
  final List<CeAnnounce> pin;
  final List<CeAnnounce> others;
  final List<CeAnnounce> news;

  CeWebResponse({
    required this.pin,
    required this.others,
    required this.news,
  });

  factory CeWebResponse.fromJson(Map<String, dynamic> json) {
    return CeWebResponse(
      pin: (json['Pin'] as List? ?? [])
          .map((e) => CeAnnounce.fromJson(e))
          .toList(),
  
      news: (json['New'] as List? ?? [])
          .map((e) => CeAnnounce.fromJson(e))
          .toList(),
  
      others: (json['Others'] as List? ?? [])
          .map((e) => CeAnnounce.fromJson(e))
          .toList(),
    );
  }
}

class CeAnnounce {
  final int id;
  final String topic;
  final DateTime time;
  final CeAnnounceDetail detail;

  CeAnnounce({
    required this.id,
    required this.topic,
    required this.time,
    required this.detail,
  });

  factory CeAnnounce.fromJson(Map<String, dynamic> json) {
    return CeAnnounce(
      id: json['ANNOUNCE_ID'],
      topic: json['ANNOUNCE_TOPIC'] ?? '',
      time: DateTime.parse(json['ANNOUNCE_TIME']),
      detail: CeAnnounceDetail.fromJson(json['Detail']),
    );
  }
}

class CeAnnounceDetail {
  final String data;
  final String owner;

  CeAnnounceDetail({
    required this.data,
    required this.owner,
  });

  factory CeAnnounceDetail.fromJson(Map<String, dynamic> json) {
    return CeAnnounceDetail(
      data: json['ANNOUNCE_DATA'] ?? '',
      owner: json['ANNOUNCE_OWNER'] ?? '',
    );
  }
}