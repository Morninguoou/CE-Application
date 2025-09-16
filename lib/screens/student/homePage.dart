import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class HomePageS extends StatefulWidget {
  const HomePageS({super.key});

  @override
  State<HomePageS> createState() => _HomePageSState();
}

class _HomePageSState extends State<HomePageS> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2.57,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.skyblue,
                  AppColors.lightblue
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Positioned(
            top: -screenHeight * 0.02,
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
          SafeArea(
            child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.asset(
                        'assets/images/ce_icon.png',
                        width: 29,
                        height: 29,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.asset(
                        'assets/images/chat_icon.png',
                        width: 29,
                        height: 29,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.007,
                ),
                Row(
                  children: [
                    Text(
                      'Today’s Plan',
                      style: TextWidgetStyles.text20LatoBold()
                          .copyWith(color: AppColors.background),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.007,
                ),
                //todo: Calendar
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.012),
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/calendar_icon.png',
                            width: 22,
                            height: 22,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: screenWidth * 0.01,
                      ),
                      Column(
                        children: [
                          Text(
                            'Jan 2025',
                            style: TextWidgetStyles.text16LatoBold().copyWith(
                              color: AppColors.blue,
                            ),
                          ),
                          Text(
                            '16',
                            style: TextWidgetStyles.text48LatoSemibold()
                                .copyWith(color: AppColors.blue, height: 1.0),
                          ),
                          SizedBox(height: screenHeight * 0.005,),
                          Text(
                            'Thu',
                            style: TextWidgetStyles.text20LatoBold()
                                .copyWith(color: AppColors.blue, height: 1.0),
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.1),
                      Expanded(
                        child: SizedBox(
                          height: screenHeight * 0.2,
                          child: ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    bottom: screenHeight * 0.005),
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.025,
                                    vertical: screenHeight * 0.005),
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'UX & UI Thu. 2/67 [CE]',
                                      style: TextWidgetStyles.text14LatoBold()
                                          .copyWith(
                                              color: AppColors.background),
                                    ),
                                    Text(
                                      'ECC- 810',
                                      style: TextWidgetStyles.text10LatoMedium()
                                          .copyWith(
                                              color: AppColors.background,
                                              height: 1.0),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    Text(
                                      '13:00-15:00',
                                      style: TextWidgetStyles.text12LatoMedium()
                                          .copyWith(
                                              color: AppColors.background),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03,),
                //todo: announcements topic
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/bell_icon.png',
                      width: 25,
                      height: 25,
                    ),
                    SizedBox(
                      width: screenWidth * 0.013,
                    ),
                    Text(
                      'Announcements',
                      style: TextWidgetStyles.text20LatoSemibold()
                          .copyWith(color: AppColors.textBlue),
                    ),
                    const Spacer(),
                    Text(
                      'view all',
                      style: TextWidgetStyles.text16LatoRegular()
                          .copyWith(color: AppColors.textBlue),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.007,),
                //todo: announcements list
                SizedBox(
                  height: screenHeight * 0.16,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    itemBuilder: (context, index) {
                      return Container(
                        width: screenWidth * 0.45,
                        margin: EdgeInsets.only(right: screenWidth * 0.02,bottom: screenHeight * 0.01),
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.campaign_outlined,color: Colors.blue,size: 30,),
                                SizedBox(width: screenWidth * 0.01),
                                Text(
                                  'Thana H.',
                                  style: TextWidgetStyles.text16LatoMedium().copyWith(color: AppColors.textDarkblue),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'OOP',
                              style: TextWidgetStyles.text12LatoMedium().copyWith(color: AppColors.skyblue,),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'วันจันทร์ที่ 12 กุมภาพันธ์งดสอนนะครับ',
                              style: TextWidgetStyles.text14NotoSansRegular().copyWith(
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.001,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/file_icon.png',
                      width: 17,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    Text(
                      'This week assignments',
                      style: TextWidgetStyles.text20LatoSemibold()
                          .copyWith(color: AppColors.textBlue),
                    ),
                    const Spacer(),
                    Text(
                      'view all',
                      style: TextWidgetStyles.text16LatoRegular()
                          .copyWith(color: AppColors.textBlue),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.007,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.02,
                        vertical: screenHeight * 0.02),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 5,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'USER EXPERIENCE AND  USER INTERFACE DESIGN',
                                      style: TextWidgetStyles.text10LatoBold().copyWith(color: AppColors.lightblue,),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      'Due 12 Feb 2025, 11:59 PM',
                                      style: TextWidgetStyles.text12LatoBold().copyWith(color: AppColors.skyblue,),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02,
                                      vertical: screenHeight * 0.005),
                                  decoration: BoxDecoration(
                                    color: AppColors.yellow,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'more',
                                    style: TextWidgetStyles.text12LatoBold().copyWith(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Divider(
                              color: Color.fromARGB(255, 239, 239, 239),
                              thickness: 1,
                            ),
                            SizedBox(
                              height: screenHeight * 0.004,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        homeActive: true,
        onHomeTap: () {},
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
