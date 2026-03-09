import 'dart:convert';
import 'dart:io';
import 'package:ce_connect_app/models/course.dart';
import 'package:ce_connect_app/models/course_annoucement.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CourseService {

  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080'; // iOS sim
  }

  Future<List<CourseModel>> getCourseList(String accId) async {
    final url = Uri.parse("$_baseUrl/Teacher/CourseList?accId=$accId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      List data = jsonData["data"];

      return data.map((e) => CourseModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load courses");
    }
  }

  Future<List<AnnouncementModel>> getCourseAnnouncements(String courseId) async {
  final url = Uri.parse("$_baseUrl/Teacher/ClasroomList?course_id=$courseId");

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final data = jsonData["data"];

    List all = [];

    if (data["Today"]["Data"] != null) {
      all.addAll(data["Today"]["Data"]);
    }

    if (data["Yesterday"]["Data"] != null) {
      all.addAll(data["Yesterday"]["Data"]);
    }

    if (data["Previously"]["Data"] != null) {
      all.addAll(data["Previously"]["Data"]);
    }

    return all.map((e) => AnnouncementModel.fromJson(e)).toList();

  } else {
    throw Exception("Failed to load announcements");
  }
}
}