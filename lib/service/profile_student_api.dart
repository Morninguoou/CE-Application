import 'dart:convert';
import 'dart:io';
import 'package:ce_connect_app/models/profile_student.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfileDetailService {
  String get _baseUrl {
    return dotenv.get('API_URL');
  }

  Future<ProfileDetail> fetchProfileDetail({required String accId}) async {
    final uri = Uri.parse('$_baseUrl/account/ProfileDetail').replace(queryParameters: {
      'accId': accId,
    });

    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = json.decode(res.body) as Map<String, dynamic>;
      return ProfileDetail.fromJson(data);
    } else {
      if (kDebugMode) {
        debugPrint('ProfileDetail API error [${res.statusCode}]: ${res.body}');
      }
      throw Exception('Failed to load profile detail (${res.statusCode})');
    }
  }
}