import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/facultyMemberDetailPage.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

// Model class สำหรับข้อมูลอาจารย์
class FacultyMember {
  final String name_thai;
  final String name_eng;
  final String phone;
  final String room;
  final String email;
  final String imageUrl;

  FacultyMember({
    required this.name_thai,
    required this.name_eng,
    required this.phone,
    required this.room,
    required this.email,
    required this.imageUrl,
  });
}

class FacultyMemberListPage extends StatefulWidget {
  const FacultyMemberListPage({super.key});

  @override
  State<FacultyMemberListPage> createState() => _FacultyMemberListPageState();
}

class _FacultyMemberListPageState extends State<FacultyMemberListPage> {
  // ข้อมูลอาจารย์ตัวอย่าง
  final List<FacultyMember> facultyMembers = [
    FacultyMember(
      name_thai: 'ผศ. ธนา หงส์สุวรรณ',
      name_eng: 'Asst.Prof. Thana Hongsuwan',
      phone: '02-7392400 ต่อ 121',
      room: 'ECC-911',
      email: 'khthana@kmitl.ac.th, khthana@hotmail.com',
      imageUrl: '',
    ),
    FacultyMember(
      name_thai: 'ผศ. สมชาย ใจดี',
      name_eng: 'Asst.Prof. Somchai Jaidee',
      phone: '02-7392400 ต่อ 122',
      room: 'ECC-912',
      email: 'somchai@kmitl.ac.th, somchai@hotmail.com',
      imageUrl: '',
    ),
    FacultyMember(
      name_thai: 'รศ. วิชาญ เก่งมาก',
      name_eng: 'Assoc.Prof. Wichan Kengmak',
      phone: '02-7392400 ต่อ 123',
      room: 'ECC-913',
      email: 'wichan@kmitl.ac.th, wichan@hotmail.com',
      imageUrl: '',
    ),
    FacultyMember(
      name_thai: 'ผศ. สุดา ขยันมาก',
      name_eng: 'Asst.Prof. Suda Kaymanmak',
      phone: '02-7392400 ต่อ 124',
      room: 'ECC-914',
      email: 'suda@kmitl.ac.th',
      imageUrl: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Faculty Members', includeBackButton: true),
      body: Container(
        color: AppColors.background,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: facultyMembers.length,
          itemBuilder: (context, index) {
            return FacultyMemberCard(
              member: facultyMembers[index],
              onTap: () {
                // Navigate to detail page with faculty member data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacultyMemberDetailPage(
                      member: facultyMembers[index],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Widget สำหรับ Card ของแต่ละอาจารย์
class FacultyMemberCard extends StatelessWidget {
  final FacultyMember member;
  final VoidCallback onTap; // เพิ่ม callback สำหรับการคลิก

  const FacultyMemberCard({
    super.key, 
    required this.member,
    required this.onTap, // เพิ่ม parameter
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector( // ห่อด้วย GestureDetector
      onTap: onTap, // เรียกใช้ callback เมื่อคลิก
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight*0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
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
            // Header สีฟ้า
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                color: AppColors.skyblue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    member.name_thai,
                    style: TextWidgetStyles.text14NotoSansSemibold().copyWith(color: Colors.white)
                  ),
                  Text(
                    '(${member.name_eng})',
                    style: TextWidgetStyles.text14LatoSemibold().copyWith(color: Colors.white)
                  ),
                ],
              ),
            ),
            
            // เนื้อหาของ Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // รูปโปรไฟล์
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF4F8FD4),
                    child: ClipOval(
                      child: Image.asset(
                        member.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight*0.005),
                  Divider(color: Color.fromARGB(255, 168, 165, 165),),
                  SizedBox(height: screenHeight*0.005),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.025),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/images/phone_icon.png'),
                            SizedBox(width: screenWidth*0.03,),
                            Text(member.phone, style: TextWidgetStyles.text14LatoRegular(),),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                _startChat(member);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03,vertical: screenHeight*0.005),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/startChat_icon.png'),
                                    SizedBox(width: screenWidth*0.01,),
                                    Text('Start Chat', style: TextWidgetStyles.text12LatoSemibold(),)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: screenHeight*0.01,),
                        Row(
                          children: [
                            Image.asset('assets/images/location_icon.png',),
                            SizedBox(width: screenWidth*0.03,),
                            Text(member.room, style: TextWidgetStyles.text14LatoRegular(),),
                          ],
                        ),
                        SizedBox(height: screenHeight*0.01,),
                        Row(
                          children: [
                            Image.asset('assets/images/email_icon.png',),
                            SizedBox(width: screenWidth*0.03,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: member.email.split(',').map((email) {
                                return Text(
                                  email.trim(),
                                  style: TextWidgetStyles.text14LatoRegular(),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startChat(FacultyMember member) {
    // TODO: to chat page
    print('Starting chat with: ${member.name_thai}');
  }
}