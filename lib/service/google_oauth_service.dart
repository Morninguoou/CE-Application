import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleOAuthService {
  static String baseUrl = dotenv.get('API_URL');

  static Future<void> login() async {
    try {
      print("CALL API: $baseUrl/google/login");

      final res = await http.get(Uri.parse("$baseUrl/google/login"));

      print("STATUS: ${res.statusCode}");
      print("BODY: ${res.body}");

      final data = jsonDecode(res.body);

      if (data["auth_url"] == null) {
        throw Exception("auth_url is null");
      }

      final authUrl = data["auth_url"];
      print("AUTH URL: $authUrl");

      final uri = Uri.parse(authUrl);
      
      if (!await canLaunchUrl(uri)) {
        throw Exception("Cannot launch URL");
      }

      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        throw Exception("Launch failed");
      }

    } catch (e) {
      print("LOGIN ERROR: $e");
    }
  }
}