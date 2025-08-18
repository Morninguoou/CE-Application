import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class PinService {
  final http.Client _client;
  PinService({http.Client? client}) : _client = client ?? http.Client();

  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080'; // iOS sim
  }

  //TODO : Check pin exist end point
  Future<bool> checkPinExist({required String email}) async {
    final uri = Uri.parse('$_baseUrl/Account/CheckPinExist');

    final req = http.Request('GET', uri)
      ..headers['Content-Type'] = 'application/json'
      ..headers['Accept'] = 'application/json'
      ..body = jsonEncode({'email': email});

    final streamResp = await _client.send(req).timeout(const Duration(seconds: 15));
    final resp = await http.Response.fromStream(streamResp);

    if (resp.statusCode != 200) {
      throw Exception('CheckPinExist failed: ${resp.statusCode} ${resp.body}');
    }
    final map = jsonDecode(resp.body) as Map<String, dynamic>;
    return (map['pinExist'] as bool?) ?? false;
  }

  //TODO : Create new pin endpoint
  Future<({bool success, String message})> createNewPin({
    required String email,
    required String pinNumber,
  }) async {
    final uri = Uri.parse('$_baseUrl/account/CreateNewPin');

    final resp = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'pinNumber': pinNumber,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (resp.statusCode != 200) {
      throw Exception('CreateNewPin failed: ${resp.statusCode} ${resp.body}');
    }

    final map = jsonDecode(resp.body) as Map<String, dynamic>;
    final success = (map['success'] as bool?) ?? false;
    final message = (map['message'] as String?) ?? 'Unknown response';

    return (success: success, message: message);
  }


  //TODO : Validate pin endpoint
  Future<bool> validatePin({
    required String email,
    required String pinNumber,
  }) async {
    final uri = Uri.parse('$_baseUrl/account/CheckPinValidate');

    final req = http.Request('GET', uri)
      ..headers['Content-Type'] = 'application/json'
      ..headers['Accept'] = 'application/json'
      ..body = jsonEncode({
        'email': email,
        'pinNumber': pinNumber,
      });

    final streamResp = await _client.send(req).timeout(const Duration(seconds: 15));
    final resp = await http.Response.fromStream(streamResp);

    if (resp.statusCode != 200) {
      // ถ้าต้องการ "ล้มเหลว = false" เงียบ ๆ ก็ได้
      return false;
      // throw Exception('CheckPinValidate failed: ${resp.statusCode} ${resp.body}');
    }

    final map = jsonDecode(resp.body) as Map<String, dynamic>;
    final success = (map['success'] as bool?) ?? false;
    return success;
  }
}