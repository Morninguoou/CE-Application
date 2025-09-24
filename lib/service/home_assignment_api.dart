// lib/service/assignment_api.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ce_connect_app/models/home_assignment.dart';

class HomeAssignmentService {
  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080'; // iOS sim
  }

  Future<List<Assignment>> fetchAssignments({required String accId}) async {
    final uri = Uri.parse('$_baseUrl/Home/AssignmentData?accId=$accId');
    
    final res = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (res.statusCode != 200) {
      throw Exception('Fetch assignments failed (${res.statusCode})');
    }

    final body = jsonDecode(res.body);
    if (body is! List) return [];

    return body.map<Assignment>((e) => Assignment.fromJson(e)).toList();
  }
}