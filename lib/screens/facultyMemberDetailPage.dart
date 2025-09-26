import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/faculty_member.dart';
import 'package:flutter/material.dart';

class FacultyMemberDetailPage extends StatefulWidget {
  final FacultyMember member;

  const FacultyMemberDetailPage({
    super.key,
    required this.member,
  });

  @override
  State<FacultyMemberDetailPage> createState() => _FacultyMemberDetailPageState();
}

class _FacultyMemberDetailPageState extends State<FacultyMemberDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        backgroundColor: AppColors.blue,
        title: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Column(
                children: [
                  Text(
                    widget.member.name_thai,
                    style: TextWidgetStyles.text14NotoSansSemibold().copyWith(color: AppColors.background),
                  ),
                  Text(
                    '(${widget.member.name_eng})',
                    style: TextWidgetStyles.text14LatoSemibold().copyWith(color: AppColors.background),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: AppColors.background,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildContactSection(),
              _buildEducationSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.lightblue,
                  AppColors.skyblue
                ],
              ),
            ),
            child: Row(
              children: [
                Image.asset('assets/images/user_icon.png'),
                const SizedBox(width: 8),
                Text(
                  'ข้อมูลติดต่อ',
                  style: TextWidgetStyles.text16NotoSansSemibold()
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // รูปโปรไฟล์
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF4F8FD4),
                  child: ClipOval(
                    child: widget.member.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.member.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 50, color: Colors.white),
                          )
                        : const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                // ข้อมูลติดต่อ
                _buildInfoRow('ชื่อ - นามสกุล :', '${widget.member.name_thai}\n(${widget.member.name_eng})'),
                _buildInfoRow('E-Mail :', widget.member.email.replaceAll(',','\n')),
                _buildInfoRow('โทรศัพท์ที่ทำงาน :', widget.member.phone),
                _buildInfoRow('ห้องพัก :', widget.member.room),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.lightblue,
                  AppColors.skyblue
                ],
              ),
            ),
            child: Row(
              children: [
                Image.asset('assets/images/teachercap_icon.png'),
                const SizedBox(width: 8),
                Text(
                  'ประวัติการศึกษา',
                  style: TextWidgetStyles.text16NotoSansSemibold()
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Content - คุณสามารถเพิ่มข้อมูลการศึกษาจริงได้
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildInfoRow('ปริญญาตรี :', widget.member.degreeBachelor ?? 'ไม่ระบุ'),
                _buildInfoRow('ปริญญาโท :', widget.member.degreeMaster ?? 'ไม่ระบุ'),
                _buildInfoRow('ปริญญาเอก :', widget.member.degreeDoctorate ?? 'ไม่ระบุ'),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextWidgetStyles.text14NotoSansSemibold(),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextWidgetStyles.text14NotoSansRegular(),
            ),
          ),
        ],
      ),
    );
  }
}