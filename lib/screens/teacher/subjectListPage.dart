import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

class SubjectListPageT extends StatefulWidget {
  const SubjectListPageT({super.key});

  @override
  State<SubjectListPageT> createState() => _SubjectListPageTState();
}

class _SubjectListPageTState extends State<SubjectListPageT> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'My Subjects',includeBackButton: true),
      body: Container(
          padding: EdgeInsets.only(top : screenHeight*0.02, left: screenWidth * 0.04, right: screenWidth * 0.04),
          child: Column(
            children: [
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
                                Row(
                                  children: [
                                    Text('OBJECT ORIENTED PROGRAMMING',style: TextWidgetStyles.text14LatoBold()),
                                  ],
                                ),
                                SizedBox(height: screenHeight*0.025,),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 3.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: index % 2 == 0
                                          ? AppColors.lightblue
                                          : AppColors.yellow,)
                                      ),
                                      child: Text('Sec : 101',style: TextWidgetStyles.text10LatoSemibold().copyWith(color: AppColors.textDarkblue))
                                    ),
                                    SizedBox(width: screenWidth*0.01,),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 3.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: index % 2 == 0
                                          ? AppColors.lightblue
                                          : AppColors.yellow,)
                                      ),
                                      child: Text('Sec : 102',style: TextWidgetStyles.text10LatoSemibold().copyWith(color: AppColors.textDarkblue))
                                    ),
                                  ],
                                ),
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