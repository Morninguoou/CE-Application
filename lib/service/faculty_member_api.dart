import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/faculty_member.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String apiBaseUrl = dotenv.get('API_URL');
}

class FacultyService {
  final String baseUrl;
  FacultyService({String? baseUrl}) : baseUrl = baseUrl ?? AppConfig.apiBaseUrl;

  Future<List<FacultyMember>> fetchMembers() async {
    final uri = Uri.parse('$baseUrl/FacultyMember/Member');
    final resp = await http.get(uri).timeout(const Duration(seconds: 15));

    if (resp.statusCode != 200) {
      throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
    }

    final data = json.decode(resp.body);
    if (data is! List) {
      throw Exception('Unexpected response shape: not a List');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map((e) => FacultyMember.fromJson(e))
        .toList();
  }
}