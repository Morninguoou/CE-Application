import 'dart:convert';
import 'dart:io';
import 'package:ce_connect_app/models/profile_student.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ProfileDetailService {
  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080'; // iOS sim
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