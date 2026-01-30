import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/faculty_member.dart';
import 'package:ce_connect_app/models/profile_student.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/facultyMemberListPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/studyPlanPage.dart';
import 'package:ce_connect_app/screens/student/subjectListPage.dart';
import 'package:ce_connect_app/service/profile_student_api.dart';
import 'package:ce_connect_app/utils/session_provider.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBarS.dart';
import 'package:flutter/material.dart';

class ProfilePageS extends StatefulWidget {
  const ProfilePageS({super.key});

  @override
  State<ProfilePageS> createState() => _ProfilePageSState();
}

class _ProfilePageSState extends State<ProfilePageS> {
  final _service = ProfileDetailService();
  Future<ProfileDetail>? _future;
  String? _lastAccId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.watch<SessionProvider>().accId;
    final accId = '65010782'; // For test API
    if (accId != null && accId.isNotEmpty && accId != _lastAccId) {
      _lastAccId = accId;
      _future = _service.fetchProfileDetail(accId: accId);
      setState(() {});
    }
  }

  String _displayOrDash(String? v) {
    final s = (v ?? '').trim();
    return s.isEmpty ? '—' : s;
  }

  @override
  Widget build(BuildContext context) {
    // final accIdInSession = context.watch<SessionProvider?>()?.accId;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: (_future == null)
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<ProfileDetail>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'โหลดข้อมูลโปรไฟล์ไม่สำเร็จ',
                            style: TextWidgetStyles.text16LatoBold().copyWith(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: TextWidgetStyles.text12LatoMedium(),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (_lastAccId != null) {
                                setState(() {
                                  _future = _service.fetchProfileDetail(accId: _lastAccId!);
                                });
                              }
                            },
                            child: const Text('ลองใหม่'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final data = snapshot.data;
                final nameEn = _displayOrDash(data?.fullNameEn ?? data?.fullNameEn);
                final nameTh = _displayOrDash(data?.fullnameTh);
                final userId = _displayOrDash(data?.accId);
                final role = _displayOrDash(data?.role);
                final year = _displayOrDash(data?.year);
                final email = _displayOrDash(data?.email);
                final gender = _displayOrDash(data?.gender);
                final pathImage = (data?.pathImage ?? '').trim();

                ImageProvider avatarProvider = const AssetImage('assets/images/mocprofile_pic.png');
                if (pathImage.isNotEmpty) {
                  avatarProvider = NetworkImage(pathImage);
                }

                return Stack(
                  children: [
                    // Blue gradient background (top section)
                    Container(
                      height: screenHeight / 3,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.skyblue, AppColors.lightblue],
                        ),
                      ),
                    ),

                    // Background pattern with opacity
                    Positioned(
                      top: -screenHeight * 0.03,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height / 2.5,
                      child: Opacity(
                        opacity: 0.3,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/mainPageBG.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenHeight / 3.5,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: const DecoratedBox(
                        decoration: BoxDecoration(color: AppColors.background),
                      ),
                    ),

                    SafeArea(
                      child: Column(
                        children: [
                          AppBar(
                            automaticallyImplyLeading: false,
                            scrolledUnderElevation: 0,
                            titleSpacing: 0,
                            backgroundColor: Colors.transparent,
                            title: SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'My Profile',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.background,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Header
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: avatarProvider,
                                ),
                                SizedBox(width: screenHeight*0.02),
                                Expanded( // เพื่อจำกัดความกว้างให้ Text ตัดคำ
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nameEn,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextWidgetStyles.text18LatoBold().copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        userId,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextWidgetStyles.text14LatoSemibold().copyWith(color: Colors.white),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        'Computer Engineering',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextWidgetStyles.text14LatoSemibold().copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ),

                          // Content
                          Container(
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.05,
                              right: screenWidth * 0.05,
                              top: screenHeight * 0.07,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // My subject
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectListPageS()));
                                      },
                                      child: Container(
                                        width: screenWidth * 0.285,
                                        height: screenHeight * 0.125,
                                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [AppColors.darkpinkGradient, AppColors.lightpinkGradient],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: screenWidth * 0.03,
                                              child: Text('My subject',
                                                  style: TextWidgetStyles.text12LatoBold().copyWith(color: Colors.white)),
                                            ),
                                            Positioned(
                                              top: screenHeight * 0.025,
                                              left: screenWidth * 0.025,
                                              child: Image.asset('assets/images/mySubject_icon1.png'),
                                            ),
                                            Positioned(
                                              top: screenHeight * 0.02,
                                              right: screenWidth * 0.01,
                                              child: Image.asset('assets/images/mySubject_icon2.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Study Plan
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const StudyPlanPageS()));
                                      },
                                      child: Container(
                                        width: screenWidth * 0.285,
                                        height: screenHeight * 0.125,
                                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [AppColors.yellow, Color.fromARGB(255, 255, 232, 186)],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: screenWidth * 0.03,
                                              child: Text('Study Plan',
                                                  style:
                                                      TextWidgetStyles.text12LatoBold().copyWith(color: Colors.white)),
                                            ),
                                            Positioned(
                                              top: screenHeight * 0.025,
                                              right: screenWidth * 0.01,
                                              child: Image.asset('assets/images/studyPlan_icon1.png'),
                                            ),
                                            Positioned(
                                              top: screenHeight * 0.02,
                                              left: screenWidth * 0.025,
                                              child: Image.asset('assets/images/studyPlan_icon2.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // Faculty Member
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FacultyMemberListPage()));
                                      },
                                      child: Container(
                                        width: screenWidth * 0.285,
                                        height: screenHeight * 0.125,
                                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [AppColors.skyblue, Color.fromARGB(255, 226, 241, 248)],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: screenWidth * 0.03,
                                              child: Text('Faculty Member',
                                                  style: TextWidgetStyles.text12LatoBold().copyWith(color: Colors.white)),
                                            ),
                                            Positioned(
                                              top: screenHeight * 0.025,
                                              left: screenWidth * 0.045,
                                              child: Image.asset('assets/images/facultyMember_icon1.png'),
                                            ),
                                            Positioned(
                                              top: screenHeight * 0.02,
                                              right: screenWidth * 0.03,
                                              child: Image.asset('assets/images/facultyMember_icon2.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: screenHeight * 0.02),

                                // Card: Profile
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                    horizontal: screenWidth * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/images/profile_icon.png', width: 20, height: 20),
                                          const SizedBox(width: 10),
                                          Text('Profile',
                                              style: TextWidgetStyles.text14LatoExtrabold()
                                                  .copyWith(color: AppColors.yellow)),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.02),

                                      Text('Name (EN)',
                                          style: TextWidgetStyles.text10LatoMedium()
                                              .copyWith(color: AppColors.lightblue)),
                                      Text(nameEn,
                                          style: TextWidgetStyles.text12LatoMedium()
                                              .copyWith(color: AppColors.textDarkblue)),
                                      SizedBox(height: screenHeight * 0.01),

                                      Text('Name (TH)',
                                          style: TextWidgetStyles.text10LatoMedium()
                                              .copyWith(color: AppColors.lightblue)),
                                      Text(nameTh,
                                          style: TextWidgetStyles.text12NotoSansMedium()
                                              .copyWith(color: AppColors.textDarkblue)),
                                      SizedBox(height: screenHeight * 0.01),
                                    ],
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.02),

                                // Card: Organization
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                    horizontal: screenWidth * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/images/organization_icon.png', width: 22, height: 22),
                                          const SizedBox(width: 10),
                                          Text('Organization',
                                              style: TextWidgetStyles.text14LatoExtrabold()
                                                  .copyWith(color: AppColors.yellow)),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.02),

                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('User Type',
                                                    style: TextWidgetStyles.text10LatoMedium()
                                                        .copyWith(color: AppColors.lightblue)),
                                                const SizedBox(height: 4),
                                                Text(role,
                                                    style: TextWidgetStyles.text12LatoMedium()
                                                        .copyWith(color: AppColors.textDarkblue)),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('ID',
                                                    style: TextWidgetStyles.text10LatoMedium()
                                                        .copyWith(color: AppColors.lightblue)),
                                                const SizedBox(height: 4),
                                                Text(userId,
                                                    style: TextWidgetStyles.text12LatoMedium()
                                                        .copyWith(color: AppColors.textDarkblue)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: screenHeight * 0.01),
                                      Text('Year',
                                          style: TextWidgetStyles.text10LatoMedium()
                                              .copyWith(color: AppColors.lightblue)),
                                      Text(year,
                                          style: TextWidgetStyles.text12LatoMedium()
                                              .copyWith(color: AppColors.textDarkblue)),

                                      SizedBox(height: screenHeight * 0.01),
                                      Text('Email',
                                          style: TextWidgetStyles.text10LatoMedium()
                                              .copyWith(color: AppColors.lightblue)),
                                      Text(email,
                                          style: TextWidgetStyles.text12LatoMedium()
                                              .copyWith(color: AppColors.textDarkblue)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
      bottomNavigationBar: CustomBottomNavBarS(
        profileActive: true,
        onHomeTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageS()));
        },
        onGptTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CeGptPage()));
        },
        onNotificationTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPageS()));
        },
        onProfileTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePageS()));
        },
      ),
    );
  }
}