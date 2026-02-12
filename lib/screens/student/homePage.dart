import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/home_assignment.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/assignmentPage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/service/home_assignment_api.dart';
import 'package:ce_connect_app/utils/session_provider.dart';
import 'package:ce_connect_app/widgets/bottomNavBarS.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ce_connect_app/service/home_announcement_api.dart';
import 'package:ce_connect_app/models/home_announcement.dart';

class HomePageS extends StatefulWidget {
  const HomePageS({super.key});

  @override
  State<HomePageS> createState() => _HomePageSState();
}

class _HomePageSState extends State<HomePageS> {

  final _announcementService = HomeAnnouncementService();
  Future<List<Announcement>>? _futureAnnouncements;

  final _assignmentService = HomeAssignmentService();
  Future<List<Assignment>>? _futureAssignments;

  String? _lastAccId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Watch accId จาก SessionProvider
    final accId = '65010782'; // For test API
    // final accId = context.watch<SessionProvider>().accId;

    if (accId != null && accId.isNotEmpty && accId != _lastAccId) {
      _lastAccId = accId;
      _futureAnnouncements = _announcementService.fetchAnnouncements(accId: accId);
      setState(() {});
    }
  }

  String _formatDueText(DateTime dueDate, String dueTime) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final d = dueDate;
    final day = d.day.toString();
    final month = months[d.month - 1];
    final year = d.year.toString();
    final time = (dueTime.isNotEmpty) ? dueTime : '';
    return 'Due $day $month $year${time.isNotEmpty ? ', $time' : ''}';
  }

  bool _isThisWeek(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekday = today.weekday; // Mon=1..Sun=7
    final startOfWeek = today.subtract(Duration(days: weekday - 1)); // Monday
    final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    return !date.isBefore(startOfWeek) && !date.isAfter(endOfWeek);
  }

  Widget _buildAnnouncementsSection(double screenWidth, double screenHeight) {
    final accId = context.watch<SessionProvider>().accId;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/bell_icon.png', width: 25, height: 25),
            SizedBox(width: screenWidth * 0.013),
            Text(
              'Announcements',
              style: TextWidgetStyles.text20LatoSemibold()
                  .copyWith(color: AppColors.textBlue),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // Navigate to the announcements page
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPageS()));
              },
              child: Text(
                'view all',
                style: TextWidgetStyles.text16LatoRegular()
                    .copyWith(color: AppColors.textBlue),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.007),

        //ยังไม่มี accId ให้ผู้ใช้ Login ก่อน หรือรอ provider load
        if (accId == null || accId.isEmpty)
          Container(
            height: screenHeight * 0.16,
            alignment: Alignment.center,
            child: Text(
              'ยังไม่ได้เข้าสู่ระบบ\nกรุณา Login ก่อน',
              textAlign: TextAlign.center,
              style: TextWidgetStyles.text14NotoSansRegular()
                  .copyWith(color: AppColors.textDarkblue.withOpacity(0.6)),
            ),
          )
        // 2) มี accId แสดง FutureBuilder
        else
          SizedBox(
            height: screenHeight * 0.16,
            child: FutureBuilder<List<Announcement>>(
              future: _futureAnnouncements,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading state
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    separatorBuilder: (_, __) => SizedBox(width: screenWidth * 0.02),
                    itemCount: 3,
                    itemBuilder: (_, __) => Container(
                      width: screenWidth * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.015,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.campaign_outlined, color: Colors.blue, size: 30),
                          SizedBox(width: screenWidth * 0.02),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(height: 14, width: double.infinity, color: const Color(0xFFEFEFEF)),
                                const SizedBox(height: 6),
                                Container(height: 12, width: screenWidth * 0.3, color: const Color(0xFFEFEFEF)),
                                const SizedBox(height: 6),
                                Container(height: 12, width: screenWidth * 0.25, color: const Color(0xFFEFEFEF)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'เกิดข้อผิดพลาดในการโหลดประกาศ',
                      style: TextWidgetStyles.text14NotoSansRegular()
                          .copyWith(color: Colors.red),
                    ),
                  );
                }

                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      'ยังไม่มีประกาศ',
                      style: TextWidgetStyles.text14NotoSansRegular()
                          .copyWith(color: AppColors.textDarkblue.withOpacity(0.6)),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) {
                    final i = items[index];

                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: screenWidth * 0.45,
                        margin: EdgeInsets.only(
                          right: screenWidth * 0.02,
                          bottom: screenHeight * 0.01,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.campaign_outlined, color: Colors.blue, size: 30),
                                SizedBox(width: screenWidth * 0.01),
                                // ไม่มีชื่อผู้ประกาศใน response -> แสดง courseId แทน
                                Expanded(
                                  child: Text(
                                    i.courseId.isNotEmpty ? i.name : 'Classroom',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextWidgetStyles.text16LatoMedium()
                                        .copyWith(color: AppColors.textDarkblue),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              "${i.creationTime.day.toString().padLeft(2, '0')}/${i.creationTime.month.toString().padLeft(2, '0')}/${i.creationTime.year} ${i.creationTime.hour.toString().padLeft(2, '0')}:${i.creationTime.minute.toString().padLeft(2, '0')}",
                              style: TextWidgetStyles.text12LatoMedium()
                                  .copyWith(color: AppColors.skyblue),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            // เนื้อหาบรรทัดแรกของประกาศ
                            Text(
                              i.firstLine,
                              style: TextWidgetStyles.text14NotoSansRegular()
                                  .copyWith(color: AppColors.textBlack),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAssignmentsSection(double screenWidth, double screenHeight) {
    final accId = context.watch<SessionProvider>().accId;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2, offset: const Offset(0, 5))],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
        child: (accId == null || accId.isEmpty)
            ? Center(
                child: Text(
                  'ยังไม่ได้เข้าสู่ระบบ\nกรุณา Login ก่อน',
                  textAlign: TextAlign.center,
                  style: TextWidgetStyles.text14NotoSansRegular()
                    .copyWith(color: AppColors.textDarkblue.withOpacity(0.6)),
                ),
              )
            : FutureBuilder<List<Assignment>>(
                future: _futureAssignments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Loading skeleton 5 แถว
                    return ListView.builder(
                      itemCount: 5,
                      itemBuilder: (_, __) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ฝั่งซ้าย skeleton สองบรรทัด
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(height: 12, width: screenWidth*0.55, color: const Color(0xFFEFEFEF)),
                                  SizedBox(height: screenHeight * 0.005),
                                  Container(height: 12, width: screenWidth*0.40, color: const Color(0xFFEFEFEF)),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.012),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Container(width: 40, height: 10, color: Colors.white.withOpacity(0.6)),
                              )
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          const Divider(color: Color(0xFFEFEFEF), thickness: 1),
                          SizedBox(height: screenHeight * 0.004),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'เกิดข้อผิดพลาดในการโหลดงานที่มอบหมาย',
                        style: TextWidgetStyles.text14NotoSansRegular()
                            .copyWith(color: Colors.red),
                      ),
                    );
                  }

                  final all = snapshot.data ?? [];
                  // กรองเฉพาะ "This week"
                  final items = all.where((a) => _isThisWeek(a.dueDate)).toList()
                    ..sort((a,b) => a.dueDate.compareTo(b.dueDate));

                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'สัปดาห์นี้ยังไม่มีงานที่มอบหมาย',
                        style: TextWidgetStyles.text14NotoSansRegular()
                          .copyWith(color: AppColors.textDarkblue.withOpacity(0.6)),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    itemBuilder: (context, index) {
                      final i = items[index];
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i.name.toUpperCase(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextWidgetStyles.text10LatoBold()
                                        .copyWith(color: AppColors.lightblue),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Text(
                                    _formatDueText(i.dueDate, i.dueTime),
                                    style: TextWidgetStyles.text12LatoBold()
                                        .copyWith(color: AppColors.skyblue),
                                  ),
                                ],
                              ),
                              // ขวา: ปุ่ม "more"
                              GestureDetector(
                                onTap: () {
                                  // TODO: กดแล้วไปหน้า details
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenHeight * 0.005),
                                  decoration: BoxDecoration(
                                    color: AppColors.yellow,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'more',
                                    style: TextWidgetStyles.text12LatoBold()
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          const Divider(color: Color(0xFFEFEFEF), thickness: 1),
                          SizedBox(height: screenHeight * 0.004),
                        ],
                      );
                    },
                  );
                },
              ),
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
            height: screenHeight / 2.57,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.skyblue,
                  AppColors.lightblue
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
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
            child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.asset(
                        'assets/images/ce_icon.png',
                        width: 29,
                        height: 29,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                          vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.asset(
                        'assets/images/chat_icon.png',
                        width: 29,
                        height: 29,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.007,
                ),
                Row(
                  children: [
                    Text(
                      'Today’s Plan',
                      style: TextWidgetStyles.text20LatoBold()
                          .copyWith(color: AppColors.background),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.007,
                ),
                //todo: Calendar
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.012),
                  height: screenHeight * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/calendar_icon.png',
                            width: 22,
                            height: 22,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: screenWidth * 0.01,
                      ),
                      Column(
                        children: [
                          Text(
                            'Jan 2025',
                            style: TextWidgetStyles.text16LatoBold().copyWith(
                              color: AppColors.blue,
                            ),
                          ),
                          Text(
                            '16',
                            style: TextWidgetStyles.text48LatoSemibold()
                                .copyWith(color: AppColors.blue, height: 1.0),
                          ),
                          SizedBox(height: screenHeight * 0.005,),
                          Text(
                            'Thu',
                            style: TextWidgetStyles.text20LatoBold()
                                .copyWith(color: AppColors.blue, height: 1.0),
                          ),
                        ],
                      ),
                      SizedBox(width: screenWidth * 0.1),
                      Expanded(
                        child: SizedBox(
                          height: screenHeight * 0.2,
                          child: ListView.builder(
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    bottom: screenHeight * 0.005),
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.025,
                                    vertical: screenHeight * 0.005),
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'UX & UI Thu. 2/67 [CE]',
                                      style: TextWidgetStyles.text14LatoBold()
                                          .copyWith(
                                              color: AppColors.background),
                                    ),
                                    Text(
                                      'ECC- 810',
                                      style: TextWidgetStyles.text10LatoMedium()
                                          .copyWith(
                                              color: AppColors.background,
                                              height: 1.0),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    Text(
                                      '13:00-15:00',
                                      style: TextWidgetStyles.text12LatoMedium()
                                          .copyWith(
                                              color: AppColors.background),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.04,),
                _buildAnnouncementsSection(screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.001,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/file_icon.png',
                      width: 17,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    Text(
                      'This week assignments',
                      style: TextWidgetStyles.text20LatoSemibold()
                          .copyWith(color: AppColors.textBlue),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the assignments page
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AssignmentPageS()));
                      },
                      child: Text(
                        'view all',
                        style: TextWidgetStyles.text16LatoRegular()
                            .copyWith(color: AppColors.textBlue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.007,),
                _buildAssignmentsSection(screenWidth, screenHeight),
              ],
            ),
          ))
        ],
      ),
      bottomNavigationBar: CustomBottomNavBarS(
        homeActive: true,
        onHomeTap: () {},
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
}
