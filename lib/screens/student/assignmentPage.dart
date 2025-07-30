import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

class AssignmentPageS extends StatefulWidget {
  const AssignmentPageS({super.key});

  @override
  State<AssignmentPageS> createState() => _AssignmentPageSState();
}

class _AssignmentPageSState extends State<AssignmentPageS> {

  final List<Map<String, String>> assignments = [
    {
      'title': 'Snowflake game - งานเดี่ยว(4คะแนน)',
      'due': 'Due Mar 6, 23:59',
      'class': 'UX & UI Thu. 2/67 [CE]',
      'platform': 'Google classroom',
    },
    {
      'title': 'Project Improvement - งานเดี่ยว',
      'due': 'Due Feb 20, 23:59',
      'class': 'UX & UI Thu. 2/67 [CE]',
      'platform': 'Google classroom',
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Assignments',includeBackButton: true),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.06,vertical: screenHeight*0.04),
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final item = assignments[index];
          return Container(
            margin: EdgeInsets.only(bottom: screenHeight*0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: screenWidth*0.03,vertical: screenHeight*0.01),
              leading: CircleAvatar(
                backgroundColor: AppColors.lightyellow,
                radius: 30,
                child: Image.asset('assets/images/assignment_icon.png'),
              ),
              title: Text(
                item['title']!,
                style: TextWidgetStyles.text14NotoSansSemibold(),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['due']!,style: TextWidgetStyles.text12LatoMedium(),),
                  Text(item['class']!,style: TextWidgetStyles.text12LatoMedium(),),
                  Text(item['platform']!,style: TextWidgetStyles.text12LatoMedium(),),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}