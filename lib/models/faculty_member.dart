import 'package:ce_connect_app/service/faculty_member_api.dart';

class FacultyMember {
  final String name_thai;
  final String name_eng;
  final String phone; // จาก tel_office
  final String room;  // จาก roomNumber
  final String email; // จาก email
  final String imageUrl; // ยังไม่ใช้ pathImage -> ใส่เป็น '' ไปก่อน

  FacultyMember({
    required this.name_thai,
    required this.name_eng,
    required this.phone,
    required this.room,
    required this.email,
    required this.imageUrl,
  });

  factory FacultyMember.fromJson(Map<String, dynamic> json) {
    final String? pathImage = json['pathImage'];
    return FacultyMember(
      name_thai: (json['fullname_th'] ?? '').toString(),
      name_eng: (json['fullname_en'] ?? '').toString(),
      phone: (json['tel_office'] ?? '').toString(),
      room: (json['roomNumber'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      imageUrl: (pathImage != null && pathImage.isNotEmpty)
        ? 'https://www.ce.kmitl.ac.th/api/$pathImage'
        : '',
    );
  }
}