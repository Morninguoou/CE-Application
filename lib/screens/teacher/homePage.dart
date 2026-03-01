import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/models/chat_notification.dart';
import 'package:ce_connect_app/models/event_T.dart';
import 'package:ce_connect_app/models/homePageT.dart';
import 'package:ce_connect_app/screens/ceGptPage.dart';
import 'package:ce_connect_app/screens/student/notificationPage.dart';
import 'package:ce_connect_app/screens/teacher/calendarPage.dart';
import 'package:ce_connect_app/screens/teacher/chatListPage.dart';
import 'package:ce_connect_app/screens/teacher/chatPage.dart';
import 'package:ce_connect_app/screens/teacher/profilePage.dart';
import 'package:ce_connect_app/service/chat_api.dart';
import 'package:ce_connect_app/service/event_T_api.dart';
import 'package:ce_connect_app/widgets/bottomNavBarT.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePageT extends StatefulWidget {
  const HomePageT({super.key});

  @override
  State<HomePageT> createState() => _HomePageTState();
}

class _HomePageTState extends State<HomePageT> {

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();

  final EventService _service = EventService();
  String? _accId;
  bool isLoading = false;

  final ChatService _chatService = ChatService();
  List<ChatNotification> chatNotiList = [];
  bool isChatLoading = false;

  int unreadCount = 0;
  bool isUnreadLoading = false;

  @override
  void initState() {
    super.initState();
    selectedDate = _dateOnly(DateTime.now());
    currentMonth = _dateOnly(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final accId = context.read<SessionProvider>().accId;
    final accId = 'Thana'; // test accId

    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
      _loadEvents(accId);
      _loadChatNotifications(accId);
      _loadUnreadCount(accId);
    }
  }

  Map<DateTime, List<Event>> events = {};

