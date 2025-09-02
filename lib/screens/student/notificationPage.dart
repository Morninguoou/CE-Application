import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class NotificationPageS extends StatefulWidget {
  const NotificationPageS({super.key});

  @override
  State<NotificationPageS> createState() => _NotificationPageSState();
}

class _NotificationPageSState extends State<NotificationPageS> {
  int selectedTab = 0; // 0 for My Subject, 1 for CE Website

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Announcement', includeBackButton: true),
      body: Container(
        child: Column(
          children: [
            // Tab Buttons
            Container(
              margin: EdgeInsets.only(left: screenWidth*0.15,right: screenWidth*0.15, top: screenHeight*0.015, bottom: screenHeight*0.01),
              child: Row(
                children: [
                  // My Subject Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                        decoration: BoxDecoration(
                          gradient: selectedTab == 0
                              ? const LinearGradient(
                                  colors: [Color.fromARGB(255, 236, 158, 0), AppColors.yellow],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          color: selectedTab == 0 ? null : Colors.white,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              color: selectedTab == 0 
                                  ? Colors.white 
                                  : Colors.grey[400],
                              size: 20,
                            ),
                            SizedBox(width: screenWidth*0.01),
                            Text(
                              'My Subject',
                              style: TextWidgetStyles.text14LatoSemibold().copyWith(color: selectedTab == 0 
                                    ? Colors.white 
                                    : Colors.grey[400],)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // CE Website Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTab = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                        decoration: BoxDecoration(
                          gradient: selectedTab == 1
                              ? const LinearGradient(
                                  colors: [AppColors.lightblue, AppColors.skyblue],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null,
                          color: selectedTab == 1 ? null : Colors.white,
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.language,
                              color: selectedTab == 1 
                                  ? Colors.white 
                                  : Colors.grey[400],
                              size: 20,
                            ),
                            SizedBox(width: screenWidth*0.01),
                            Text(
                              'CE Website',
                              style: TextWidgetStyles.text14LatoSemibold().copyWith(color: selectedTab == 1 
                                    ? Colors.white 
                                    : Colors.grey[400],)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Area
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                child: selectedTab == 0 
                    ? _buildMySubjectContent()
                    : _buildCEWebsiteContent(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        notificationActive: true,
        onHomeTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageS()));
        },
        onGptTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CeGptPage()));
        },
        onNotificationTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPageS()));
        },
        onProfileTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePageS()));
        },
      ),
    );
  }

  // Function to show popup detail
  void _showNotificationDetail({
    required String title,
    required String subtitle,
    required String date,
    required String platform,
    String? additionalDetail,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header bar with title
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: selectedTab == 0 ? AppColors.yellow : AppColors.lightblue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              selectedTab == 0 ? Icons.folder_open : Icons.language,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              selectedTab == 0 ? 'My Subject' : 'CE Website',
                              style: TextWidgetStyles.text16LatoSemibold().copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content area
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Subject
                          Text(
                            title,
                            style: TextWidgetStyles.text16NotoSansSemibold().copyWith(
                              color: AppColors.textDarkblue,
                            ),
                          ),
                          // Date
                          Text(
                            date,
                            style: TextWidgetStyles.text12NotoSansMedium().copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          // Subtitle/Content
                          if (subtitle.isNotEmpty) ...[
                            // Text(
                            //   'Header:',
                            //   style: TextWidgetStyles.text14LatoSemibold().copyWith(
                            //     color: AppColors.textDarkblue,
                            //   ),
                            // ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                subtitle,
                                style: TextWidgetStyles.text14NotoSansMedium().copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 10),
                          // Platform
                          if (platform.isNotEmpty) ...[
                            Row(
                              children: [
                                Text(
                                  'Platform:',
                                  style: TextWidgetStyles.text12LatoSemibold().copyWith(
                                    color: AppColors.textDarkblue,
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Text(
                                  platform,
                                  style: TextWidgetStyles.text12NotoSansMedium().copyWith(
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ],

                          // Additional detail if provided
                          if (additionalDetail != null && additionalDetail.isNotEmpty) ...[
                            SizedBox(height: 10),
                            Text(
                              'Detail:',
                              style: TextWidgetStyles.text12LatoSemibold().copyWith(
                                color: AppColors.textDarkblue,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              additionalDetail,
                              style: TextWidgetStyles.text12NotoSansMedium().copyWith(
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMySubjectContent() {
    return ListView(
      children: [
        _buildDateHeader("12 Feb 2025 (Today)"),
        _buildNotificationItem(
          title: "UX & UI Thu. 2/67 [CE]",
          subtitle: "Rubric for final prototype exam",
          date: "12 Feb 2025 (Today)",
          color: Colors.orange,
          platform: 'Google Classrom',
          additionalDetail: "Please review the rubric carefully before the final prototype examination. All requirements must be met for full marks.",
        ),
        _buildNotificationItem(
          title: "UX & UI Thu. 2/67 [CE]",
          subtitle: "กำหนดส่งงานเก่าในงาน Final prototype",
          date: "12 Feb 2025 (Today)",
          color: Colors.orange,
          platform: 'Google Classrom',
          additionalDetail: "กรุณาส่งงานให้ครบถ้วนตามที่กำหนด ก่อนวันที่กำหนดส่ง",
        ),
        _buildNotificationItem(
          title: "2567-2 Database Systems",
          subtitle: "การออนไลน์การแน่งออนไลน์ 2 ส่วน",
          date: "12 Feb 2025 (Today)",
          platform: 'Google Classrom',
          color: Colors.orange,
        ),
        
        _buildDateHeader("11 Feb 2025 (Yesterday)"),
        _buildNotificationItem(
          title: "2567-2 Database Systems",
          subtitle: "การแนลอง ERD ให้เป็น Relational Database",
          date: "11 Feb 2025 (Yesterday)",
          platform: 'Google Classrom',
          color: Colors.orange,
        ),
        _buildNotificationItem(
          title: "IST 2567-2",
          subtitle: "ตารางลอน (ปลายภาค) ประจำการเรียนที่ 2",
          date: "11 Feb 2025 (Yesterday)",
          platform: 'Google Classrom',
          color: Colors.orange,
        ),
        _buildNotificationItem(
          title: "IST 2567-2",
          subtitle: "บศ. ที่ออสช่วย Lab",
          date: "11 Feb 2025 (Yesterday)",
          platform: 'Google Classrom',
          color: Colors.orange,
        ),
        
        _buildDateHeader("Previously"),
        _buildNotificationItem(
          title: "CEPP 2567",
          subtitle: "",
          date: "Previously",
          platform: 'Google Classrom',
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildCEWebsiteContent() {
    return ListView(
      children: [
        _buildDateHeader("12 Feb 2025 (Today)"),
        _buildNotificationItem(
          title: "การแสดงผลงานราชวิทยาโครงงาน",
          subtitle: "ขอเชิญส่วน บศ. และผู้สนใจเข้าร่วมการแสดงผลงาน",
          date: "12 Feb 2025 (Today)",
          color: Colors.blue,
          platform: 'CE Website',
          additionalDetail: "งานแสดงผลงานจะจัดขึ้นที่หอประชุมใหญ่ เวลา 09:00-16:00 น.",
        ),
        _buildNotificationItem(
          title: "การอบรมหลักสูตร CCNA",
          subtitle: "Cisco Certified Network Associate (CCNA)",
          date: "12 Feb 2025 (Today)",
          color: Colors.blue,
          platform: 'CE Website',
          additionalDetail: "หลักสูตรเตรียมความพร้อมสำหรับการสอบ CCNA รุ่นใหม่",
        ),
        _buildNotificationItem(
          title: "รับสมัคร Staff ค่าย NextGenAI",
          subtitle: "NextGenAI Camp 2025",
          date: "12 Feb 2025 (Today)",
          platform: 'CE Website',
          color: Colors.blue,
        ),
        
        _buildDateHeader("11 Feb 2025 (Yesterday)"),
        _buildNotificationItem(
          title: "รับสมัคร Summer School",
          subtitle: "Wuhan University สาธารณรัฐประชาชนจีน",
          date: "11 Feb 2025 (Yesterday)",
          platform: 'CE Website',
          color: Colors.blue,
        ),
        _buildNotificationItem(
          title: "บริษัท เหล็กสมายยบานโต้ จำกัด",
          subtitle: "รับสมัครนักศึกษาฝึกงาน",
          date: "11 Feb 2025 (Yesterday)",
          platform: 'CE Website',
          color: Colors.blue,
        ),
        _buildNotificationItem(
          title: "SCB TechX",
          subtitle: "เปิดรับสมัคร Co-op Intern สาย QA แล้วนะนั้น!",
          date: "11 Feb 2025 (Yesterday)",
          platform: 'CE Website',
          color: Colors.blue,
        ),
        
        _buildDateHeader("Previously"),
        _buildNotificationItem(
          title: "I4TECH",
          subtitle: "ประกาศรับฝึกงาน และขยายเวลศึกษา",
          date: "Previously",
          platform: 'CE Website',
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildDateHeader(String date) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight*0.005),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextWidgetStyles.text16LatoSemibold().copyWith(color: Color.fromARGB(255, 132, 150, 191))
          ),
          Divider(
            color:  Color.fromARGB(255, 132, 150, 191),
          )
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title, // Subject
    required String subtitle,
    required String date,
    required Color color,
    required String platform,
    String? additionalDetail,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        _showNotificationDetail(
          title: title,
          subtitle: subtitle,
          date: date,
          platform: platform,
          additionalDetail: additionalDetail,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight*0.01),
        constraints: const BoxConstraints(
          minHeight: 60,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(
              color: selectedTab == 0  ? AppColors.yellow : AppColors.lightblue,
              width: 11,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextWidgetStyles.text16NotoSansSemibold().copyWith(color: AppColors.textDarkblue),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextWidgetStyles.text12NotoSansMedium().copyWith(color: selectedTab == 0  ? AppColors.yellow : AppColors.lightblue,),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 12),
            // More detail button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: selectedTab == 0 ? AppColors.yellow : AppColors.lightblue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'more detail',
                style: TextWidgetStyles.text12LatoMedium().copyWith(color: Colors.white)
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}