import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/assignment_item.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/assignmentDetailPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/service/assignment_list_api.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssignmentPageS extends StatefulWidget {
  const AssignmentPageS({super.key});

  @override
  State<AssignmentPageS> createState() => _AssignmentPageSState();
}

class _AssignmentPageSState extends State<AssignmentPageS> {
  final AssignmentListService _service = AssignmentListService();
  Future<List<AssignmentItem>>? _future;
  String? _accId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.read<SessionProvider>().accId;
    final accId = '65010782'; // For test API
    if (_accId != accId) {
      _accId = accId;
      if (_accId != null && _accId!.isNotEmpty) {
        _future = _service.fetchAssignments(accId: _accId!);
        setState(() {});
      }
    }
  }

  String _formatDue(AssignmentItem item) {
    // MMM d, HH:mm -> "Mar 6, 23:59"
    final date = item.dueDate;
    final dt = _combineDue(item);
    final dateStr = DateFormat('MMM d').format(date); // ภาษาอังกฤษ
    final timeStr = DateFormat('HH:mm').format(dt);
    return 'Due $dateStr, $timeStr';
  }

  DateTime _combineDue(AssignmentItem item) {
    final parts = item.dueTime.trim().split(' ');
    try {
      if (parts.length == 2) {
        final hm = parts[0];
        final ampm = parts[1].toUpperCase();
        final hmparts = hm.split(':');
        int h = int.parse(hmparts[0]);
        int m = int.parse(hmparts[1]);
        if (ampm == 'PM' && h != 12) h += 12;
        if (ampm == 'AM' && h == 12) h = 0;
        return DateTime(item.dueDate.year, item.dueDate.month, item.dueDate.day, h, m);
      }
    } catch (_) {}
    return item.dueDate;
  }

  String _platformFromLink(String link) {
    try {
      final host = Uri.parse(link).host;
      if (host.contains('classroom.google.com')) return 'Google classroom';
      return host; 
    } catch (_) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Assignments',includeBackButton: true),
      body:(_accId == null || _accId!.isEmpty)
          ? _buildCenterText('ไม่พบ accId (ยังไม่ได้ Sign-in?)')
          : FutureBuilder<List<AssignmentItem>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return _buildCenterText('เกิดข้อผิดพลาด: ${snap.error}');
                }
                final items = snap.data ?? [];
                if (items.isEmpty) {
                  return _buildCenterText('ยังไม่มีงานที่ต้องส่ง');
                }
                
                //TODO fillter เฉพาะงานที่ยังไม่หมดเขต
                // final now = DateTime.now();
                // final upcoming = items.where((it) {
                //   final dueAt = _combineDue(it);
                //   return dueAt.isAfter(now);
                // }).toList();

                // upcoming.sort((a, b) => _combineDue(a).compareTo(_combineDue(b)));

                // if (upcoming.isEmpty) {
                //   return _buildCenterText('ยังไม่มีงานที่ต้องส่ง');
                // }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.04,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final platform = _platformFromLink(item.alternateLink);
                    final due = _formatDue(item);

                    return InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AssignmentDetailPageS(item: item),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 3,
                              offset: Offset(0, 3),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // แถบหัวสีฟ้า = ชื่อวิชา/คลาส
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.012,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.lightblue,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                item.courseId,
                                style: TextWidgetStyles
                                    .text14NotoSansSemibold()
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                      
                            // เนื้อการ์ด
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.015,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.lightyellow,
                                    radius: 30,
                                    child: Image.asset('assets/images/assignment_icon.png'),
                                  ),
                                  SizedBox(width: screenWidth * 0.04),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // title
                                        Text(
                                          item.title,
                                          style: TextWidgetStyles
                                              .text14NotoSansSemibold(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        // due
                                        Text(
                                          due,
                                          style: TextWidgetStyles.text12LatoMedium(),
                                        ),
                                        // platform
                                        Text(
                                          platform,
                                          style: TextWidgetStyles.text12LatoMedium(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: CustomBottomNavBar(
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
  Widget _buildCenterText(String text) {
    return Center(
      child: Text(
        text,
        style: TextWidgetStyles.text16LatoRegular()
            .copyWith(color: AppColors.textBlue),
      ),
    );
  }
}