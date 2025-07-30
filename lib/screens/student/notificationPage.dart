import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
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
    );
  }

  Widget _buildMySubjectContent() {
    return ListView(
      children: [
        _buildDateHeader("12 Feb 2025 (Today)"),
        _buildNotificationItem(
          title: "UX & UI Thu. 2/67 [CE]",
          subtitle: "Rubric for final prototype exam",
          color: Colors.orange,
        ),
        _buildNotificationItem(
          title: "UX & UI Thu. 2/67 [CE]",
          subtitle: "กำหนดส่งงานเก่าในงาน Final prototype",
          color: Colors.orange,
        ),
        _buildNotificationItem(
          title: "2567-2 Database Systems",
          subtitle: "การออนไลน์การแน่งออนไลน์ 2 ส่วน",
          color: Colors.orange,
        ),
        
        _buildDateHeader("11 Feb 2025 (Yesterday)"),
        _buildNotificationItem(
          title: "2567-2 Database Systems",
          subtitle: "การแนลอง ERD ให้เป็น Relational Database",
          color: Colors.orange,
        ),
        _buildNotificationItem(
          title: "IST 2567-2",
          subtitle: "ตารางลอน (ปลายภาค) ประจำการเรียนที่ 2",
          color: Colors.orange,
        ),
        _buildNotificationItem(
          title: "IST 2567-2",
          subtitle: "บศ. ที่ออสช่วย Lab",
          color: Colors.orange,
        ),
        
        _buildDateHeader("Previously"),
        _buildNotificationItem(
          title: "CEPP 2567",
          subtitle: "",
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
          color: Colors.blue,
        ),
        _buildNotificationItem(
          title: "การอบรมหลักสูตร CCNA",
          subtitle: "Cisco Certified Network Associate (CCNA)",
          color: Colors.blue,
        ),
        _buildNotificationItem(
          title: "รับสมัคร Staff ค่าย NextGenAI",
          subtitle: "NextGenAI Camp 2025",
          color: Colors.blue,
        ),
        
        _buildDateHeader("11 Feb 2025 (Yesterday)"),
        _buildNotificationItem(
          title: "รับสมัคร Summer School",
          subtitle: "Wuhan University สาธารณรัฐประชาชนจีน",
          color: Colors.blue,
        ),
        _buildNotificationItem(
          title: "บริษัท เหล็กสมายยบานโต้ จำกัด",
          subtitle: "รับสมัครนักศึกษาฝึกงาน",
          color: Colors.blue,
        ),
        _buildNotificationItem(
          title: "SCB TechX",
          subtitle: "เปิดรับสมัคร Co-op Intern สาย QA แล้วนะนั้น!",
          color: Colors.blue,
        ),
        
        _buildDateHeader("Previously"),
        _buildNotificationItem(
          title: "I4TECH",
          subtitle: "ประกาศรับฝึกงาน และขยายเวลศึกษา",
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
    required String title,
    required String subtitle,
    required Color color,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        
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