import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/teacher/addEventPage.dart';
import 'package:ce_connect_app/screens/teacher/homePage.dart';
import 'package:ce_connect_app/screens/teacher/profilePage.dart';
import 'package:ce_connect_app/widgets/bottomNavBarT.dart';
import 'package:flutter/material.dart';
import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:ce_connect_app/service/event_T_api.dart';
import 'package:ce_connect_app/models/event_T.dart';
import 'package:intl/intl.dart';

class CalendarPageT extends StatefulWidget {
  const CalendarPageT({Key? key}) : super(key: key);

  @override
  State<CalendarPageT> createState() => _CalendarPageTState();
}

class _CalendarPageTState extends State<CalendarPageT> {
  final EventService _service = EventService();

  List<ApiEventT> events = [];
  bool isLoading = true;

  String? _accId;
  DateTime selectedDate = DateTime.now();

  List<ApiEventT> otherEvents = [];
  bool isOtherLoading = true;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.read<SessionProvider>().accId;
    final accId = 'Jirasak'; // test accId

    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
      _loadTodayEvents(accId);
      _loadOtherEvents(accId);
    }
  }

  Future<void> _loadTodayEvents(String accId) async {
    setState(() => isLoading = true);

    try {
      final data = await _service.fetchEventsByDate(
        accId: accId,
        date: selectedDate,
      );

      setState(() {
        events = data;
      });
    } catch (e) {
      debugPrint("Today load error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadOtherEvents(String accId) async {
    setState(() => isOtherLoading = true);

    try {
      final data = await _service.fetchOtherInvitations(
        accId: accId,
      );

      setState(() {
        otherEvents = data;
      });
    } catch (e) {
      debugPrint("Other load error: $e");
    } finally {
      setState(() => isOtherLoading = false);
    }
  }

  void _onDateSelected(DateTime date) {
    if (_accId == null) return;

    setState(() {
      selectedDate = date;
    });

    _loadTodayEvents(_accId!);
  }

  Future<void> _respondToEvent(ApiEventT event, bool accept) async {
    if (_accId == null) return;

    try {
      await _service.respondToInvitation(
        accId: _accId!,
        eventId: event.id,
        accept: accept,
      );

      // ลบ card ออกจาก list ทันที
      setState(() {
        otherEvents.removeWhere((e) => e.id == event.id);
      });
    } catch (e) {
      debugPrint("Respond error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: DateFormat('MMM, yyyy').format(selectedDate),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            WeekCalendarHeader(
              selectedDate: selectedDate,
              onDateSelected: _onDateSelected,
            ),
            const SizedBox(height: 8),
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
              height: screenHeight * 0.45,
              child: ScheduleSection(
                events: events,
                isLoading: isLoading,
              ),
            ),
            Text(
              'Other Events',
              style: TextWidgetStyles.text20LatoSemibold().copyWith(
                color: AppColors.textDarkblue,
              ),
            ),
            OtherEventsSection(
              events: otherEvents,
              isLoading: isOtherLoading,
              onRespond: _respondToEvent,
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

class WeekCalendarHeader extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeekCalendarHeader({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

    final monday = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );

    final dates = List.generate(
      7,
      (i) => monday.add(Duration(days: i)),
    );

    final todayIndex = selectedDate.weekday - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final date = dates[i];
        final isToday = i == todayIndex;

        return GestureDetector(
          onTap: () => onDateSelected(date),
          child: Column(
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
                  '${date.day}',
                  style: TextStyle(
                    color: isToday ? Colors.white : AppColors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ScheduleSection extends StatelessWidget {
  final List<ApiEventT> events;
  final bool isLoading;

  const ScheduleSection({
    super.key,
    required this.events,
    required this.isLoading,
  });

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
            // ===== LEFT TIME COLUMN =====
            Container(
              width: screenWidth * 0.15,
              height: screenHeight * 0.43,
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
              child: isLoading
                  ? const SizedBox()
                  : Column(
                      children: events.map((e) {
                        final start =
                            DateFormat('HH:mm').format(e.start);
                        final end =
                            DateFormat('HH:mm').format(e.end);

                        return TimeBlock("$start\n$end");
                      }).toList(),
                    ),
            ),

            SizedBox(width: screenWidth * 0.02),
            Container(
                width: 1,
                height: screenHeight * 0.45,
                color: Colors.grey.shade300),

            // ===== RIGHT EVENT CARDS =====
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        ...events.map((e) {
                          return EventCard(
                            title: e.name,
                            location: e.location,
                          );
                        }).toList(),
                        const AddEventButton(),
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

    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.1,
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

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEventPage()));
      },
      child: Container(
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
      ),
    );
  }
}

class OtherEventsSection extends StatelessWidget {
  final List<ApiEventT> events;
  final bool isLoading;
  final Function(ApiEventT event, bool accept) onRespond;

  const OtherEventsSection({
    super.key,
    required this.events,
    required this.isLoading,
    required this.onRespond,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (events.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text("No other events"),
        ),
      );
    }

    return Expanded(
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        children: events.map((e) {
          final dateStr =
              DateFormat('dd MMM yyyy').format(e.start);
          final timeStr =
              "${DateFormat('HH:mm').format(e.start)} - ${DateFormat('HH:mm').format(e.end)}";

          return OtherEventCard(
            title: e.name,
            date: dateStr,
            time: timeStr,
            onAccept: () => onRespond(e, true),
            onDeny: () => onRespond(e, false),
          );
        }).toList(),
      ),
    );
  }
}

class OtherEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final VoidCallback onAccept;
  final VoidCallback onDeny;

  const OtherEventCard({
    required this.title,
    required this.date,
    required this.time,
    required this.onAccept,
    required this.onDeny,
    super.key,
  });

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
          Text(
            title,
            style: TextWidgetStyles.text14NotoSansSemibold(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(date, style: TextWidgetStyles.text10LatoSemibold()),
          Text(time, style: TextWidgetStyles.text10LatoSemibold()),
          SizedBox(height: screenHeight * 0.035),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onDeny,
                child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Deny',
                        style: TextWidgetStyles.text11NotoSansSemibold()
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Icon(Icons.close, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: onAccept,
                child: Container(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Accept',
                        style: TextWidgetStyles.text11NotoSansSemibold()
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
