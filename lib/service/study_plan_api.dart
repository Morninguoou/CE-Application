import 'dart:convert';
import 'dart:io';
import 'package:ce_connect_app/models/study_plan.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StudyPlanService {
  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080'; // iOS sim
  }

  Future<StudyPlanResponse> getStudyPlan(String accId, {String? filter}) async {
    try {
      String url = '${_baseUrl}/subject/StudyPlan?accId=$accId';
      if (filter != null && filter.isNotEmpty) {
        url += '&filter=$filter';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return StudyPlanResponse.fromJson(data);
      } else {
        throw Exception('Failed to load study plan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching study plan: $e');
    }
  }
}