  Future<void> _loadEvents(String accId) async {
    setState(() => isLoading = true);

    try {
      final apiEvents = await _service.fetchEventsT(accId);
      final converted = _convertApiEvents(apiEvents);

      setState(() {
        events = converted;
      });
    } catch (e) {
      debugPrint("Error loading events: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadChatNotifications(String accId) async {
    setState(() => isChatLoading = true);

    try {
      final data = await _chatService.fetchChatNotifications(accId);
      setState(() {
        chatNotiList = data;
      });
    } catch (e) {
      debugPrint("Error loading chat notifications: $e");
    } finally {
      setState(() => isChatLoading = false);
    }
  }

  Future<void> _loadUnreadCount(String accId) async {
    try {
      final count = await _chatService.fetchUnreadCount(accId);
      setState(() {
        unreadCount = count;
      });
    } catch (e) {
      debugPrint("Error loading unread count: $e");
    }
  }

  Map<DateTime, List<Event>> _convertApiEvents(List<ApiEventT> apiEvents) {
    final Map<DateTime, List<Event>> map = {};

    for (var api in apiEvents) {
      DateTime current = _dateOnly(api.start);
      final endDate = _dateOnly(api.end);

      while (!current.isAfter(endDate)) {
        final timeString = api.isAllDay
            ? "All Day"
            : "${DateFormat('HH:mm').format(api.start)} - ${DateFormat('HH:mm').format(api.end)}";

        map.putIfAbsent(current, () => []);
        map[current]!.add(
          Event(
            title: api.name,
            time: timeString,
            isAllDay: api.isAllDay,
            color: AppColors.blue,
          ),
        );

        current = current.add(const Duration(days: 1));
      }
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            height: screenHeight / 1.48,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.skyblue, AppColors.lightblue],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0,
            height: screenHeight / 1.5,
            child: Opacity(
              opacity: 0.3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30),
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatListPageT()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.01,
                              vertical: screenHeight * 0.005),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Image.asset(
                                'assets/images/chat_icon.png',
                                width: 29,
                                height: 29,
                              ),
                        
                              if (unreadCount > 0)
                                Positioned(
                                  right: -2,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Center(
                                      child: Text(
                                        unreadCount > 99 ? '99+' : unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    "Today's Plan",
                    style: TextWidgetStyles.text20LatoSemibold().copyWith(color: Colors.white),
                  ),
                  SizedBox(height: screenHeight * 0.005),

                  SizedBox(
                    height: screenHeight * 0.5,
                    child: Container(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                        right: screenWidth * 0.02,
                        top: screenHeight * 0.012,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
                                  });
                                },
                                icon: const Icon(Icons.chevron_left),
                              ),
                              Text(
                                _getMonthYearString(currentMonth),
                                style: TextWidgetStyles
                                    .text16LatoSemibold()
                                    .copyWith(color: AppColors.textDarkblue),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
                                  });
                                },
                                icon: const Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: ['MON','TUE','WED','THU','FRI','SAT','SUN']
                                .map((day) => Expanded(
                                      child: Center(
                                        child: Text(
                                          day,
                                          style: TextWidgetStyles
                                              .text14LatoBold()
                                              .copyWith(color: AppColors.textDarkblue),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          Flexible(
                            flex: 6,
                            child: _buildCalendarGrid(context),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: screenWidth*0.025),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Events',
                                  style: TextWidgetStyles.text14LatoSemibold().copyWith(color: AppColors.textDarkblue),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarPageT()));
                                  },
                                  child: Text(
                                    'View all',
                                    style: TextWidgetStyles.text14LatoSemibold().copyWith(color: AppColors.textDarkblue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: _buildEventsList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Chat Notifications
                  SizedBox(height: screenHeight*0.025,),
                  Row(
                    children: [
                      const Icon(Icons.email_outlined, color: AppColors.yellow),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Chat Notifications',
                        style: TextWidgetStyles.text20LatoSemibold()
                            .copyWith(color: AppColors.textDarkblue),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.01,),
                  SizedBox(
                    height: screenHeight * 0.16,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: chatNotiList.length,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      itemBuilder: (context, index) {
                        final chat = chatNotiList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPageT(
                                  otherMember: chat.otherMemberId,
                                  roomId: chat.roomId,
                                ),
                              ),
                            ).then((_) {
                              _loadChatNotifications(_accId!);
                              _loadUnreadCount(_accId!);
                            });
                          },
                          child: Container(
                            width: screenWidth * 0.7,
                            margin: EdgeInsets.only(right: screenWidth * 0.02,bottom: screenHeight * 0.01),
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 2,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.person_outline,color: Color.fromARGB(255, 246, 135, 31)),
                                        SizedBox(width: screenWidth * 0.01),
                                        Text(
                                          chat.otherMemberId,
                                          style: TextWidgetStyles.text14LatoSemibold().copyWith(color: AppColors.textBlue),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      chat.fullNameTh,
                                      style: TextWidgetStyles.text14NotoSansMedium().copyWith(color: AppColors.textBlue),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Divider(
                                  color: Color.fromARGB(255, 239, 239, 239),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  chat.titleContent,
                                  style: TextWidgetStyles.text14NotoSansRegular().copyWith(
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBarT(
        homeActive: true,
        onHomeTap: () {},
        onGptTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CeGptPage()));
        },
        onProfileTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePageT()));
        },
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    const cellHeight = 34.0; 
    final cellWidth = (screenW - (screenW * 0.05 * 2) - (screenW * 0.02 * 2)) / 7;
    final aspectRatio = cellWidth / cellHeight;

    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday;

    final List<Widget> dayWidgets = [];

    for (int i = 1; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final isSelected = _isSameDay(date, selectedDate);
      final hasEvents = events.containsKey(date) && events[date]!.isNotEmpty;
      final isToday = _isSameDay(date, DateTime.now());

      dayWidgets.add(
        GestureDetector(
          onTap: () => setState(() => selectedDate = date),
          child: Container(
            margin: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.yellow
                  : (isToday ? AppColors.yellow.withOpacity(0.35) : Colors.transparent),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextWidgetStyles.text14LatoSemibold().copyWith(
                        color: isSelected
                            ? Colors.white
                            : (isToday ? AppColors.yellow : Colors.black),
                      ),
                ),
                if (hasEvents)
                  Container(
                    width: 4, height: 4, margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.red[600],
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      childAspectRatio: aspectRatio,
      padding: EdgeInsets.zero,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      children: dayWidgets,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _buildEventsList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final selectedDateEvents = events[_dateOnly(selectedDate)] ?? [];

    if (selectedDateEvents.isEmpty) {
      return const Center(
        child: Text('No events for this day', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: selectedDateEvents.length,
      itemBuilder: (context, index) {
        final event = selectedDateEvents[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: 
          !event.isAllDay ? const EdgeInsets.symmetric(horizontal: 12, vertical: 7) :  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextWidgetStyles.text10LatoSemibold().copyWith(color: AppColors.blue)
                    ),
                    !event.isAllDay ?
                      Text(
                        event.time,
                        style: TextWidgetStyles.text10LatoSemibold().copyWith(color: AppColors.blue)
                      ) :
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: event.color)
                        ),
                        child: Text(
                          'All Day',
                          style: TextWidgetStyles.text10LatoSemibold().copyWith(color: AppColors.blue)
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}