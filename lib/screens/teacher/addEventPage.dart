import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
import 'package:ce_connect_app/screens/teacher/calendarPage.dart';
import 'package:ce_connect_app/service/event_T_api.dart';
import 'package:ce_connect_app/widgets/appBar.dart';
import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  bool isAllDay = false;
  bool sendToAll = true;

  DateTime currentMonth = DateTime.now();

  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now().add(const Duration(hours: 1));

  final EventService _service = EventService();
  final TextEditingController _titleController =TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _accId;
  bool isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final accId = 'Jirasak'; // test accId
    // final accId = context.read<SessionProvider>().accId;
    if (_accId != accId && accId.isNotEmpty) {
      _accId = accId;
    }
  }

  Future<void> _saveEvent() async {
  if (_titleController.text.trim().isEmpty) return;
  if (endDateTime.isBefore(startDateTime)) return;

  setState(() => isSaving = true);

  try {
    await _service.createEvent(
      accId: _accId!,
      name: _titleController.text.trim(),
      location: _locationController.text.trim(),
      start: startDateTime,
      end: endDateTime,
      isAllDay: isAllDay,
      sendToAll: sendToAll,
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CalendarPageT(),
        ),
      );
    }
  } catch (e) {
    debugPrint("Create error: $e");
  } finally {
    if (mounted) {
      setState(() => isSaving = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Create Events', includeBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInputCard(
              label: "Header",
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 12),
            _buildInputCard(
              label: "Location",
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 12),

            // Time card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: TextWidgetStyles.text16LatoBold()
                        .copyWith(color: AppColors.textDarkblue),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("All Day",
                          style:
                              TextWidgetStyles.text16LatoSemibold()),
                      _buildSwitch(
                        value: isAllDay,
                        onChanged: (val) {
                          setState(() => isAllDay = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text("Date:",
                          style: TextWidgetStyles.text16LatoSemibold()),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _openDateDialog(),
                          child: _buildChipDate(_formatDate(startDateTime)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  // Time Row
                  Row(
                    children: [
                      Text("Start Time:",
                          style: TextWidgetStyles.text16LatoSemibold()),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _openTimeDialog(),
                        child: _buildChipTime(_formatTime(startDateTime)),
                      ),
                      const SizedBox(width: 16),
                      Text("End Time:",
                          style: TextWidgetStyles.text16LatoSemibold()),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _openTimeDialog(),
                        child: _buildChipTime(_formatTime(endDateTime)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Send this event detail to all",
                          style:
                              TextWidgetStyles.text16LatoSemibold()),
                      _buildSwitch(
                        value: sendToAll,
                        onChanged: (val) {
                          setState(() => sendToAll = val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildActionButton(
                  label: "Cancel",
                  color: Colors.red,
                  icon: Icons.close,
                ),
                _buildActionButton(
                  label: "Save",
                  color: Colors.blue,
                  icon: Icons.save,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(
      {required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextWidgetStyles.text16LatoBold()
                  .copyWith(color: AppColors.textDarkblue)),
          child,
          const Divider(),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return "${dt.day} ${months[dt.month]} ${dt.year}";
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildChipDate(String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightblue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(text,
            style: TextWidgetStyles.text14LatoSemibold()
                .copyWith(color: Colors.white)),
      ),
    );
  }

  Widget _buildChipTime(String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightblue),
      ),
      child: Text(text,
          style: TextWidgetStyles.text14LatoSemibold()
              .copyWith(color: AppColors.lightblue)),
    );
  }

  Widget _buildSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Switch(
      value: value,
      onChanged: onChanged,
      thumbColor:
          MaterialStateProperty.all(Colors.white),
      trackColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return const Color.fromARGB(255, 40, 193, 149);
          }
          return Colors.grey.shade300;
        },
      ),
      trackOutlineColor:
          MaterialStateProperty.all(Colors.transparent),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: ElevatedButton.icon(
        onPressed: label == "Save"
            ? (isSaving ? null : _saveEvent)
            : () => Navigator.pop(context),
        icon: Icon(icon, color: Colors.white),
        label: Text(label,
            style: TextWidgetStyles.text14LatoSemibold()
                .copyWith(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Future<void> _openDateDialog() async {
    await showDialog(
      context: context,
      builder: (_) => _DateDialog(
        initialDate: startDateTime,
        onConfirm: (pickedDate) {
          setState(() {
            startDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              startDateTime.hour,
              startDateTime.minute,
            );

            endDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              endDateTime.hour,
              endDateTime.minute,
            );
          });
        },
      ),
    );
  }
  
  Future<void> _openTimeDialog() async {
    await showDialog(
      context: context,
      builder: (_) => _TimeDialog(
        initialStart: startDateTime,
        initialEnd: endDateTime,
        onConfirm: (start, end) {
          setState(() {
            startDateTime = start;
            endDateTime = end;
          });
        },
      ),
    );
  }
  }


class _DateDialog extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onConfirm;

  const _DateDialog({
    required this.initialDate,
    required this.onConfirm,
  });

  @override
  State<_DateDialog> createState() =>
      _DateDialogState();
}

class _DateDialogState extends State<_DateDialog> {
  late DateTime _focusedMonth;
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(
        widget.initialDate.year, widget.initialDate.month);
    _selectedDay = widget.initialDate.day;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pick a Start Date",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E3192),
              ),
            ),
            const SizedBox(height: 16),

            _buildMonthHeader(),
            const SizedBox(height: 8),
            _buildWeekHeader(),
            const SizedBox(height: 8),
            _buildCalendarGrid(),

            const SizedBox(height: 20),

            const SizedBox(height: 20),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekHeader() {
    const days = ["SAN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMonthHeader() {
    const months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          months[_focusedMonth.month],
          style: TextWidgetStyles.text20LatoMedium()
              .copyWith(color: AppColors.textDarkblue)
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left,
                  color: Color(0xFF2E3192)),
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(
                      _focusedMonth.year,
                      _focusedMonth.month - 1);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right,
                  color: Color(0xFF2E3192)),
              onPressed: () {
                setState(() {
                  _focusedMonth = DateTime(
                      _focusedMonth.year,
                      _focusedMonth.month + 1);
                });
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(
        _focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(
            _focusedMonth.year, _focusedMonth.month + 1, 0)
        .day;
    final startOffset = firstDay.weekday % 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: startOffset + daysInMonth,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        if (index < startOffset) return const SizedBox();

        final day = index - startOffset + 1;
        final selected = day == _selectedDay;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = day;
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF2E3192)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$day",
              style: TextStyle(
                color:
                    selected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.skyblue,
            side: BorderSide(color:AppColors.skyblue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 12),
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm(DateTime(
              _focusedMonth.year,
              _focusedMonth.month,
              _selectedDay,
            ));
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.lightyellow,
            foregroundColor: AppColors.textDarkblue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 12),
          ),
          child: Text("Pick a Date",style: TextWidgetStyles.text14LatoBold().copyWith(color: AppColors.textDarkblue),),
        ),
      ],
    );
  }

  Widget _outlineChip(String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.skyblue),
      ),
      child: Text(
        text,
        style: TextWidgetStyles.text14LatoSemibold()
            .copyWith(color: AppColors.textDarkblue),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month];
  }
}

