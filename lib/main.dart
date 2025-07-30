import 'package:ce_connect_app/screens/loginPage.dart';
import 'package:ce_connect_app/screens/pinPage.dart';
import 'package:ce_connect_app/screens/student/assignmentDetailPage.dart';
import 'package:ce_connect_app/screens/student/assignmentPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/screens/student/subjectListPage.dart';
import 'package:ce_connect_app/screens/teacher/homePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PinPage(),
    );
  }
}

// todo : ไล่ใส่ bottom nav ตาม ui