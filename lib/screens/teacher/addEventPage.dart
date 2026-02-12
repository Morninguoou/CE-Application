import 'package:ce_connect_app/constants/colors.dart';
import 'package:ce_connect_app/constants/texts.dart';
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

  DateTime startDateTime = DateTime(2024, 12, 19, 9, 0);
  DateTime endDateTime = DateTime(2024, 12, 19, 10, 0);

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
              child: const TextField(
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 12),
            _buildInputCard(
              label: "Location",
              child: const TextField(
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

                  _buildDateRow("Start Date :", startDateTime, true),
                  const SizedBox(height: 8),
                  _buildDateRow("End Date :", endDateTime, false),


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

  Widget _buildDateRow(
    String label, DateTime dateTime, bool isStart) 
  {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: TextWidgetStyles.text16LatoSemibold()),
        ),
        _buildChipDate(_formatDate(dateTime)),
        const SizedBox(width: 8),
        _buildChipTime(_formatTime(dateTime)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _openCalendarDialog(isStart),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.lightblue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.edit_outlined,
                color: AppColors.lightblue),
          ),
        ),
      ],
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
      child: Text(text,
          style: TextWidgetStyles.text14LatoSemibold()
              .copyWith(color: Colors.white)),
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
        onPressed: () {},
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

  Future<void> _openCalendarDialog(bool isStart) async {
    DateTime initial =
        isStart ? startDateTime : endDateTime;
    await showDialog(
      context: context,
      builder: (_) => _CalendarDialog(
        initialDate: initial,
        onConfirm: (picked) {
          setState(() {
            if (isStart) {
              startDateTime = picked;
            } else {
              endDateTime = picked;
            }
          });
        },
      ),
    );
  }
  }


class _CalendarDialog extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onConfirm;

  const _CalendarDialog({
    required this.initialDate,
    required this.onConfirm,
  });

  @override
  State<_CalendarDialog> createState() =>
      _CalendarDialogState();
}

class _CalendarDialogState extends State<_CalendarDialog> {
  late DateTime _focusedMonth;
  late int _selectedDay;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime(
        widget.initialDate.year, widget.initialDate.month);
    _selectedDay = widget.initialDate.day;
    _timeController = TextEditingController(
      text:
          "${widget.initialDate.hour.toString().padLeft(2, '0')}:${widget.initialDate.minute.toString().padLeft(2, '0')}",
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
            _buildDateTimeRow(),

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

  Widget _buildDateTimeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _outlineChip(
          "$_selectedDay ${_monthName(_focusedMonth.month)} ${_focusedMonth.year}",
        ),
        SizedBox(
          width: 100,
          child: TextField(
            style: TextWidgetStyles.text14LatoSemibold()
                .copyWith(color: AppColors.textDarkblue),
            controller: _timeController,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide:
                    BorderSide(color: AppColors.skyblue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide:
                    BorderSide(color: AppColors.blue),
              ),
            ),
          ),
        ),
      ],
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
            final parts = _timeController.text.split(":");
            final hour = int.tryParse(parts[0]) ?? 0;
            final minute = int.tryParse(parts[1]) ?? 0;

            widget.onConfirm(DateTime(
              _focusedMonth.year,
              _focusedMonth.month,
              _selectedDay,
              hour,
              minute,
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