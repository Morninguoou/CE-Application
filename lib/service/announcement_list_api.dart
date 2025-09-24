import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ce_connect_app/models/noti_annoucement.dart';

class NotiAnnouncementsService {
  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080'; // iOS sim
  }

  Future<NotiAnnouncementsResponse> fetchAnnouncementsData({required String accId}) async {
    final uri = Uri.parse('$_baseUrl/Noti/AnnouncementsData?accId=$accId');

    final resp = await http.get(uri).timeout(const Duration(seconds: 20));
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }

    final Map<String, dynamic> body = json.decode(resp.body) as Map<String, dynamic>;
    return NotiAnnouncementsResponse.fromJson(body);
  }
}