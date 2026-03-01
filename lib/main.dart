import 'package:ce_connect_app/screens/student/chatListPage.dart';
import 'package:ce_connect_app/screens/confirmPinPage.dart';
import 'package:ce_connect_app/screens/createPinPage.dart';
import 'package:ce_connect_app/screens/student/facultyMemberListPage.dart';
import 'package:ce_connect_app/screens/loginPage.dart';
import 'package:ce_connect_app/screens/pinPage.dart';
import 'package:ce_connect_app/screens/student/assignmentDetailPage.dart';
import 'package:ce_connect_app/screens/student/assignmentPage.dart';
import 'package:ce_connect_app/screens/student/chatPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/screens/student/subjectDetailPage.dart';
import 'package:ce_connect_app/screens/student/subjectListPage.dart';
import 'package:ce_connect_app/screens/teacher/annoucementListPage.dart';
import 'package:ce_connect_app/screens/teacher/calendarPage.dart';
import 'package:ce_connect_app/screens/teacher/chatListPage.dart';
import 'package:ce_connect_app/screens/teacher/facultyMemberListPage.dart';
import 'package:ce_connect_app/screens/teacher/homePage.dart';
import 'package:ce_connect_app/utils/session_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = SessionProvider();
  await session.load();

  const kDebugAccId = '65010782';
  if (!session.isLoggedIn) {
    await session.setAccId(kDebugAccId);
  }

  runApp(
    ChangeNotifierProvider.value(
      value: session,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePageT(),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final session = SessionProvider();
//   await session.load();

//   runApp(
//     ChangeNotifierProvider.value(
//       value: session,
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomePageS(),
//     );
//   }
// }

// todo : ไล่ใส่ bottom nav ตาม ui