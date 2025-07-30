import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

class AssignmentDetailPageS extends StatefulWidget {
  const AssignmentDetailPageS({super.key});

  @override
  State<AssignmentDetailPageS> createState() => _AssignmentDetailPageSState();
}

class _AssignmentDetailPageSState extends State<AssignmentDetailPageS> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: '',includeBackButton: true, arrowBackColor: Colors.black, backgroundColor: AppColors.background,),
      body : Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth*0.04),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: screenWidth*0.04,),
                Text('Due Feb 11, 23:59',style: TextWidgetStyles.text14LatoMedium().copyWith(color: Color.fromARGB(128, 0, 112, 220)),)
              ],
            ),
            Row(
              children: [
                SizedBox(width: screenWidth*0.04,),
                Text('02 Basic Router Configuration',style: TextWidgetStyles.text20LatoSemibold().copyWith(color: AppColors.blue,))
              ],
            ),
            Divider(
              thickness: 1,
              color: AppColors.lightblue,
            ),
            Container(
              child: Text('detail', style: TextWidgetStyles.text14LatoMedium(),),
            )
          ],
        ),
      ),
    );
  }
}