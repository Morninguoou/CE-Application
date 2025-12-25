import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/study_plan.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/service/study_plan_api.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class StudyPlanPageS extends StatefulWidget {
  const StudyPlanPageS({super.key});

  @override
  State<StudyPlanPageS> createState() => _StudyPlanPageSState();
}

class _StudyPlanPageSState extends State<StudyPlanPageS> {
  final StudyPlanService _service = StudyPlanService();
  String _accId = '';
  Future<StudyPlanResponse>? _futureMain;
  Future<StudyPlanResponse>? _futureFiltered;
  
  Map<String, bool> expandedSections = {
    'หมวดวิชาศึกษาทั่วไป': false,
    'หมวดวิชาเฉพาะ': false,
    'หมวดวิชาเลือกเสรี': false,
  };

  Map<String, String?> selectedSubCategories = {
    'หมวดวิชาเฉพาะ': null,
  };

  // Map filter type
  final Map<String, String> filterTypeMap = {
    'วิชาบังคับ': 'required',
    'วิชาเลือกเฉพาะสาขา': 'major_elective',
    'วิชาบังคับเลือก': 'required_elective',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.read<SessionProvider>().accId;
    final accId = '65010782'; // For test API

    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
      _futureMain = _service.getStudyPlan(accId);
      _futureFiltered = null;
    }
  }

  void _applyFilter(String sectionTitle, String? filter) {
    if (sectionTitle != 'หมวดวิชาเฉพาะ' || filter == null) {
      setState(() {
        _futureFiltered = null;
      });
      return;
    }

    final filterType = filterTypeMap[filter];
    if (filterType != null) {
      setState(() {
        _futureFiltered = _service.getStudyPlan(_accId, filter: filterType);
      });
    }
  }

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
  
                _buildFilterOption('วิชาบังคับ', selectedSubCategories[sectionTitle]),
                const SizedBox(height: 12),
                _buildFilterOption('วิชาเลือกเฉพาะสาขา', selectedSubCategories[sectionTitle]),
                const SizedBox(height: 12),
                _buildFilterOption('วิชาบังคับเลือก', selectedSubCategories[sectionTitle]),
                const SizedBox(height: 24),
  
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedSubCategories[sectionTitle] = null;
                            _applyFilter(sectionTitle, null);
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
                          _applyFilter(sectionTitle, selectedSubCategories[sectionTitle]);
                          Navigator.of(context).pop();
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
      _applyFilter(sectionTitle, null);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Study Plan',
        subtitle: 'Student ID : $_accId',
        includeBackButton: true,
      ),
      body: FutureBuilder<StudyPlanResponse>(
        future: _futureMain,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.blue,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'เกิดข้อผิดพลาด',
                    style: TextWidgetStyles.text16LatoBold(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: TextWidgetStyles.text14LatoMedium(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureMain = _service.getStudyPlan(_accId);
                        _futureFiltered = null;
                      });
                    },
                    child: const Text('ลองใหม่อีกครั้ง'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('ไม่พบข้อมูล'),
            );
          }

          final mainData = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // หมวดวิชาศึกษาทั่วไป
                    if (mainData.genedCourses != null)
                      _buildSection('หมวดวิชาศึกษาทั่วไป', mainData.genedCourses!),
                    
                    // หมวดวิชาเฉพาะ (แสดงแบบปกติหรือแบบ filtered)
                    if (_futureFiltered != null)
                      FutureBuilder<StudyPlanResponse>(
                        future: _futureFiltered,
                        builder: (context, filteredSnapshot) {
                          if (filteredSnapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.blue,
                                ),
                              ),
                            );
                          }

                          if (filteredSnapshot.hasError || !filteredSnapshot.hasData) {
                            // ถ้า error ให้แสดงแบบปกติ
                            if (mainData.majorCourses != null) {
                              return _buildSection('หมวดวิชาเฉพาะ', mainData.majorCourses!);
                            }
                            return const SizedBox.shrink();
                          }

                          return _buildFilteredMajorSection(
                            filteredSnapshot.data!, 
                            mainData.majorCourses?.totalCradits ?? '0'
                          );
                        },
                      )
                    else if (mainData.majorCourses != null)
                      _buildSection('หมวดวิชาเฉพาะ', mainData.majorCourses!),
                    
                    // หมวดวิชาเลือกเสรี
                    if (mainData.freeElectiveCourses != null)
                      _buildSection('หมวดวิชาเลือกเสรี', mainData.freeElectiveCourses!),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              
              // Total Credit Card
              Container(
                width: double.infinity,
                margin: EdgeInsets.zero,
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
                      Image.asset('assets/images/totalCredit_icon.png', scale: 0.8),
                      const SizedBox(width: 5),
                      Text(
                        'Total Credit',
                        style: TextWidgetStyles.text16LatoBold()
                            .copyWith(color: AppColors.textDarkblue),
                      ),
                      const Spacer(),
                      Text(
                        '${mainData.earnedTotalCradits}/${mainData.totalCourseCradits}',
                        style: TextWidgetStyles.text16LatoBold()
                            .copyWith(color: AppColors.textDarkblue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        onHomeTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePageS()),
          );
        },
        onGptTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CeGptPage()),
          );
        },
        onNotificationTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationPageS()),
          );
        },
        onProfileTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePageS()),
          );
        },
      ),
    );
  }

  Widget _buildNormalView(StudyPlanResponse data) {
    final sections = <String, CourseCategory?>{
      'หมวดวิชาศึกษาทั่วไป': data.genedCourses,
      'หมวดวิชาเฉพาะ': data.majorCourses,
      'หมวดวิชาเลือกเสรี': data.freeElectiveCourses,
    };

    return Column(
      children: sections.entries
          .where((entry) => entry.value != null)
          .map((entry) => _buildSection(entry.key, entry.value!))
          .toList(),
    );
  }

  Widget _buildFilteredView(StudyPlanResponse data) {
    final selectedFilter = selectedSubCategories['หมวดวิชาเฉพาะ'];
    
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
          InkWell(
            onTap: () {
              setState(() {
                expandedSections['หมวดวิชาเฉพาะ'] = 
                    !(expandedSections['หมวดวิชาเฉพาะ'] ?? false);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'หมวดวิชาเฉพาะ',
                          style: TextWidgetStyles.text16NotoSansSemibold()
                              .copyWith(color: AppColors.textDarkblue),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${data.earnedCradits}/${data.totalCradits} Credits',
                            style: TextWidgetStyles.text14LatoMedium()
                                .copyWith(color: AppColors.skyblue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${data.totalCradits} Credits',
                    style: TextWidgetStyles.text14LatoMedium()
                        .copyWith(color: AppColors.textDarkblue),
                  ),
                  const SizedBox(width: 5.0),
                  Transform.rotate(
                    angle: (expandedSections['หมวดวิชาเฉพาะ'] ?? false) ? 3.14159 : 0,
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
          if (expandedSections['หมวดวิชาเฉพาะ'] ?? false) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _showFilterDialog('หมวดวิชาเฉพาะ'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
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
                                style: TextWidgetStyles.text11NotoSansSemibold()
                                    .copyWith(color: AppColors.textDarkblue),
                              ),
                              if (selectedFilter != null) ...[
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: () => _clearFilter('หมวดวิชาเฉพาะ'),
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
                      Text(
                        '${data.earnedCradits}/${data.totalCradits} Credits',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.skyblue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (data.data != null)
                    ...data.data!.map((category) => _buildFilteredCategory(category)).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  // ฟังก์ชันใหม่สำหรับแสดงหมวดวิชาเฉพาะแบบ filtered
  Widget _buildFilteredMajorSection(StudyPlanResponse filteredData, String totalCreditsFromMain) {
    final isExpanded = expandedSections['หมวดวิชาเฉพาะ'] ?? false;
    final selectedFilter = selectedSubCategories['หมวดวิชาเฉพาะ'];
    
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
          InkWell(
            onTap: () {
              setState(() {
                expandedSections['หมวดวิชาเฉพาะ'] = !isExpanded;
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
                          'หมวดวิชาเฉพาะ',
                          style: TextWidgetStyles.text16NotoSansSemibold()
                              .copyWith(color: AppColors.textDarkblue),
                        ),
                        if (!isExpanded)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${filteredData.earnedCradits}/${filteredData.totalCradits} Credits',
                              style: TextWidgetStyles.text14LatoMedium()
                                  .copyWith(color: AppColors.skyblue),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '$totalCreditsFromMain Credits',
                    style: TextWidgetStyles.text14LatoMedium()
                        .copyWith(color: AppColors.textDarkblue),
                  ),
                  const SizedBox(width: 5.0),
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
          if (isExpanded) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _showFilterDialog('หมวดวิชาเฉพาะ'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
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
                                style: TextWidgetStyles.text11NotoSansSemibold()
                                    .copyWith(color: AppColors.textDarkblue),
                              ),
                              if (selectedFilter != null) ...[
                                const SizedBox(width: 4),
                                InkWell(
                                  onTap: () => _clearFilter('หมวดวิชาเฉพาะ'),
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
                      Text(
                        '${filteredData.earnedCradits}/${filteredData.totalCradits} Credits',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.skyblue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (filteredData.data != null)
                    ...filteredData.data!.map((category) => _buildFilteredCategory(category)).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildFilteredCategory(FilteredCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            category.title,
            style: TextWidgetStyles.text14NotoSansSemibold()
                .copyWith(color: AppColors.textBlue),
            textAlign: TextAlign.center,
          ),
        ),
        ...category.data.map((course) => _buildCourseItem(course)).toList(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildSection(String title, CourseCategory category) {
    final isExpanded = expandedSections[title] ?? false;
    final totalCredits = int.tryParse(category.totalCradits) ?? 0;
    final completedCredits = int.tryParse(category.earnedCredits) ?? 0;

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
                          style: TextWidgetStyles.text16NotoSansSemibold()
                              .copyWith(color: AppColors.textDarkblue),
                        ),
                        if (!isExpanded || completedCredits == 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '$completedCredits/$totalCredits Credits',
                              style: TextWidgetStyles.text14LatoMedium()
                                  .copyWith(color: AppColors.skyblue),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '$totalCredits Credits',
                    style: TextWidgetStyles.text14LatoMedium()
                        .copyWith(color: AppColors.textDarkblue),
                  ),
                  const SizedBox(width: 5.0),
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
          if (isExpanded && category.data.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // แสดงปุ่ม Filter เฉพาะหมวดวิชาเฉพาะ
                  if (title == 'หมวดวิชาเฉพาะ') ...[
                    Row(
                      children: [
                        InkWell(
                          onTap: () => _showFilterDialog(title),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.yellow,
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
                                  selectedSubCategories[title] ?? 'Filter',
                                  style: TextWidgetStyles.text11NotoSansSemibold()
                                      .copyWith(color: AppColors.textDarkblue),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (completedCredits > 0)
                          Text(
                            '$completedCredits/$totalCredits Credits',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.skyblue,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  ...category.data.map((course) => _buildCourseItem(course)).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildCourseItem(Course course) {
    final isCompleted = course.status;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              course.subjectId,
              style: TextWidgetStyles.text13LatoMedium().copyWith(
                color: isCompleted ? AppColors.textDarkblue : AppColors.skyblue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              course.subjectNameEn,
              style: TextWidgetStyles.text13LatoMedium().copyWith(
                color: isCompleted ? AppColors.textDarkblue : AppColors.skyblue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${course.credit}',
            style: TextWidgetStyles.text13LatoMedium().copyWith(
              color: isCompleted ? AppColors.textDarkblue : AppColors.skyblue,
            ),
          ),
        ],
      ),
    );
  }
}