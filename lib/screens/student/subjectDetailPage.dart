import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

class SubjectDetailPageS extends StatefulWidget {
  const SubjectDetailPageS({super.key});

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
              Container(
                width: screenWidth * 0.6,
                child: Text(
                  'USER EXPERIENCE AND USER INTERFACE DESIGN',
                  style: TextWidgetStyles.text14LatoBold().copyWith(color: AppColors.background),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.blue
            ),
          ),
          Positioned(
            top: screenHeight * 0.05,
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
                  //TODO : Profile Pic Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.blue, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 37,
                          backgroundImage: AssetImage('assets/images/mocprofile_pic.png'),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // TODO Teacher Name
                  Row(
                    children: [
                      Text(
                        'ผศ. ธนา หงษ์สุวรรณ',
                        style: TextWidgetStyles.text20NotoSansSemibold()
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                  // TODO : Education Label
                  Row(
                    children: [
                      Text(
                        'Education',
                        style: TextWidgetStyles.text12LatoSemibold()
                            .copyWith(color: Color.fromARGB(255, 96, 96, 96)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
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
                        'Google Classroom',
                        style: TextWidgetStyles.text12LatoSemibold()
                            .copyWith(color: Color.fromARGB(255, 96, 96, 96)),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  //TODO : Course Code and Credits
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '01076036',
                        style: TextWidgetStyles.text14LatoBold()
                            .copyWith(color: Color.fromARGB(255, 96, 96, 96)),
                      ),
                      Text(
                        '2(2-0-4)',
                        style: TextWidgetStyles.text14LatoBold()
                            .copyWith(color: Color.fromARGB(255, 96, 96, 96)),
                      ),
                    ],
                  ),
                  // TODO : Course Name
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'USER EXPERIENCE AND USER INTERFACE DESIGN',
                          style: TextWidgetStyles.text14LatoBold(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  // TODO Detail Container
                  Container(
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
                                      text: '01076105 การเขียนโปรแกรมเชิงวัตถุ',
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
                                      text: '01076105 OBJECT ORIENTED PROGRAMMING',
                                    ),
                                    TextSpan(text: '\n\n'),
                                    TextSpan(
                                      text: 'วิชานี้แนะนำขั้นตอนของการออกแบบประสบการณ์และการออกแบบส่วนติดต่อผู้ใช้งาน โดยจะมีจุดมุ่งหมายให้นักศึกษาได้คุ้นเคยกับแนวคิด วิธีปฏิบัติ และเทคนิคที่จำเป็นในการสร้างประสบการณ์ของผู้ใช้งาน ซึ่งเป็นส่วนหนึ่งของการพัฒนาการเชื่อมโยงข่าวสาร วิชานี้จะให้นักศึกษาได้มีโอกาสในการค้นหาทรัพยากร พัฒนาทักษะ และฝึกปฏิบัติที่จำเป็นต่อการออกแบบ พัฒนา และประเมินส่วนติดต่อข้อมูลจากมุมมองของผู้ใช้งาน  ',
                                    ),
                                    TextSpan(text: '\n\n'),
                                    TextSpan(
                                      text: 'This course provides a comprehensive overview of the user experience and user interface design process, and is intended to familiarize students with the methods, concepts, and techniques necessary to make user experience design an integral part of developing information interfaces. The course provides students with an opportunity to acquire the resources, skills, and hands -on experience they need to design, develop, and evaluate information interfaces from a user -centered design perspective.',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}