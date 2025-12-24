import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:ce_connect_app/models/subject_list.dart';

class SubjectListService {
  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080'; // iOS sim
  }

  Future<List<SubjectModel>> getSubjectListStudent(String accId) async {
    final url = Uri.parse(
      '$_baseUrl/subject/GetSubjectListStudent?accId=$accId',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SubjectModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load subject list');
    }
  }
}