class _TimeDialog extends StatefulWidget {
  final DateTime initialStart;
  final DateTime initialEnd;
  final Function(DateTime start, DateTime end) onConfirm;

  const _TimeDialog({
    required this.initialStart,
    required this.initialEnd,
    required this.onConfirm,
  });

  @override
  State<_TimeDialog> createState() => _TimeDialogState();
}

class _TimeDialogState extends State<_TimeDialog> {
  late TextEditingController _startController;
  late TextEditingController _endController;

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(
      text:
          "${widget.initialStart.hour.toString().padLeft(2, '0')}:${widget.initialStart.minute.toString().padLeft(2, '0')}",
    );

    _endController = TextEditingController(
      text:
          "${widget.initialEnd.hour.toString().padLeft(2, '0')}:${widget.initialEnd.minute.toString().padLeft(2, '0')}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Start/End Time",
              style: TextWidgetStyles.text20LatoBold()
                  .copyWith(color: AppColors.textDarkblue),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: _buildTimeField("Start time", _startController)),
                const SizedBox(width: 16),
                Expanded(child: _buildTimeField("End time", _endController)),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.skyblue,
                    side: BorderSide(color: AppColors.skyblue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final startParts = _startController.text.split(":");
                    final endParts = _endController.text.split(":");

                    final start = DateTime(
                      widget.initialStart.year,
                      widget.initialStart.month,
                      widget.initialStart.day,
                      int.tryParse(startParts[0]) ?? 0,
                      int.tryParse(startParts[1]) ?? 0,
                    );

                    final end = DateTime(
                      widget.initialStart.year,
                      widget.initialStart.month,
                      widget.initialStart.day,
                      int.tryParse(endParts[0]) ?? 0,
                      int.tryParse(endParts[1]) ?? 0,
                    );

                    widget.onConfirm(start, end);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightyellow,
                    foregroundColor: AppColors.textDarkblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    "Pick a Time",
                    style: TextWidgetStyles.text14LatoBold()
                        .copyWith(color: AppColors.textDarkblue),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextWidgetStyles.text16LatoSemibold()),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppColors.skyblue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: AppColors.blue),
            ),
          ),
        ),
      ],
    );
  }
}