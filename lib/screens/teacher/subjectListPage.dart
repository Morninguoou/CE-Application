import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/course.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/teacher/annoucementListPage.dart';
import 'package:ce_connect_app/screens/teacher/homePage.dart';
import 'package:ce_connect_app/screens/teacher/profilePage.dart';
import 'package:ce_connect_app/service/teacher_course.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/widgets/bottomNavBarT.dart';
import 'package:flutter/material.dart';

class SubjectListPageT extends StatefulWidget {
  const SubjectListPageT({super.key});

  @override
  State<SubjectListPageT> createState() => _SubjectListPageTState();
}

class _SubjectListPageTState extends State<SubjectListPageT> {
  String? _accId;
  List<CourseModel> courses = [];
  bool isLoading = true;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.read<SessionProvider>().accId;
    final accId = '65010782';
    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
      fetchCourses();
    }
  }

  Future<void> fetchCourses() async {
    try {
      final result = await CourseService().getCourseList(_accId!);
  
      setState(() {
        courses = result;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'My Subjects',includeBackButton: true),
      body: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        :Container(
          padding: EdgeInsets.only(top : screenHeight*0.02, left: screenWidth * 0.04, right: screenWidth * 0.04),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnoucementListPageT(courseId: course.courseId),
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
                                  Text(course.subjectId,
                                      style: TextWidgetStyles.text16LatoBold()
                                          .copyWith(color: Colors.white)),
                                  Text('${course.credit}(${course.theoryHr}-${course.practiceHr}-${course.selfLearnHr})',
                                      style: TextWidgetStyles.text16LatoBold()
                                          .copyWith(color: Colors.white)),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenWidth * 0.04,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          course.name,
                                          style: TextWidgetStyles.text14LatoBold(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight*0.025,),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 5.0,vertical: 3.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: index % 2 == 0
                                            ? AppColors.lightblue
                                            : AppColors.yellow,)
                                        ),
                                        child: Text('Sec : ${course.section}',style: TextWidgetStyles.text10LatoSemibold().copyWith(color: AppColors.textDarkblue))
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBarT(
        onHomeTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageT()));
        },
        onGptTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CeGptPage()));
        },
        onProfileTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePageT()));
        },
      ),
      );
  }
}