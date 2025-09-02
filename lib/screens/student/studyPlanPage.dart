import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class StudyPlanPageS extends StatefulWidget {
  const StudyPlanPageS({super.key});

  @override
  State<StudyPlanPageS> createState() => _StudyPlanPageSState();
}

class _StudyPlanPageSState extends State<StudyPlanPageS> {
  // เก็บสถานะการขยายของแต่ละหมวด
  Map<String, bool> expandedSections = {
    'หมวดวิชาศึกษาทั่วไป': false,
    'หมวดวิชาเฉพาะ': false,
    'หมวดวิชาเลือกเสรี': false,
  };

  // เก็บหมวดย่อยที่เลือกในแต่ละหมวด
  Map<String, String?> selectedSubCategories = {
    'หมวดวิชาเฉพาะ': null,
  };

  // ข้อมูลหมวดย่อยในหมวดวิชาเฉพาะ
  final Map<String, String> subCategories = {
    'วิชาบังคับ': 'วิชาบังคับ',
    'วิชาเลือกเฉพาะสาขา': 'วิชาเลือกเฉพาะสาขา',
    'วิชาบังคับเลือก': 'วิชาบังคับเลือก',
  };

  // ข้อมูลรายวิชาในแต่ละหมวด
  final Map<String, Map<String, dynamic>> sections = {
    'หมวดวิชาศึกษาทั่วไป': {
      'totalCredits': 30,
      'completedCredits': 0,
      'courses': [],
    },
    'หมวดวิชาเฉพาะ': {
      'totalCredits': 100,
      'completedCredits': 58,
      'courses': [
        {'code': '01076140', 'name': 'CALCULUS 1', 'credits': 3, 'completed': true, 'category': 'วิชาบังคับ'},
        {'code': '01076141', 'name': 'CALCULUS 2', 'credits': 3, 'completed': true, 'category': 'วิชาบังคับ'},
        {'code': '90644007', 'name': 'ELEMENTARY DIFFERENTIAL EQUATIONS AND LINEAR ALGEBRA', 'credits': 3, 'completed': false, 'category': 'วิชาบังคับ'},
        {'code': '01076253', 'name': 'PROBABILITY AND STATISTICS', 'credits': 3, 'completed': false, 'category': 'วิชาบังคับ'},
        {'code': '01076101', 'name': 'INTRODUCTION TO COMPUTER ENGINEERING', 'credits': 3, 'completed': true, 'category': 'วิชาบังคับ'},
        {'code': '01076103', 'name': 'PROGRAMMING FUNDAMENTAL', 'credits': 2, 'completed': true, 'category': 'วิชาบังคับ'},
        {'code': '01076104', 'name': 'PROGRAMMING PROJECT', 'credits': 1, 'completed': true, 'category': 'วิชาบังคับ'},
        {'code': '01076107', 'name': 'CIRCUITS AND ELECTRONICS', 'credits': 3, 'completed': false, 'category': 'วิชาบังคับ'},
        
        // วิชาเลือกเฉพาะสาขา - สมองกลฝังตัวและอินเตอร์เน็ตในทุกสิ่ง
        {'code': '01076052', 'name': 'REAL-TIME EEMBEDDED SYSTEMS', 'credits': 3, 'completed': false, 'category': 'วิชาเลือกเฉพาะสาขา', 'subCategory': 'สมองกลฝังตัวและอินเตอร์เน็ตในทุกสิ่ง'},
        {'code': '01076053', 'name': 'INTERNET OF THING AND SMART SYSTEMS', 'credits': 3, 'completed': false, 'category': 'วิชาเลือกเฉพาะสาขา', 'subCategory': 'สมองกลฝังตัวและอินเตอร์เน็ตในทุกสิ่ง'},
        
        // วิชาเลือกเฉพาะสาขา - การพัฒนาซอฟต์แวร์
        {'code': '01076036', 'name': 'USER EXPERIENCE AND USER INTERFACE DESIGN', 'credits': 2, 'completed': true, 'category': 'วิชาเลือกเฉพาะสาขา', 'subCategory': 'การพัฒนาซอฟต์แวร์'},
        {'code': '01076037', 'name': 'USER EXPERIENCE AND USER INTERFACE PROJECT', 'credits': 1, 'completed': true, 'category': 'วิชาเลือกเฉพาะสาขา', 'subCategory': 'การพัฒนาซอฟต์แวร์'},
        {'code': '01076035', 'name': 'SOFTWARE DEVELOPMENT PROCESS IN PRACTICE', 'credits': 3, 'completed': false, 'category': 'วิชาเลือกเฉพาะสาขา', 'subCategory': 'การพัฒนาซอฟต์แวร์'},
        
        // วิชาบังคับเลือก - โครงสร้างพื้นฐานของระบบและระบบเครือข่าย
        {'code': '01076043', 'name': 'INTRODUCTION TO CLOUD ARCHITECTURE', 'credits': 2, 'completed': true, 'category': 'วิชาเลือกเฉพาะสาขา', 'subCategory': 'โครงสร้างพื้นฐานของระบบและระบบเครือข่าย'},
        {'code': '01076043', 'name': 'INTRODUCTION TO CLOUD ARCHITECTURE IN PRACTICE', 'credits': 1, 'completed': false, 'category': 'วิชาเลือกเฉพาะสาขา', 'subCategory': 'โครงสร้างพื้นฐานของระบบและระบบเครือข่าย'},
        {'code': '01076042', 'name': 'INFORMATION AND COMPUTER SECURITY', 'credits': 3, 'completed': false, 'category': 'วิชาเลือกเฉพาะสาขา', 'subCategory': 'โครงสร้างพื้นฐานของระบบและระบบเครือข่าย'},
      ],
    },
    'หมวดวิชาเลือกเสรี': {
      'totalCredits': 6,
      'completedCredits': 0,
      'courses': [],
    },
  };

