import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBarT extends StatelessWidget {
  const CustomBottomNavBarT({
    super.key,
    this.homeActive = false,
    this.gptActive = false,
    this.profileActive = false,
    this.onHomeTap,
    this.onGptTap,
    this.onProfileTap,
  });

  final bool homeActive;
  final bool gptActive;
  final bool profileActive;
  final VoidCallback? onHomeTap;
  final VoidCallback? onGptTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      clipBehavior: Clip.none,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.bottomNav,
        // color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.09),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: Row(
              children: [
                _buildNavItem(
                  imagePath: 'assets/images/homeNav_icon.png',
                  isActive: homeActive,
                  label: 'Home',
                  onTap: onHomeTap,
                ),
                SizedBox(width: screenWidth*0.068),
                _buildNavItem(
                  imagePath: 'assets/images/ceGptNav_icon.png',
                  isActive: gptActive,
                  label: 'CE-GPT',
                  onTap: onGptTap,
                ),
                SizedBox(width: screenWidth*0.068,),
                _buildNavItem(
                  imagePath: 'assets/images/profileNav_icon.png',
                  isActive: profileActive,
                  label: 'Profile',
                  onTap: onProfileTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
  required String imagePath,
  required bool isActive,
  required String label,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      transform: Matrix4.translationValues(0, isActive ? -20 : 0, 0),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isActive)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // color: AppColors.bottomNav,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.bottomNav,
                      width: 3,
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          imagePath,
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                        Text(label,style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue),)
                      ],
                    ),
                  ),
                ),
              if (!isActive)
                Container(
                  width: 60,
                  height: 60,
                  decoration:BoxDecoration(
                    // color: AppColors.bottomNav,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.bottomNav,
                      width: 3,
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          imagePath,
                          width: 28,
                          height: 28,
                          color: const Color.fromARGB(195, 73, 143, 255),
                        ),
                        Text(label,style: TextWidgetStyles.text10LatoMedium().copyWith(color: AppColors.lightblue),)
                      ],
                                  ),
                  ),
                )
            ],
          ),
        ],
      ),
    ),
  );
}

}