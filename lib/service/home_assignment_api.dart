// lib/service/assignment_api.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ce_connect_app/models/home_assignment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeAssignmentService {
  String get _baseUrl {
    return dotenv.get('API_URL');
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