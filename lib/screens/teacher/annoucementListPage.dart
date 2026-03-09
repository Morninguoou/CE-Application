import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/course_annoucement.dart';
import 'package:ce_connect_app/service/teacher_course.dart';
import 'package:flutter/material.dart';

enum AnnouncementType {
  announcement,
  assignment
}

class AnnouncementItem {
  final String id;
  final String header;
  final String date;
  final String detail;
  final AnnouncementType type;
  final DateTime dateTime;

  AnnouncementItem({
    required this.id,
    required this.header,
    required this.date,
    required this.detail,
    required this.type,
    required this.dateTime,
  });
}

class AnnoucementListPageT extends StatefulWidget {
  const AnnoucementListPageT({super.key, required this.courseId});

  final String courseId;

  @override
  State<AnnoucementListPageT> createState() => _AnnoucementListPageTState();
}

class _AnnoucementListPageTState extends State<AnnoucementListPageT> {

  List<AnnouncementItem> announcements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAnnouncements();
  }

  Future<void> fetchAnnouncements() async {
    try {

      final result =
          await CourseService().getCourseAnnouncements(widget.courseId);

      List<AnnouncementItem> items = result.map((e) {

        DateTime created = e.createdAt;

        return AnnouncementItem(
          id: e.id,
          header: e.title ?? (e.type == "Assignment" ? "Assignment" : "Announcement"),
          date: "${created.day}/${created.month}/${created.year}",
          detail: e.content,
          type: e.type == "Assignment"
              ? AnnouncementType.assignment
              : AnnouncementType.announcement,
          dateTime: created,
        );

      }).toList();

      setState(() {
        announcements = items;
        isLoading = false;
      });

    } catch (e) {

      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, List<AnnouncementItem>> groupAnnouncementsByDate() {
    Map<String, List<AnnouncementItem>> grouped = {};

    for (var item in announcements) {

      String groupKey;

      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(const Duration(days: 1));

      DateTime itemDate =
          DateTime(item.dateTime.year, item.dateTime.month, item.dateTime.day);

      if (itemDate == today) {
        groupKey = 'Today';
      } else if (itemDate == yesterday) {
        groupKey = 'Yesterday';
      } else {
        groupKey = item.date;
      }

      if (!grouped.containsKey(groupKey)) {
        grouped[groupKey] = [];
      }

      grouped[groupKey]!.add(item);
    }

    return grouped;
  }

  Widget buildAnnouncementIcon(AnnouncementType type) {

    switch (type) {

      case AnnouncementType.assignment:
        return Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 126, 174, 252),
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/images/assignment_icon.png', scale: 1.2));

      case AnnouncementType.announcement:
        return Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 232, 186),
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/images/annoucement_icon.png'));
    }
  }

  void showAnnouncementDetail(AnnouncementItem item) {

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.02),

                  decoration: BoxDecoration(
                    color: item.type == AnnouncementType.assignment
                        ? const Color.fromARGB(255, 126, 174, 252)
                        : const Color.fromARGB(255, 255, 232, 186),

                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),

                  child: Row(
                    children: [

                      item.type == AnnouncementType.announcement
                          ? Image.asset('assets/images/annoucement_icon.png')
                          : Image.asset('assets/images/assignment_icon.png',
                              scale: 1.2),

                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.03),

                      Expanded(
                        child: Text(
                          item.header,
                          style: TextWidgetStyles.text16LatoSemibold()
                              .copyWith(
                                  color: item.type ==
                                          AnnouncementType.announcement
                                      ? AppColors.textDarkblue
                                      : Colors.white),
                        ),
                      ),

                      Text(
                        item.date,
                        style: TextWidgetStyles.text12LatoSemibold().copyWith(
                            color:
                                item.type == AnnouncementType.announcement
                                    ? AppColors.textDarkblue
                                    : Colors.white),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                  
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  
                        Text(
                          'Detail',
                          style: TextWidgetStyles.text16LatoSemibold()
                              .copyWith(color: AppColors.textDarkblue),
                        ),
                  
                        const SizedBox(height: 12),
                  
                        Text(
                          item.detail,
                          style: TextWidgetStyles.text14LatoSemibold()
                              .copyWith(
                                  color: Colors.grey[700],
                                  height: 1.5),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildAnnouncementItem(AnnouncementItem item) {

    return GestureDetector(
      onTap: () {
        showAnnouncementDetail(item);
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.textDarkblue),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          leading: buildAnnouncementIcon(item.type),

          title: Text(
            item.header,
            style: TextWidgetStyles.text14LatoSemibold()
                .copyWith(color: AppColors.textDarkblue),
          ),

          trailing: Text(
            item.date,
            style: TextWidgetStyles.text12LatoSemibold()
                .copyWith(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget buildDateSection(String dateLabel, List<AnnouncementItem> items) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),

          child: Text(
            dateLabel,
            style: TextWidgetStyles.text16LatoSemibold()
                .copyWith(color: Colors.grey[600]),
          ),
        ),

        ...items.map((item) => buildAnnouncementItem(item)).toList()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final groupedAnnouncements = groupAnnouncementsByDate();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        backgroundColor: AppColors.blue,

        title: SizedBox(
          width: double.infinity,

          child: Stack(
            alignment: Alignment.center,

            children: [

              Positioned(
                left: 0,
                child: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Text(
                "Course Announcement",
                style: TextWidgetStyles.text20LatoSemibold()
                    .copyWith(color: AppColors.background),
              )
            ],
          ),
        ),
      ),

      body: ListView.builder(
        itemCount: groupedAnnouncements.keys.length,

        itemBuilder: (context, index) {

          String dateKey = groupedAnnouncements.keys.elementAt(index);

          List<AnnouncementItem> items =
              groupedAnnouncements[dateKey]!;

          return buildDateSection(dateKey, items);
        },
      ),
    );
  }
}