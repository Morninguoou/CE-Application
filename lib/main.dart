import 'package:ce_connect_app/screens/createPinPage.dart';
import 'package:ce_connect_app/screens/loginPage.dart';
import 'package:ce_connect_app/screens/pinPage.dart';
import 'package:ce_connect_app/utils/session_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final session = SessionProvider();
  await session.load();

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
      home: AppStartPage(),

      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => const AppStartPage(),
        );
      },      
    );
  }
}

class AppStartPage extends StatelessWidget {
  const AppStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionProvider>();

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
        userEmail: session.email!,
        userRole: session.role!,
      );
    }
    
    return PinPage(
      userEmail: session.email!,
      userRole: session.role!,
    );
  }
}