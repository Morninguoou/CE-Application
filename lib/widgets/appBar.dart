import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.includeBackButton = false,
    this.onBackButtonTap,
    this.backgroundColor = AppColors.blue,
    this.arrowBackColor = Colors.white,
    this.titleColor = Colors.white,
  });

  final String title;
  final String? subtitle;
  final bool includeBackButton;
  final VoidCallback? onBackButtonTap;
  final Color backgroundColor;
  final Color arrowBackColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      backgroundColor: backgroundColor,
      title: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (includeBackButton)
              Positioned(
                left: 0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new,color: arrowBackColor,),
                  onPressed: onBackButtonTap ?? () => Navigator.of(context).pop(),
                ),
              ),
            Column(
              children: [
                Text(
                  title,
                  style: TextWidgetStyles.text20LatoSemibold().copyWith(color: titleColor),
                ),
                subtitle != null ?
                  Text(
                    subtitle!,
                    style: TextWidgetStyles.text14LatoRegular().copyWith(color: titleColor),
                  ) : const SizedBox(height: 0)
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}