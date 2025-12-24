import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/subject_list.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/homePage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/student/profilePage.dart';
import 'package:ce_connect_app/screens/student/subjectDetailPage.dart';
import 'package:ce_connect_app/service/subject_list_api.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class SubjectListPageS extends StatefulWidget {
  const SubjectListPageS({super.key});

  @override
  State<SubjectListPageS> createState() => _SubjectListPageSState();
}

class _SubjectListPageSState extends State<SubjectListPageS> {
  final SubjectListService _service = SubjectListService();
  Future<List<SubjectModel>>? _future;
  String? _accId;

  int totalCredits = 0;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.read<SessionProvider>().accId;
    final accId = '65010782'; // For test API

    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
      _future = _service.getSubjectListStudent(accId);
    }
  }
  
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'This Semester Subjects',includeBackButton: true),
      body: Container(
          padding: EdgeInsets.only(top : screenHeight*0.02, left: screenWidth * 0.04, right: screenWidth * 0.04),
          child: Column(
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/images/book_icon.png',
                  width: 25,
                  height: 25,
                ),
                SizedBox(
                  width: screenWidth * 0.013,
                ),
                Text(
                  'Total Credits',
                  style: TextWidgetStyles.text20LatoSemibold()
                      .copyWith(color: AppColors.textBlue),
                ),
                const Spacer(),
                Text(
                  '$totalCredits',
                  style: TextWidgetStyles.text20LatoSemibold()
                      .copyWith(color: AppColors.red),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<SubjectModel>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
            
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
            
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data'));
                  }
            
                  final subjects = snapshot.data!;
                  
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final sum = subjects.fold<int>(0, (s, e) => s + e.credit);
                    if (totalCredits != sum) {
                      setState(() {
                        totalCredits = sum;
                      });
                    }
                  });

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
            
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubjectDetailPageS(
                                subject: subjects[index],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.only(top: screenHeight * 0.018),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              /// ===== Header (เดิมทุกอย่าง) =====
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.008,
                                  horizontal: screenWidth * 0.04,
                                ),
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? AppColors.skyblue
                                      : AppColors.yellow,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// subjectId
                                    Text(
                                      subject.subjectId,
                                      style: TextWidgetStyles.text16LatoBold()
                                          .copyWith(color: Colors.white),
                                    ),
                                    
                                    /// credit (3-0-6)
                                    Text(
                                      '${subject.credit}'
                                      '(${subject.theoryHr}-${subject.practiceHr}-${subject.selfLearningHr})',
                                      style: TextWidgetStyles.text16LatoBold()
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                                    
                              /// ===== Body (เดิมทุกอย่าง) =====
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.01,
                                  horizontal: screenWidth * 0.04,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// subject name
                                    Text(
                                      subject.nameEn,
                                      style: TextWidgetStyles.text14LatoBold(),
                                    ),
                                    
                                    //todo API ไม่มี sec → เลยคง style เดิม แต่ใส่ placeholder
                                    Text(
                                      ' ',
                                      style: TextWidgetStyles.text12LatoSemibold()
                                          .copyWith(color: AppColors.textDarkblue),
                                    ),
                                    
                                    SizedBox(height: screenHeight * 0.02),
                                    
                                    /// teacher
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            subject.teacherNameEn.join(', '),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
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
            ),
            ],
          ),
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
}