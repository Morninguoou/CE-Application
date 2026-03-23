import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/profile_student.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/teacher/facultyMemberListPage.dart';
import 'package:ce_connect_app/screens/teacher/homePage.dart';
import 'package:ce_connect_app/screens/teacher/subjectListPage.dart';
import 'package:ce_connect_app/service/profile_student_api.dart';
import 'package:ce_connect_app/utils/session_provider.dart';
import 'package:ce_connect_app/widgets/bottomNavBarT.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfilePageT extends StatefulWidget {
  const ProfilePageT({super.key});

  @override
  State<ProfilePageT> createState() => _ProfilePageTState();
}

class _ProfilePageTState extends State<ProfilePageT> {
  final _service = ProfileDetailService();
  Future<ProfileDetail>? _future;
  String? _lastAccId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final accId = context.watch<SessionProvider>().accId;
    // final accId = 'Thana'; // For test API
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
    
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: (_future == null)
        ? const Center(child: CircularProgressIndicator())
        :FutureBuilder<ProfileDetail>(
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
                          // Text(
                          //   '${snapshot.error}',
                          //   textAlign: TextAlign.center,
                          //   style: TextWidgetStyles.text12LatoMedium(),
                          // ),
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
        
                return Stack(
                children: [
                  // Blue gradient background (top section)
                  Container(
                    height: screenHeight / 3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.skyblue,
                          AppColors.lightblue
                        ],
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
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                        ),
                      ),
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
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.12,
                          ),
                          child: Row(
                            children: [
                              pathImage.isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        'https://www.ce.kmitl.ac.th/api/$pathImage',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage: avatarProvider,
                                    ),

                              SizedBox(width: 20),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nameEn,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextWidgetStyles.text20LatoBold().copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Computer Engineer',
                                      style: TextWidgetStyles.text14LatoMedium().copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ),
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
                                   GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const FacultyMemberListPageT()));
                                      },
                                     child: Container(
                                      width: screenWidth * 0.44,
                                      height: screenHeight * 0.125,
                                      padding: EdgeInsets.only(
                                        top: screenHeight * 0.01,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.skyblue,
                                            Color.fromARGB(255, 226, 241, 248)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: screenWidth * 0.03,
                                            child: Text(
                                              'Faculty Member',
                                              style: TextWidgetStyles.text12LatoBold().copyWith(
                                                color: Colors.white,
                                              ),
                                            )
                                          ),
                                          Positioned(
                                            top: screenHeight * 0.025,
                                            left: screenWidth * 0.12,
                                            child: Image.asset(
                                              'assets/images/facultyMember_icon1.png',
                                              scale: 0.85,
                                            ),
                                          ),
                                          Positioned(
                                            top: screenHeight * 0.02,
                                            right: screenWidth * 0.06,
                                            child: Image.asset(
                                              'assets/images/facultyMember_icon2.png',
                                              scale: 0.8,
                                            ),
                                          ),
                                        ],
                                      )
                                                                       ),
                                   ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectListPageT()));
                                    },
                                    child: Container(
                                      width: screenWidth * 0.44,
                                      height: screenHeight * 0.125,
                                      padding: EdgeInsets.only(
                                        top: screenHeight * 0.01,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.yellow,
                                            AppColors.lightyellow
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: screenWidth * 0.03,
                                            child: Text(
                                              'My subject',
                                              style: TextWidgetStyles.text12LatoBold().copyWith(
                                                color: Colors.white,
                                              ),
                                            )
                                          ),
                                          Positioned(
                                            top: screenHeight * 0.025,
                                            left: screenWidth * 0.1,
                                            child: Image.asset(
                                              'assets/images/mySubject_icon1.png',
                                              scale: 0.9,
                                            ),
                                          ),
                                          Positioned(
                                            top: screenHeight * 0.01,
                                            right: screenWidth * 0.03,
                                            child: Image.asset(
                                              'assets/images/mySubject_icon2.png',
                                              scale: 0.7,
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.02),
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
                                        SizedBox(width: 10),
                                        Text('Profile', style: TextWidgetStyles.text14LatoExtrabold().copyWith(color: AppColors.yellow)),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    Text('Name (EN)', style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue)),
                                    Text(nameEn, style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.textDarkblue)),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text('Name (TH)', style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue)),
                                    Text(nameTh, style: TextWidgetStyles.text12NotoSansMedium().copyWith(color: AppColors.textDarkblue)),
                                    SizedBox(height: screenHeight * 0.01),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
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
                                        SizedBox(width: 10),
                                        Text('Organization', style: TextWidgetStyles.text14LatoExtrabold().copyWith(color: AppColors.yellow)),
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
                                              Text(
                                                'User Type',
                                                style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Teacher',
                                                style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.textDarkblue),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Text('Email', style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue)),
                                    Text(email, style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.textDarkblue)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );        
            },
          ),
      bottomNavigationBar: CustomBottomNavBarT(
        profileActive: true,
        onHomeTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageT()));
        },
        onGptTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CeGptPage()));
        },
        onProfileTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePageT()));
        },
      ),
    );
  }
}