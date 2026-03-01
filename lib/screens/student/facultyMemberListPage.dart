import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/facultyMemberDetailPage.dart';
import 'package:ce_connect_app/screens/student/chatPage.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

import 'package:ce_connect_app/service/faculty_member_api.dart';
import 'package:ce_connect_app/models/faculty_member.dart';

class FacultyMemberListPageS extends StatefulWidget {
  const FacultyMemberListPageS({super.key});

  @override
  State<FacultyMemberListPageS> createState() => _FacultyMemberListPageSState();
}

class _FacultyMemberListPageSState extends State<FacultyMemberListPageS> {
  late final FacultyService _service;
  late Future<List<FacultyMember>> _future;
  String? _accId;

  @override
  void initState() {
    super.initState();
    _service = FacultyService();
    _future = _service.fetchMembers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.read<SessionProvider>().accId;
    final accId = '65010782';

    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
      _reload();
    }
  }

  Future<void> _reload() async {
    final f = _service.fetchMembers();
    setState(() {
      _future = f;
    });
    await f;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Faculty Members', includeBackButton: true),
      body: Container(
        color: AppColors.background,
        child: RefreshIndicator(
          onRefresh: _reload,
          child: FutureBuilder<List<FacultyMember>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    Center(
                      child: Column(
                        children: [
                          const Text('โหลดข้อมูลไม่สำเร็จ'),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _reload,
                            child: const Text('ลองใหม่'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              final facultyMembers = snapshot.data ?? [];

              if (facultyMembers.isEmpty) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 120),
                    Center(child: Text('ไม่พบข้อมูล')),
                  ],
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: facultyMembers.length,
                itemBuilder: (context, index) {
                  return FacultyMemberCard(
                    member: facultyMembers[index],
                    accId: _accId ?? '',
                    onTap: () {
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
              );
            },
          ),
        ),
      ),
    );
  }
}

class FacultyMemberCard extends StatelessWidget {
  final FacultyMember member;
  final String accId;
  final VoidCallback onTap;

  const FacultyMemberCard({
    super.key, 
    required this.member,
    required this.accId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap, 
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF4F8FD4),
                    child: ClipOval(
                      child: member.imageUrl.isNotEmpty
                          ? Image.network(
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
                            )
                          : const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPageS(
                                      otherMember: member.addId,
                                      roomId: "${accId}_${member.addId}",
                                    ),
                                  ),
                                );
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
}