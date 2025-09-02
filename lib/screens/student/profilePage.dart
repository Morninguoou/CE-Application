import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/studyPlanPage.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class ProfilePageS extends StatefulWidget {
  const ProfilePageS({super.key});

  @override
  State<ProfilePageS> createState() => _ProfilePageSState();
}

class _ProfilePageSState extends State<ProfilePageS> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/mocprofile_pic.png'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Somchai Pakpean',
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
                          SizedBox(height: 20),
                          Text(
                            'Student ID: 65010000',
                            style: TextWidgetStyles.text14LatoMedium().copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
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
                          Container(
                            width: screenWidth * 0.285,
                            height: screenHeight * 0.125,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.darkpinkGradient,
                                  AppColors.lightpinkGradient
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
                                  left: screenWidth * 0.025,
                                  child: Image.asset(
                                    'assets/images/mySubject_icon1.png',
                                  ),
                                ),
                                Positioned(
                                  top: screenHeight * 0.02,
                                  right: screenWidth * 0.01,
                                  child: Image.asset(
                                    'assets/images/mySubject_icon2.png',
                                  ),
                                ),
                              ],
                            )
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const StudyPlanPageS()));
                            },
                            child: Container(
                              width: screenWidth * 0.285,
                              height: screenHeight * 0.125,
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.yellow,
                                    Color.fromARGB(255, 255, 232, 186)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: screenWidth * 0.03,
                                    child: Text(
                                      'Study Plan',
                                      style: TextWidgetStyles.text12LatoBold().copyWith(
                                        color: Colors.white,
                                      ),
                                    )
                                  ),
                                  Positioned(
                                    top: screenHeight * 0.025,
                                    right: screenWidth * 0.01,
                                    child: Image.asset(
                                      'assets/images/studyPlan_icon1.png',
                                    ),
                                  ),
                                  Positioned(
                                    top: screenHeight * 0.02,
                                    left: screenWidth * 0.025,
                                    child: Image.asset(
                                      'assets/images/studyPlan_icon2.png',
                                    ),
                                  ),
                                ],
                              )
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.285,
                            height: screenHeight * 0.125,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
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
                                  left: screenWidth * 0.045,
                                  child: Image.asset(
                                    'assets/images/facultyMember_icon1.png',
                                  ),
                                ),
                                Positioned(
                                  top: screenHeight * 0.02,
                                  right: screenWidth * 0.03,
                                  child: Image.asset(
                                    'assets/images/facultyMember_icon2.png',
                                  ),
                                ),
                              ],
                            )
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
                            Text('Somchai Pakpean', style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.textDarkblue)),
                            SizedBox(height: screenHeight * 0.01),
                            Text('Name (TH)', style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue)),
                            Text('สมชาย พากเพียร', style: TextWidgetStyles.text12NotoSansMedium().copyWith(color: AppColors.textDarkblue)),
                            SizedBox(height: screenHeight * 0.01),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Birthdate',
                                        style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '03 April 2000',
                                        style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.textDarkblue),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gender',
                                        style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Male',
                                        style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.textDarkblue),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
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
                                        'Student',
                                        style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.textDarkblue),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ID',
                                        style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '65010000',
                                        style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.textDarkblue),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text('Year', style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue)),
                            Text('2567', style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.textDarkblue)),
                            SizedBox(height: screenHeight * 0.01),
                            Text('Email', style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue)),
                            Text('65010000@kmitl.ac.th', style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.textDarkblue)),
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
      ),
      bottomNavigationBar: CustomBottomNavBar(
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
        onProfileTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePageS()));
        },
      ),
    );
  }
}