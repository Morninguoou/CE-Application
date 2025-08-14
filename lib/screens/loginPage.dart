import 'dart:convert';

import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/createPinPage.dart';
import 'package:ce_connect_app/screens/pinPage.dart';
import 'package:ce_connect_app/service/google_signin_api.dart';
import 'package:ce_connect_app/service/pin_api.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  void _handleGoogleSignIn() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final user = await GoogleSignInApi.signIn();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-in Canceled')),
        );
        return;
      }

      final String? userEmail = user.email;
      if (userEmail == null || userEmail.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Account Not Found')),
        );
        return;
      }

      final pinExist = await _pinService.checkPinExist(email: userEmail);

      if (!mounted) return;

      if (pinExist) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PinPage(userEmail: userEmail),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CreatePinPage(userEmail: userEmail),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
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
                            // Text(
                            //   'Email',
                            //   style: TextWidgetStyles.text16LatoRegular()
                            //       .copyWith(color: AppColors.blue),
                            // ),
                            // SizedBox(height: screenHeight * 0.002),
                            // Container(
                            //   height: screenHeight * 0.05,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(10),
                            //     border: Border.all(color: Color.fromARGB(255, 236, 239, 239)),
                            //   ),
                            //   child: TextField(
                            //     controller: _emailController,
                            //     style: TextWidgetStyles.text16LatoRegular(),
                            //     decoration: InputDecoration(
                            //       // hintText: 'Enter your email',
                            //       prefixIcon: const Icon(Icons.email_outlined, color: AppColors.yellow),
                            //       border: InputBorder.none,
                            //       contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(height: screenHeight * 0.01),
                            // // Password field
                            // Text(
                            //   'Password',
                            //   style: TextWidgetStyles.text16LatoRegular()
                            //       .copyWith(color: AppColors.blue),
                            // ),
                            // SizedBox(height: screenHeight * 0.002),
                            // Container(
                            //   height: screenHeight * 0.05,
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(10),
                            //     border: Border.all(color: Color.fromARGB(255, 236, 239, 239)),
                            //   ),
                            //   child: TextField(
                            //     controller: _passwordController,
                            //     obscureText: !_isPasswordVisible,
                            //     decoration: InputDecoration(
                            //       // hintText: 'Enter your password',
                            //       prefixIcon: const Icon(Icons.lock_outline, color: AppColors.yellow),
                            //       suffixIcon: IconButton(
                            //         icon: Icon(
                            //           _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            //           color: Colors.grey,
                            //         ),
                            //         onPressed: () {
                            //           setState(() {
                            //             _isPasswordVisible = !_isPasswordVisible;
                            //           });
                            //         },
                            //       ),
                            //       border: InputBorder.none,
                            //       contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                            //     ),
                            //   ),
                            // ),
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
    super.dispose();
  }
}