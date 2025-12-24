import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/subject_list.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class SubjectDetailPageS extends StatefulWidget {
  final SubjectModel subject;

  const SubjectDetailPageS({
    super.key,
    required this.subject,
  });

  @override
  State<SubjectDetailPageS> createState() => _SubjectDetailPageSState();
}

class _SubjectDetailPageSState extends State<SubjectDetailPageS> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Subject Detail',includeBackButton: true),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  //TODO : Course Code and Credits
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.subject.subjectId,
                        style: TextWidgetStyles.text16LatoBold()
                            .copyWith(color: Color.fromARGB(255, 96, 96, 96)),
                      ),
                      Text(
                        '${widget.subject.credit}(${widget.subject.theoryHr}-${widget.subject.practiceHr}-${widget.subject.selfLearningHr})',
                        style: TextWidgetStyles.text16LatoBold()
                            .copyWith(color: Color.fromARGB(255, 96, 96, 96)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  // TODO : Course Name
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.subject.nameEn,
                          style: TextWidgetStyles.text14LatoBold(),
                        ),
                      )
                    ],
                  ),
                  // TODO Teacher Name
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Teacher: ${widget.subject.teacherNameEn.join(', ')}',
                          style: TextWidgetStyles.text12LatoSemibold()
                              .copyWith(color: Color.fromARGB(255, 96, 96, 96)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // TODO : Platform Section
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.skyblue, width: 2),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(
                          'Platform',
                          style: TextWidgetStyles.text12LatoSemibold()
                              .copyWith(color: AppColors.textDarkblue),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        '${widget.subject.platform}',
                        style: TextWidgetStyles.text12LatoSemibold()
                            .copyWith(color: Color.fromARGB(255, 96, 96, 96)),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  // TODO Detail Container
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Detail Header
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                                left: screenWidth * 0.04, 
                                top: screenHeight * 0.01,
                                bottom: screenHeight * 0.005),
                            decoration: BoxDecoration(
                              color: AppColors.lightyellow,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Detail',
                              style: TextWidgetStyles.text14LatoBold()
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(
                              maxHeight: screenHeight * 0.5,
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04, 
                                    vertical: screenHeight * 0.015),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextWidgetStyles.text12NotoSansRegular().copyWith(
                                      color: Colors.black,
                                      height: 1.5,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'วิชาบังคับก่อน: ',
                                        style: TextWidgetStyles.text12NotoSansSemibold().copyWith(
                                          color: Colors.black,
                                          height: 1.5,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${widget.subject.prerequisiteTh}',
                                      ),
                                      TextSpan(text: '\n'),
                                      TextSpan(
                                        text: 'PREREQUISITE : ',
                                        style: TextWidgetStyles.text12NotoSansSemibold().copyWith(
                                          color: Colors.black,
                                          height: 1.5,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${widget.subject.prerequisiteEn}',
                                      ),
                                      TextSpan(text: '\n\n'),
                                      TextSpan(
                                        text: '${widget.subject.descriptionTh}',
                                      ),
                                      TextSpan(text: '\n\n'),
                                      TextSpan(
                                        text: '${widget.subject.descriptionEn}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
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