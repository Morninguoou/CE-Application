import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/pinPage.dart';
import 'package:flutter/material.dart';

import 'package:ce_connect_app/service/pin_api.dart';

class ConfirmPinPage extends StatefulWidget {
  final String userEmail;
  final String createPin;

  const ConfirmPinPage({
    super.key,
    required this.userEmail,
    required this.createPin,
  });

  @override
  State<ConfirmPinPage> createState() => _ConfirmPinPageState();
}

class _ConfirmPinPageState extends State<ConfirmPinPage> {
  final List<String> pin = [];
  bool _loading = false;

  final _pinService = PinService();

  @override
  void initState() {
    super.initState();
  }
  
  void _onKeyPressed(String value) {
    if (_loading) return;
    if (pin.length < 6) {
      setState(() => pin.add(value));

      if (pin.length == 6) {
        final confirmPin = pin.join();

        // confirm pin not match
        if (confirmPin != widget.createPin) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please try again.')),
          );
          setState(() => pin.clear());
          return;
        }
        _submitPin(confirmPin);
      }
    }
  }

  void _onBackspace() {
    if (_loading) return;
    if (pin.isNotEmpty) {
      setState(() {
        pin.removeLast();
      });
    }
  }

  Future<void> _submitPin(String confirmPin) async {
    setState(() => _loading = true);
    try {
      final result = await _pinService.createNewPin(
        email: widget.userEmail,
        pinNumber: confirmPin,
      );

      if (!mounted) return;

      if (result.success) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: SizedBox(
                height: 60, // ความสูงของ dialog
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create PIN Successfully",
                      style: TextWidgetStyles.text16LatoMedium(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => PinPage(userEmail: widget.userEmail),
                        ),
                      );
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message)),
        );
        setState(() => pin.clear());
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create PIN: $e')),
      );
      setState(() => pin.clear());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  Widget _buildPinDots() {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth*0.015),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < pin.length ? Colors.white : Colors.transparent,
            border: Border.all(
              color:Colors.white,
              width: 2
            )
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String text, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed ?? () => _onKeyPressed(text),
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 75,
        height: 75,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextWidgetStyles.text24LatoBold().copyWith(color: AppColors.blue)
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: _onBackspace,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 75,
        height: 75,
        decoration: const BoxDecoration(
          color: AppColors.yellow,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.backspace_outlined, color: Colors.white),
      ),
    );
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
          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.07),
                      Image.asset('assets/images/ce_icon.png',scale: 0.5,),
                      SizedBox(height: screenHeight * 0.02),
                      Text('Confirm Your Passcode', style: TextWidgetStyles.text20LatoExtrabold().copyWith(color: Colors.white),),
                      SizedBox(height: screenHeight * 0.01),
                      _buildPinDots(),
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
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: screenWidth*0.03,
                              runSpacing: screenHeight*0.01,
                              children: [
                                for (var i = 1; i <= 9; i++)
                                  _buildNumberButton(i.toString()),
                                SizedBox(width:screenWidth*0.25), // ช่องว่างด้านซ้าย
                                _buildNumberButton('0'),
                                _buildBackspaceButton(),
                              ],
                            ),
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
}