import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CEgptService {

  String get _baseUrl {
    return dotenv.get('API_URL');
  }

  Future<String?> createSession(String accId) async {

    final url = Uri.parse("$_baseUrl/cegpt/sessions");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": accId,
          "metadata": {},
          "ttl_hours": 1
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data["session_id"];
      } else {
        print("Create session failed: ${response.body}");
        return null;
      }

    } catch (e) {
      print("Error creating session: $e");
      return null;
    }
  }

  Stream<String> generateStream({
    required String query,
    required String userId,
    required String sessionId,
  }) async* {

    final url = Uri.parse("$_baseUrl/cegpt/generate/stream");

    final request = http.Request("POST", url);

    request.headers["Content-Type"] = "application/json";

    request.body = jsonEncode({
      "query": query,
      "user_id": userId,
      "session_id": sessionId,
      "top_k": 10,
      "language": "auto",
      "use_reranking": true,
      "include_sources": true,
      "stream": true
    });

    final response = await request.send();

    final stream = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (var line in stream) {

      if (!line.startsWith("data:")) continue;

      final jsonStr = line.replaceFirst("data:", "").trim();

      if (jsonStr.isEmpty) continue;

      final data = jsonDecode(jsonStr);

      if (data["type"] == "chunk") {
        yield data["content"];
      }
    }
  }
}