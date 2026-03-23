import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/home_calendar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeCalendarService {
  String get _baseUrl {
    return dotenv.get('API_URL');
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