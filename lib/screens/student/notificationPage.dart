import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/noti_annoucement.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/service/announcement_list_api.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBarS.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ce_connect_app/utils/session_provider.dart';

class NotificationPageS extends StatefulWidget {
  const NotificationPageS({super.key});

  @override
  State<NotificationPageS> createState() => _NotificationPageSState();
}

class _NotificationPageSState extends State<NotificationPageS> {
  int selectedTab = 0; // 0 for My Subject, 1 for CE Website

  final _notiService = NotiAnnouncementsService();
  Future<NotiAnnouncementsResponse>? _futureMySubject;
  String? _lastAccId;

  final _dateFmt = DateFormat('d MMM yyyy, HH:mm');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.watch<SessionProvider>().accId;
    final accId = '65010782'; // For test API
    if (accId != null && accId.isNotEmpty && _lastAccId != accId) {
      _lastAccId = accId;
      _futureMySubject = _fetchMySubject(accId);
      setState(() {});
    }
  }

  Future<NotiAnnouncementsResponse> _fetchMySubject(String accId) {
    return _notiService.fetchAnnouncementsData(accId: accId);
  }

  Future<void> _refreshMySubject() async {
    final accId = context.read<SessionProvider>().accId;
    if (accId == null || accId.isEmpty) return;
    setState(() {
      _futureMySubject = _fetchMySubject(accId);
    });
    await _futureMySubject;
  }


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
      bottomNavigationBar: CustomBottomNavBarS(
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
      final screenH = MediaQuery.of(context).size.height;
      final screenW = MediaQuery.of(context).size.width;
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: screenH * 0.5,
                maxWidth: screenW * 0.85,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header bar with title
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                            const SizedBox(width: 8),
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
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content area (Scrollable)
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Subject
                            Text(
                              title,
                              style: TextWidgetStyles.text16NotoSansSemibold()
                                  .copyWith(color: AppColors.textDarkblue),
                            ),
                            // Date
                            Text(
                              date,
                              style: TextWidgetStyles.text12NotoSansMedium()
                                  .copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 10),

                            // Subtitle/Content
                            if (subtitle.isNotEmpty) ...[
                              Text(
                                subtitle,
                                style: TextWidgetStyles.text14NotoSansMedium()
                                    .copyWith(color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                            ],

                            // Platform
                            if (platform.isNotEmpty) ...[
                              Row(
                                children: [
                                  Text(
                                    'Platform:',
                                    style: TextWidgetStyles.text12LatoSemibold()
                                        .copyWith(color: AppColors.textDarkblue),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    platform,
                                    style: TextWidgetStyles.text12NotoSansMedium()
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],

                            // Additional detail
                            if (additionalDetail != null && additionalDetail.isNotEmpty) ...[
                              Text(
                                'Detail:',
                                style: TextWidgetStyles.text12LatoSemibold()
                                    .copyWith(color: AppColors.textDarkblue),
                              ),
                              const SizedBox(height: 6),
                              // ใช้ SelectableText เพื่อคัดลอกได้ และตัดคำยาว ๆ
                              SelectableText(
                                additionalDetail,
                                style: TextWidgetStyles.text12NotoSansMedium()
                                    .copyWith(color: Colors.grey[800]),
                              ),
                            ],
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

    Widget _buildMySubjectContent() {
    final accId = context.watch<SessionProvider>().accId;

    if (accId == null || accId.isEmpty) {
      return Center(
        child: Text(
          'ยังไม่ได้เข้าสู่ระบบ หรือไม่พบ accId',
          style: TextWidgetStyles.text14LatoSemibold().copyWith(color: Colors.grey[600]),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshMySubject,
      child: FutureBuilder<NotiAnnouncementsResponse>(
        future: _futureMySubject,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              children: const [
                SizedBox(height: 24),
                Center(child: CircularProgressIndicator()),
                SizedBox(height: 24),
              ],
            );
          }

          if (snapshot.hasError) {
            return ListView(
              padding: const EdgeInsets.only(top: 24),
              children: [
                Center(
                  child: Text(
                    'เกิดข้อผิดพลาดในการดึงข้อมูล\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextWidgetStyles.text14LatoSemibold().copyWith(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: _refreshMySubject,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'ลองอีกครั้ง',
                        style: TextWidgetStyles.text14LatoSemibold().copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          final data = snapshot.data;
          if (data == null) {
            return ListView(
              children: const [
                SizedBox(height: 24),
                Center(child: Text('ไม่พบข้อมูล')),
              ],
            );
          }

          // Helper: ตัดบรรทัดแรกของ text ไปเป็น subtitle
          String _firstLine(String s) {
            final lines = s.trim().split('\n');
            return lines.isNotEmpty ? lines.first.trim() : '';
          }

          // สร้างรายการตาม Section
          final sections = <Map<String, dynamic>>[
            {'label': 'Today', 'section': data.today},
            {'label': 'Yesterday', 'section': data.yesterday},
            {'label': 'Previously', 'section': data.previously},
          ];

          final children = <Widget>[];
          for (final e in sections) {
            final NotiSection sec = e['section'] as NotiSection;
            // แสดง header ถ้ามี HeaderTime และ (มีรายการ หรือ header ต้องการโชว์เสมอ)
            final bool hasItems = sec.detail.isNotEmpty;
            if ((sec.headerTime).isNotEmpty) {
              children.add(_buildDateHeader(sec.headerTime));
            }

            if (!hasItems) {
              // ถ้าไม่มีรายการใน Today/Yesterday สามารถปล่อยว่างไปได้
              continue;
            }

            //TODO แก้ course id เป็นชื่อวิชา
            for (final item in sec.detail) {
              final title = item.name.isNotEmpty ? item.name : 'Unknown Course';
              final subtitle = _firstLine(item.text);
              final dateStr = _dateFmt.format(item.creationTime);
              children.add(
                _buildNotificationItem(
                  title: title,
                  subtitle: subtitle,
                  date: dateStr,
                  color: Colors.orange,
                  platform: 'Google Classroom',
                  additionalDetail: item.text.trim().isEmpty ? null : item.text.trim(),
                ),
              );
            }
          }

          if (children.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 24),
                Center(child: Text('ยังไม่มีประกาศใหม่จากวิชาของคุณ')),
              ],
            );
          }

          return ListView(
            children: children,
          );
        },
      ),
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
                'detail',
                style: TextWidgetStyles.text14LatoExtrabold().copyWith(color: Colors.white)
              ),
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}