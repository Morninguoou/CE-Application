import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ce_connect_app/models/assignment_item.dart';

class AssignmentListService {
  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080'; // iOS sim
  }

  Future<List<AssignmentItem>> fetchAssignments({required String accId}) async {
    final uri = Uri.parse('$_baseUrl/Noti/AssignmentsData?accId=$accId');
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to load assignments: ${res.statusCode}');
    }

    final List<dynamic> data = jsonDecode(res.body) as List<dynamic>;
    final items = data.map((e) => AssignmentItem.fromJson(e as Map<String, dynamic>)).toList();

    items.sort((a, b) {
      final aDateTime = _combineDue(a.dueDate, a.dueTime);
      final bDateTime = _combineDue(b.dueDate, b.dueTime);
      return aDateTime.compareTo(bDateTime);
    });

    return items;
  }

  DateTime _combineDue(DateTime dueDate, String dueTime12h) {
    try {
      final parts = dueTime12h.trim().split(' ');
      if (parts.length == 2) {
        final hm = parts[0];
        final ampm = parts[1].toUpperCase();
        final hmparts = hm.split(':');
        int h = int.parse(hmparts[0]);
        int m = int.parse(hmparts[1]);
        if (ampm == 'PM' && h != 12) h += 12;
        if (ampm == 'AM' && h == 12) h = 0;
        return DateTime(dueDate.year, dueDate.month, dueDate.day, h, m);
      }
    } catch (_) { /* fallback */ }
    return dueDate;
  }
}