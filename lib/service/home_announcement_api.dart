import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/home_announcement.dart';

class HomeAnnouncementService {
 String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080'; // iOS sim
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
