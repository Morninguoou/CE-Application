import 'dart:convert';

import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/service/google_signin_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  GoogleSignIn signIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: '112402731598-ih4f8pboggm1pb0scecm2bme1j339sk9.apps.googleusercontent.com',
  );
  void Signin() async {
    try {
      await signIn.signOut();
      var user = await signIn.signIn();
      print(user);
    } catch (e) {
      print(e);
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
                            Text(
                              'Please Sign in to continue',
                              style: TextWidgetStyles.text24LatoBold().copyWith(
                                color: AppColors.textBlue,
                              ),
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
                                  child: Text('Your account',
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
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Email',
                              style: TextWidgetStyles.text16LatoRegular()
                                  .copyWith(color: AppColors.blue),
                            ),
                            SizedBox(height: screenHeight * 0.002),
                            Container(
                              height: screenHeight * 0.05,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color.fromARGB(255, 236, 239, 239)),
                              ),
                              child: TextField(
                                controller: _emailController,
                                style: TextWidgetStyles.text16LatoRegular(),
                                decoration: InputDecoration(
                                  // hintText: 'Enter your email',
                                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.yellow),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            // Password field
                            Text(
                              'Password',
                              style: TextWidgetStyles.text16LatoRegular()
                                  .copyWith(color: AppColors.blue),
                            ),
                            SizedBox(height: screenHeight * 0.002),
                            Container(
                              height: screenHeight * 0.05,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color.fromARGB(255, 236, 239, 239)),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  // hintText: 'Enter your password',
                                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.yellow),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            // Sign in button
                            GestureDetector(
                              onTap: Signin,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.008,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Sign in with google',
                                  textAlign: TextAlign.center,
                                  style: TextWidgetStyles.text20LatoBold().copyWith(color: Colors.white),
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

  // Future<void> Signin() async {
  //   try {
  //     final user = await GoogleSignInApi.login();
  //     if (user == null) {
  //       // ผู้ใช้ยกเลิกการล็อกอิน
  //       print('User cancelled login');
  //       return;
  //     }

  //     final auth = await user.authentication;
  //     print('idToken: ${auth.idToken}');
  //     print('accessToken: ${auth.accessToken}');
  //     final idToken = auth.idToken;

  //     if (idToken == null) {
  //       print('No idToken obtained');
  //       return;
  //     }

      // // ส่ง idToken ไป backend (ตัวอย่างใช้ http package)
      // final response = await http.post(
      //   Uri.parse('https://yourbackend.com/api/auth/google'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'idToken': idToken}),
      // );

      // if (response.statusCode == 200) {
      //   // Login สำเร็จ backend verify token เรียบร้อย
      //   print('Login successful');
      //   // ทำอย่างอื่น เช่น เก็บ session, navigate หน้าใหม่
      // } else {
      //   print('Login failed on backend: ${response.body}');
      // }
  //   } catch (e) {
  //     print('Signin error: $e');
  //   }
  // }
  
}