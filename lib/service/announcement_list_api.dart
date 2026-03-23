import 'dart:convert';
import 'dart:io';
import 'package:ce_connect_app/models/ce_noti.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ce_connect_app/models/noti_annoucement.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotiAnnouncementsService {
  String get _baseUrl {
    return dotenv.get('API_URL');
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

  Future<CeWebResponse> fetchCeAnnouncements() async {

    final uri = Uri.parse('$_baseUrl/Fetch/FetchAnnouceCEWeb');

    final resp = await http.get(uri).timeout(const Duration(seconds: 20));

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('HTTP ${resp.statusCode}');
    }

    final body = json.decode(resp.body);

    return CeWebResponse.fromJson(body);
  }
}