import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/assignment_item.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssignmentDetailPageS extends StatefulWidget {
  const AssignmentDetailPageS({super.key, required this.item});

  final AssignmentItem item;

  @override
  State<AssignmentDetailPageS> createState() => _AssignmentDetailPageSState();
}

class _AssignmentDetailPageSState extends State<AssignmentDetailPageS> {
  late final String _dueText;

  @override
  void initState() {
    super.initState();
    _dueText = _formatDue(widget.item);
  }

  String _formatDue(AssignmentItem item) {
    final dt = _combineDue(item);
    final dateStr = DateFormat('MMM d').format(item.dueDate);
    final timeStr = DateFormat('HH:mm').format(dt);
    return 'Due $dateStr, $timeStr';
  }

  DateTime _combineDue(AssignmentItem item) {
    final parts = item.dueTime.trim().split(' ');
    try {
      if (parts.length == 2) {
        final hm = parts[0];
        final ampm = parts[1].toUpperCase();
        final hmparts = hm.split(':');
        int h = int.parse(hmparts[0]);
        int m = int.parse(hmparts[1]);
        if (ampm == 'PM' && h != 12) h += 12;
        if (ampm == 'AM' && h == 12) h = 0;
        return DateTime(item.dueDate.year, item.dueDate.month, item.dueDate.day, h, m);
      }
    } catch (_) {}
    return DateTime(item.dueDate.year, item.dueDate.month, item.dueDate.day, 23, 59);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: '',includeBackButton: true, arrowBackColor: Colors.black, backgroundColor: AppColors.background,),
      body : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Due
              Row(
                children: [
                  SizedBox(width: screenWidth * 0.04),
                  Text(
                    _dueText,
                    style: TextWidgetStyles
                        .text14LatoMedium()
                        .copyWith(color: const Color.fromARGB(128, 0, 112, 220)),
                  ),
                ],
              ),
              // Title
              Row(
                children: [
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: TextWidgetStyles
                          .text20LatoSemibold()
                          .copyWith(color: AppColors.blue),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(thickness: 1, color: AppColors.lightblue),
              
              // Detail (description)
              Container(
                padding: EdgeInsets.only(left: screenWidth * 0.04),
                child: Text(
                  widget.item.description.isNotEmpty
                      ? widget.item.description
                      : 'No description.',
                  style: TextWidgetStyles.text14LatoMedium(),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
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