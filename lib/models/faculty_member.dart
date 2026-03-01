import 'package:ce_connect_app/service/faculty_member_api.dart';

class FacultyMember {
  final String addId;
  final String name_thai;
  final String name_eng;
  final String phone;
  final String room;
  final String email;
  final String imageUrl;
  final String? degreeBachelor;
  final String? degreeMaster;
  final String? degreeDoctorate;

  FacultyMember({
    required this.addId,
    required this.name_thai,
    required this.name_eng,
    required this.phone,
    required this.room,
    required this.email,
    required this.imageUrl,
    this.degreeBachelor,
    this.degreeMaster,
    this.degreeDoctorate,
  });

  factory FacultyMember.fromJson(Map<String, dynamic> json) {
    final String? pathImage = json['pathImage'];
    return FacultyMember(
      addId: (json['accId'] ?? '').toString(),
      name_thai: (json['fullname_th'] ?? '').toString(),
      name_eng: (json['fullname_en'] ?? '').toString(),
      phone: (json['tel_office'] ?? '').toString(),
      room: (json['roomNumber'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      imageUrl: (pathImage != null && pathImage.isNotEmpty)
        ? 'https://www.ce.kmitl.ac.th/api/$pathImage'
        : '',
      degreeBachelor: (json['bachelor_degree'] ?? '').toString(),
      degreeMaster: (json['master_degree'] ?? '').toString(),
      degreeDoctorate: (json['phD_degree'] ?? '').toString(),
    );
  }
}