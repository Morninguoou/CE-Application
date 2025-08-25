import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/faculty_member.dart';

class AppConfig {
  static const String apiBaseUrl = 'http://localhost:8080'; 
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