import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/home_announcement.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeAnnouncementService {
 String get _baseUrl {
    return dotenv.get('API_URL');
  }

  Future<List<Announcement>> fetchAnnouncements({required String accId}) async {
    final uri = Uri.parse('$_baseUrl/Home/AnnouncementData').replace(queryParameters: {
      'accId': accId,
    });

    final res = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);
      return Announcement.listFromJson(data);
    } else {
      throw Exception('Failed to load announcements (${res.statusCode})');
    }
  }
}
