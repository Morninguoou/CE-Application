import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/createPinPage.dart';
import 'package:ce_connect_app/screens/pinPage.dart';
import 'package:ce_connect_app/service/google_oauth_service.dart';
import 'package:ce_connect_app/service/pin_api.dart';
import 'package:ce_connect_app/utils/session_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _pinService = PinService();

  bool _isPasswordVisible = false;
  bool _loading = false;

  late AppLinks _appLinks;
  StreamSubscription? _sub;
  bool _handled = false;

  final baseUrl = dotenv.get('API_URL');

  @override
  void initState() {
    super.initState();

    _appLinks = AppLinks();

    _sub = _appLinks.uriLinkStream.listen((uri) async {
      if (_handled) return;
      _handled = true;

      if (uri != null) {

        final exchangeToken = uri.queryParameters['exchange_token'];


        if (exchangeToken != null) {
        
          final res = await http.post(
            Uri.parse("$baseUrl/Google/exchangetoken?token=$exchangeToken"),
          );

          final data = jsonDecode(res.body);


          if (data["status"] == true) {
            final user = data["data"];

            final accId = user["AccId"];
            final role = user["Role"];
            final email = user["Email"];

            final pinResult = await _pinService.checkPinExist(
              email: email,
            );

            await context.read<SessionProvider>().setSession(
              accId: accId,
              role: role,
              email: email,
              hasPin: pinResult.pinExist,
            );

            if (!mounted) return;

            if (pinResult.pinExist) {

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PinPage(
                    userEmail: email,
                    userRole: role,
                  ),
                ),
              );
            } else {

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatePinPage(
                    userEmail: email,
                    userRole: role,
                  ),
                ),
              );
            }
          }
        }
      }
    });
  }

  void _handleGoogleSignIn() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      await GoogleOAuthService.login();
    } catch (e) {
      print("LOGIN BUTTON ERROR: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            height: screenHeight / 2.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.skyblue,
                  AppColors.lightblue
                ],
              ),
            ),
          ),
          Positioned(
            top: -screenHeight * 0.02,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Opacity(
              opacity: 0.3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/mainPageBG.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight / 2.6,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.1),
                      Image.asset('assets/images/ce_icon.png',scale: 0.5,),
                      SizedBox(height: screenHeight * 0.02),
                      Text('Welcome to CE Connect', style: TextWidgetStyles.text20LatoExtrabold().copyWith(color: Colors.white),),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: screenHeight * 0.3),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.09,
                          right: screenWidth * 0.09,
                          top: screenHeight * 0.05,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!kIsWeb && Platform.isAndroid) SizedBox(height: screenHeight * 0.025),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Please Sign in to continue',
                                  style: TextWidgetStyles.text24LatoBold().copyWith(
                                    color: AppColors.textBlue,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.025),
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Color.fromARGB(255, 236, 239, 239),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text('Your account (using KMITL Account)',
                                      style: TextWidgetStyles.text14LatoBold()
                                          .copyWith(color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3))),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Color.fromARGB(255, 236, 239, 239),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.05),
                            SizedBox(height: screenHeight * 0.04),
                            // Sign in button
                            GestureDetector(
                              onTap: _handleGoogleSignIn,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.008,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sign in with google',
                                      textAlign: TextAlign.center,
                                      style: TextWidgetStyles.text20LatoBold().copyWith(color: Colors.white),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset(
                                        'assets/images/google_icons.png',
                                        scale: 1.7,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _sub?.cancel();
    super.dispose();
  }
}