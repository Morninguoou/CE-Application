import 'package:ce_connect_app/screens/createPinPage.dart';
import 'package:ce_connect_app/screens/loginPage.dart';
import 'package:ce_connect_app/screens/pinPage.dart';
import 'package:ce_connect_app/utils/session_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("ENV LOADED SUCCESS");
  } catch (e) {
    print("ENV LOAD ERROR: $e");
  }

  final session = SessionProvider();

  try {
    await session.load();
    print("SESSION LOADED");
  } catch (e) {
    print("SESSION LOAD ERROR: $e");
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AppStartPage(),
    );
  }
}

class AppStartPage extends StatelessWidget {
  const AppStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();
  
    print("isLoading: ${session.isLoading}");
    print("isLoggedIn: ${session.isLoggedIn}");
    print("email: ${session.email}");
    print("role: ${session.role}");

    if (session.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!session.isLoggedIn) {
      return const LoginPage();
    }

    if (session.accId == null ||
        session.email == null ||
        session.role == null) {
      return const LoginPage();
    }

    if (!session.hasPin) {
      return CreatePinPage(
        userEmail: session.email ?? "",
        userRole: session.role ?? "",
      );
    }

    return PinPage(
      userEmail: session.email ?? "",
      userRole: session.role ?? "",
    );
  }
}