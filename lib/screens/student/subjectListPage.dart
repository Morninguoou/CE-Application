import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

class SubjectListPageS extends StatefulWidget {
  const SubjectListPageS({super.key});

  @override
  State<SubjectListPageS> createState() => _SubjectListPageSState();
}

class _SubjectListPageSState extends State<SubjectListPageS> {
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'This Semester Subjects',includeBackButton: true),
      body: Container(
          padding: EdgeInsets.only(top : screenHeight*0.02, left: screenWidth * 0.04, right: screenWidth * 0.04),
          child: Column(
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/book_icon.png',
                  width: 25,
                  height: 25,
                ),
                SizedBox(
                  width: screenWidth * 0.013,
                ),
                Text(
                  'Total Credits',
                  style: TextWidgetStyles.text20LatoSemibold()
                      .copyWith(color: AppColors.textBlue),
                ),
                const Spacer(),
                Text(
                  '17',
                  style: TextWidgetStyles.text20LatoSemibold()
                      .copyWith(color: AppColors.red),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.only(top: screenHeight * 0.018),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.008,
                            horizontal: screenWidth * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: index % 2 == 0
                                ? AppColors.skyblue
                                : AppColors.yellow,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                            children: [
                              Text('01076105',
                                  style: TextWidgetStyles.text16LatoBold()
                                      .copyWith(color: Colors.white)),
                              Text('3(3-0-6)',
                                  style: TextWidgetStyles.text16LatoBold()
                                      .copyWith(color: Colors.white)),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                            horizontal: screenWidth * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('OBJECT ORIENTED PROGRAMMING',style: TextWidgetStyles.text14LatoBold()),
                              Text('Sec : 102',style: TextWidgetStyles.text10LatoSemibold().copyWith(color: AppColors.textDarkblue)),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Image.asset(
                                      'assets/images/chat_icon.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth*0.02,),
                                  Text('Thana H.')
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  );
                },
              ),
            ),
            ],
          ),
        ),
      );
  }
}