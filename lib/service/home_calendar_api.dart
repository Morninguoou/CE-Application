import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/home_calendar.dart';

class HomeCalendarService {
  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080';
    return 'http://localhost:8080';
  }

  Future<List<HomeCalendarItem>> fetchCalendar({
    required String accId,
  }) async {
    final url = Uri.parse(
        '$_baseUrl/Home/GetCalendarStudent?accId=$accId');

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List data = body['data'] ?? [];
      return data
          .map((e) => HomeCalendarItem.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load calendar');
    }
  }
}