  void _showFilterDialog(String sectionTitle) {
    if (sectionTitle != 'หมวดวิชาเฉพาะ') return;
  
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.filter_list,
                      color: AppColors.textDarkblue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Filter',
                      style: TextWidgetStyles.text16LatoBold().copyWith(
                        color: AppColors.textDarkblue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
  
                // ปุ่มเลือกหมวดย่อย
                _buildFilterOption('วิชาบังคับ', selectedSubCategories[sectionTitle]),
                const SizedBox(height: 12),
                _buildFilterOption('วิชาเลือกเฉพาะสาขา', selectedSubCategories[sectionTitle]),
                const SizedBox(height: 12),
                _buildFilterOption('วิชาบังคับเลือก', selectedSubCategories[sectionTitle]),
                const SizedBox(height: 24),
  
                // แถบปุ่ม Clear / Apply
                Row(
                  children: [
                    // CLEAR
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedSubCategories[sectionTitle] = null;
                          });
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Clear filter',
                          style: TextWidgetStyles.text14LatoBold().copyWith(
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Apply filter',
                          style: TextWidgetStyles.text14LatoBold().copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _clearFilter(String sectionTitle) {
    setState(() {
      selectedSubCategories[sectionTitle] = null;
    });
  }


  Widget _buildFilterOption(String option, String? selectedOption) {
    final isSelected = selectedOption == option;
    
    return InkWell(
      onTap: () {
        setState(() {
          if (selectedSubCategories['หมวดวิชาเฉพาะ'] == option) {
            selectedSubCategories['หมวดวิชาเฉพาะ'] = null;
          } else {
            selectedSubCategories['หมวดวิชาเฉพาะ'] = option;
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : AppColors.background,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.yellow : AppColors.skyblue,
          ),
        ),
        child: Text(
          option,
          style: TextWidgetStyles.text14NotoSansMedium().copyWith(
            color: AppColors.textDarkblue,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List _getFilteredCourses(String sectionTitle, List courses) {
    if (sectionTitle != 'หมวดวิชาเฉพาะ') return courses;
    
    final selectedFilter = selectedSubCategories[sectionTitle];
    if (selectedFilter == null) return courses;
    
    return courses.where((course) => course['category'] == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Study Plan',
        includeBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // แต่ละหมวดวิชา
                ...sections.entries.map((entry) => 
                  _buildSection(entry.key, entry.value)
                ).toList(),
                
                const SizedBox(height: 100), // เพิ่มพื้นที่ให้เลื่อนได้
              ],
            ),
          ),
          
          // Total Credit Card - ตรึงด้านล่าง
          Container(
            width: double.infinity,
            margin: EdgeInsets.zero, // ติดขอบจอ
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3CD),
              border: Border(
                top: BorderSide(color: Color(0xFFFFE69C)),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Image.asset('assets/images/totalCredit_icon.png',scale: 0.8,),
                  const SizedBox(width: 5),
                  Text(
                    'Total Credit',
                    style: TextWidgetStyles.text16LatoBold().copyWith(color: AppColors.textDarkblue)
                  ),
                  const Spacer(),
                  Text(
                    '80/136',
                    style: TextWidgetStyles.text16LatoBold().copyWith(color: AppColors.textDarkblue),
                  ),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildSection(String title, Map<String, dynamic> data) {
    final isExpanded = expandedSections[title] ?? false;
    final totalCredits = data['totalCredits'];
    final completedCredits = data['completedCredits'];
    final allCourses = data['courses'] as List;
    final filteredCourses = _getFilteredCourses(title, allCourses);
    final selectedFilter = selectedSubCategories[title];

    // คำนวณ credits ของวิชาที่กรอง
    int filteredCompletedCredits = completedCredits;
    int filteredTotalCredits = totalCredits;
    
    if (selectedFilter != null && title == 'หมวดวิชาเฉพาะ') {
      filteredCompletedCredits = filteredCourses.where((course) => course['completed']).fold(0, (sum, course) => sum + (course['credits'] as int));
      filteredTotalCredits = filteredCourses.fold(0, (sum, course) => sum + (course['credits'] as int));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header ของแต่ละหมวด
          InkWell(
            onTap: () {
              setState(() {
                expandedSections[title] = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextWidgetStyles.text16NotoSansSemibold().copyWith(color: AppColors.textDarkblue),
                        ),
                        if (expandedSections[title] == false || completedCredits == 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '$completedCredits/$totalCredits Credits',
                              style: TextWidgetStyles.text14LatoMedium().copyWith(color: AppColors.skyblue),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '$totalCredits Credits',
                    style: TextWidgetStyles.text14LatoMedium().copyWith(color: AppColors.textDarkblue)
                  ),
                  SizedBox(width: 5.0,),
                  Transform.rotate(
                    angle: isExpanded ? 3.14159 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textDarkblue,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // รายการวิชาที่ขยายออกมา
          if (isExpanded && allCourses.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // ปุ่ม Filter
                      InkWell(
                        onTap: () => _showFilterDialog(title),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: selectedFilter != null ? AppColors.yellow : AppColors.yellow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.filter_list,
                                size: 16,
                                color: AppColors.textDarkblue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                selectedFilter ?? 'Filter',
                                style: TextWidgetStyles.text11NotoSansSemibold().copyWith(color: AppColors.textDarkblue)
                              ),
                              if (selectedFilter != null) ...[
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedSubCategories[title] = null;
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: AppColors.textDarkblue,
                                  ),
                                ),
                              ] else ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: Colors.black87,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (completedCredits > 0)
                        Text(
                          selectedFilter != null 
                            ? '$filteredCompletedCredits/$filteredTotalCredits Credits'
                            : '$completedCredits/$totalCredits Credits',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.skyblue,
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // แสดงหมวดย่อยถ้ามีการกรอง
                  if (selectedFilter != null && title == 'หมวดวิชาเฉพาะ') ...[
                    if (selectedFilter == 'วิชาเลือกเฉพาะสาขา') ...[
                      _buildSubCategoryHeader(selectedFilter, filteredCourses),
                      const SizedBox(height: 8),
                    ] else ...[
                      // กรณีเป็น "วิชาบังคับ" หรือ "วิชาบังคับเลือก" ให้แสดงรายการปกติ
                      ...filteredCourses.map((course) => _buildCourseItem(course)).toList(),
                    ],
                  ] else ...[
                    // กรณีไม่เลือก filter ใดๆ ให้แสดงรายการทั้งหมดตามปกติ
                    ...filteredCourses.map((course) => _buildCourseItem(course)).toList(),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubCategoryHeader(String category, List courses) {
    // แยกหมวดย่อยสำหรับหมวดวิชาเลือกเฉพาะสาขา
    if (category == 'วิชาเลือกเฉพาะสาขา') {
      final subCategories = <String, List>{};
      for (var course in courses) {
        final subCat = course['subCategory'];
        if (!subCategories.containsKey(subCat)) {
          subCategories[subCat] = [];
        }
        subCategories[subCat]!.add(course);
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: subCategories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  entry.key,
                  style: TextWidgetStyles.text14NotoSansSemibold().copyWith(
                    color: AppColors.textBlue
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ...entry.value.map((course) => _buildCourseItem(course)).toList(),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      );
    }
    
    // สำหรับหมวดอื่นๆ ที่มีหมวดย่อย
    if (category == 'วิชาบังคับเลือก') {
      final subCategories = <String, List>{};
      for (var course in courses) {
        final subCat = course['subCategory'] ?? 'อื่นๆ';
        if (!subCategories.containsKey(subCat)) {
          subCategories[subCat] = [];
        }
        subCategories[subCat]!.add(course);
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: subCategories.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  entry.key,
                  style: TextWidgetStyles.text14LatoMedium().copyWith(
                    color: AppColors.skyblue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...entry.value.map((course) => _buildCourseItem(course)).toList(),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      );
    }
    
    return Container();
  }

  Widget _buildCourseItem(Map<String, dynamic> course) {
    final isCompleted = course['completed'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              course['code'],
              style: TextWidgetStyles.text13LatoMedium().copyWith(color: isCompleted ? AppColors.textDarkblue : AppColors.skyblue)
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              course['name'],
              style: TextWidgetStyles.text13LatoMedium().copyWith(color: isCompleted ? AppColors.textDarkblue : AppColors.skyblue),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${course['credits']}',
            style: TextWidgetStyles.text13LatoMedium().copyWith(color: isCompleted ? AppColors.textDarkblue : AppColors.skyblue),
          ),
        ],
      ),
    );
  }
}