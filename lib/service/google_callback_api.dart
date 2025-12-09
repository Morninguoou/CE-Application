import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleCallbackResult {
  final bool success;
  final String? accId;
  final String? message;

  GoogleCallbackResult({required this.success, this.accId, this.message});

  factory GoogleCallbackResult.fromJson(Map<String, dynamic> json) {
    return GoogleCallbackResult(
      success: json['Success'] == true,
      accId: json['accId'] as String?,
      message: json['message'] as String?,
    );
  }
}

class GoogleCallbackService {
  final String baseUrl;
  GoogleCallbackService({required this.baseUrl});

  Future<GoogleCallbackResult> callback({
    required String code,
    required String email,
  }) async {
    final uri = Uri.parse('$baseUrl/Google/callback')
        .replace(queryParameters: {'code': code, 'email': email});

    final res = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return GoogleCallbackResult.fromJson(data);
    } else {
      throw Exception('Callback failed (${res.statusCode}): ${res.body}');
    }
  }
}