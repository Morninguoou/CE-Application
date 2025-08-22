import 'package:flutter/material.dart';

class Event {
  final String title;
  final String time;
  final bool isAllDay;
  final Color color;

  Event({
    required this.title,
    required this.time,
    this.isAllDay = false,
    this.color = Colors.blue,
  });
}