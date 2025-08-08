import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:flutter/material.dart';

// Data model for announcements
class AnnouncementItem {
  final String id;
  final String header;
  final String date;
  final String detail; // เพิ่มฟิลด์ detail
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

enum AnnouncementType {
  announcement, // ประกาศ - clipboard icon
  assignment    // การสั่งงาน - megaphone icon
}

class AnnoucementListPageT extends StatefulWidget {
  const AnnoucementListPageT({super.key});

  @override
  State<AnnoucementListPageT> createState() => _AnnoucementListPageTState();
}

class _AnnoucementListPageTState extends State<AnnoucementListPageT> {
  // Sample data with details
  List<AnnouncementItem> announcements = [
    AnnouncementItem(
      id: '1',
      header: 'Assignment 1: Basic Programming',
      date: '8 Aug',
      detail: 'Please submit your first assignment on basic programming concepts. The assignment should include fundamental programming structures, variables, and simple algorithms. Due date is next Friday.',
      type: AnnouncementType.assignment,
      dateTime: DateTime.now(),
    ),
    AnnouncementItem(
      id: '2',
      header: 'Class Schedule Update',
      date: '8 Aug',
      detail: 'There has been a change in our class schedule for next week. Please check the updated timetable on the course website. Classes on Wednesday will be moved to Friday.',
      type: AnnouncementType.announcement,
      dateTime: DateTime.now(),
    ),
    AnnouncementItem(
      id: '3',
      header: 'Quiz 1 Announcement',
      date: '7 Aug',
      detail: 'Quiz 1 will cover chapters 1-3 from the textbook. The quiz will be held during regular class time next Tuesday. Please prepare thoroughly and bring your student ID.',
      type: AnnouncementType.announcement,
      dateTime: DateTime.now().subtract(Duration(days: 1)),
    ),
    AnnouncementItem(
      id: '4',
      header: 'Project Submission Guidelines',
      date: '7 Aug',
      detail: 'All project submissions must follow the specified format. Include proper documentation, code comments, and test cases. Submit via the online portal before midnight on the due date.',
      type: AnnouncementType.assignment,
      dateTime: DateTime.now().subtract(Duration(days: 1)),
    ),
    AnnouncementItem(
      id: '5',
      header: 'Midterm Exam Schedule',
      date: '16 Dec 67',
      detail: 'The midterm examination will be held on December 20th, 2024. The exam will cover all topics discussed in class from weeks 1-8. Please review all lecture materials and assignments.',
      type: AnnouncementType.announcement,
      dateTime: DateTime(2024, 12, 16),
    ),
    AnnouncementItem(
      id: '6',
      header: 'Final Project Assignment',
      date: '16 Dec 67',
      detail: 'Your final project should demonstrate mastery of object-oriented programming concepts. Form teams of 3-4 students and submit your proposal by the end of this month.',
      type: AnnouncementType.assignment,
      dateTime: DateTime(2024, 12, 16),
    ),
  ];

  Map<String, List<AnnouncementItem>> groupAnnouncementsByDate() {
    Map<String, List<AnnouncementItem>> grouped = {};
    
    for (var item in announcements) {
      String groupKey;
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(Duration(days: 1));
      DateTime itemDate = DateTime(item.dateTime.year, item.dateTime.month, item.dateTime.day);
      
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
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 126, 174, 252),
            shape: BoxShape.circle,
          ),
          child: Image.asset('assets/images/assignment_icon.png', scale: 1.2,)
        );
      case AnnouncementType.announcement:
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 232, 186),
            shape: BoxShape.circle,
          ),
          child: Image.asset('assets/images/annoucement_icon.png')
        );
    }
  }

  // ฟังก์ชันแสดง popup รายละเอียด
  void showAnnouncementDetail(AnnouncementItem item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
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
                // Header section
                Container(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05,vertical: MediaQuery.of(context).size.height*0.02),
                  decoration: BoxDecoration(
                    color: item.type == AnnouncementType.assignment 
                        ? Color.fromARGB(255, 126, 174, 252)
                        : Color.fromARGB(255, 255, 232, 186),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  child: Row(
                    children: [
                      item.type == AnnouncementType.announcement
                      ? Image.asset('assets/images/annoucement_icon.png')
                      : Image.asset('assets/images/assignment_icon.png', scale: 1.2,),
                      SizedBox(width: MediaQuery.of(context).size.width*0.03,),
                      Expanded(
                        child: Text(
                          item.header,
                          style: TextWidgetStyles.text16LatoSemibold().copyWith(
                            color: item.type == AnnouncementType.announcement
                            ? AppColors.textDarkblue
                            : Colors.white
                          ),
                        ),
                      ),
                      Text(
                        item.date,
                        style: TextWidgetStyles.text12LatoSemibold().copyWith(
                          color: item.type == AnnouncementType.announcement
                          ? AppColors.textDarkblue
                          : Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Detail section
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail',
                        style: TextWidgetStyles.text16LatoSemibold().copyWith(
                          color: AppColors.textDarkblue,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        item.detail,
                        style: TextWidgetStyles.text14LatoSemibold().copyWith(
                          color: Colors.grey[700],
                          height: 1.5,
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
  }

  Widget buildAnnouncementItem(AnnouncementItem item) {
    return GestureDetector(
      onTap: () {
        showAnnouncementDetail(item); // แสดง popup แทนการขยาย
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.textDarkblue, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: buildAnnouncementIcon(item.type),
          title: Text(
            item.header,
            style: TextWidgetStyles.text14LatoSemibold().copyWith(
              color: AppColors.textDarkblue,
            ),
          ),
          trailing: Text(
            item.date,
            style: TextWidgetStyles.text12LatoSemibold().copyWith(
              color: Colors.grey[600],
            ),
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
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            dateLabel,
            style: TextWidgetStyles.text16LatoSemibold().copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
        ...items.map((item) => buildAnnouncementItem(item)).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<AnnouncementItem>> groupedAnnouncements = groupAnnouncementsByDate();
    
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
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Column(
                children: [
                  Text(
                    "USER EXPERIENCE AND USER INTERFACE DESIGN",
                    style: TextWidgetStyles.text14LatoSemibold().copyWith(
                      color: AppColors.background,
                    ),
                  ),
                  Text(
                    "SEC 1",
                    style: TextWidgetStyles.text12LatoSemibold().copyWith(
                      color: AppColors.background,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: groupedAnnouncements.keys.length,
        itemBuilder: (context, index) {
          String dateKey = groupedAnnouncements.keys.elementAt(index);
          List<AnnouncementItem> items = groupedAnnouncements[dateKey]!;
          
          return buildDateSection(dateKey, items);
        },
      ),
    );
  }
}