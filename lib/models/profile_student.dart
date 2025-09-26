class ProfileDetail {
  final String accId;
  final String fullnameTh;
  final String fullNameEn;
  final String email;
  final String role;
  final String? birthDate;
  final String gender;
  final String year;
  final String pathImage;

  ProfileDetail({
    required this.accId,
    required this.fullnameTh,
    required this.fullNameEn,
    required this.email,
    required this.role,
    required this.birthDate,
    required this.gender,
    required this.year,
    required this.pathImage,
  });

  factory ProfileDetail.fromJson(Map<String, dynamic> json) {
    return ProfileDetail(
      accId: json['accId'] ?? '',
      fullnameTh: json['fullname_th'] ?? '',
      fullNameEn: json['fullName_en'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      birthDate: json['birthDate'],
      gender: (json['gender'] ?? '').toString(),
      year: (json['year'] ?? '').toString(),
      pathImage: json['pathImage'] ?? '',
    );
  }
}