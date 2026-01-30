import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/teacher/homePage.dart';
import 'package:ce_connect_app/screens/teacher/profilePage.dart';
import 'package:ce_connect_app/widgets/bottomNavBarT.dart';
import 'package:flutter/material.dart';
import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/widgets/appBar.dart';

class CalendarPageT extends StatefulWidget {
  const CalendarPageT({Key? key}) : super(key: key);

  @override
  State<CalendarPageT> createState() => _CalendarPageTState();
}

class _CalendarPageTState extends State<CalendarPageT> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Dec, 2024',
        includeBackButton: true,
        arrowBackColor: AppColors.textDarkblue,
        backgroundColor: AppColors.background,
        titleColor: AppColors.textDarkblue,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
        ),
        child: Column(
          children:[
            WeekCalendarHeader(),
            SizedBox(height: 8),
            Row(
              children: [
                SizedBox(width: screenWidth * 0.01),
                Image.asset(
                  'assets/images/calendar_icon.png',
                  width: 22,
                  height: 22,
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Schedule Today',
                  style: TextWidgetStyles.text20LatoSemibold().copyWith(color: AppColors.textDarkblue),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.48,
              child: ScheduleSection(),
            ),
            OtherEventsSection(),
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

class WeekCalendarHeader extends StatelessWidget {
  const WeekCalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    final dates = [16, 17, 18, 19, 20, 21, 22];
    final todayIndex = 3;

    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final isToday = i == todayIndex;
        return Column(
          children: [
            Text(
              days[i],
              style: TextWidgetStyles.text14LatoSemibold().copyWith(
                color: AppColors.blue
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isToday ? AppColors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Text(
                '${dates[i]}',
                style: TextStyle(
                  color: isToday ? Colors.white : AppColors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ScheduleSection extends StatelessWidget {
  const ScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth * 0.15,
              height: screenHeight * 0.46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.lightblue,
                    AppColors.skyblue,
                  ],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                children: const [
                  TimeBlock('09:00\n12:00'),
                  TimeBlock('13:00\n16:00'),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Container(width: 1, height: screenHeight * 0.48, color: Colors.grey.shade300),
            const Expanded(
              child: Column(
                children: [
                  EventCard(
                    title: 'INTRODUCTION TO CLOUD\nARCHITECTURE',
                    location: 'ECC - 810',
                  ),
                  EventCard(
                    title: 'INTRODUCTION TO CLOUD\nARCHITECTURE PRACTICE',
                    location: 'ECC - 810',
                  ),
                  AddEventButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeBlock extends StatelessWidget {
  final String text;
  const TimeBlock(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextWidgetStyles.text14LatoBold().copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String location;

  const EventCard({
    required this.title,
    required this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(left: screenWidth * 0.02, right: 0, top: 0, bottom: screenHeight * 0.015),
      padding: EdgeInsets.only(left: screenWidth * 0.03, right: screenWidth * 0.03, top: screenHeight * 0.01, bottom: screenHeight * 0.035),
      decoration: BoxDecoration(
        color: AppColors.lightblue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextWidgetStyles.text13LatoBold().copyWith(
                color: Colors.white,
              )),
          SizedBox(height: screenHeight * 0.005),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white, size: 20),
              SizedBox(width: screenWidth * 0.01),
              Text(
                location, 
                style: TextWidgetStyles.text12LatoMedium().copyWith(
                  color: Colors.white,
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddEventButton extends StatelessWidget {
  const AddEventButton({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(left: screenWidth * 0.02, right: 0, top: 0, bottom: screenHeight * 0.015),
      height: screenHeight * 0.08,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 232, 186),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline_rounded, color: Color.fromARGB(255, 41, 157, 143), size: 24),
            SizedBox(width: 8),
            Text(
              'Add More Events',
              style: TextWidgetStyles.text14LatoMedium().copyWith(
                color: AppColors.textDarkblue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtherEventsSection extends StatelessWidget {
  const OtherEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        children: const [
          OtherEventCard(title: 'ประชุมกรรมการ', date: '16 Dec 2024', time: '10:00 - 12:00'),
          OtherEventCard(title: 'อัพเดทงานกลุ่ม CE68-26', date: '17 Dec 2024', time: '14:00 - 15:00'),
        ],
      ),
    );
  }
}

class OtherEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  const OtherEventCard({required this.title,required this.date, required this.time, super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.45,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextWidgetStyles.text14NotoSansSemibold()),
          SizedBox(height: screenHeight * 0.015),
          Text(date, style: TextWidgetStyles.text12LatoMedium().copyWith(color: Colors.grey)),
          Text(time, style: TextWidgetStyles.text12LatoMedium().copyWith(color: Colors.grey)),
          SizedBox(height: screenHeight * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenWidth * 0.19,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.01,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 231, 150, 150),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text('Deny', style: TextWidgetStyles.text11NotoSansSemibold().copyWith(color: Colors.white)),
                    SizedBox(width: screenWidth * 0.01),
                    Icon(Icons.close, color: Colors.white, size: 20),
                  ],
                ),
              ),
              Container(
                width: screenWidth * 0.19,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.01,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 111, 213, 184),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                    SizedBox(width: screenWidth * 0.01),
                    Text('Accept', style: TextWidgetStyles.text11NotoSansSemibold().copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
