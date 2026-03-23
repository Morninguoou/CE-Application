import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleOAuthService {
  static String baseUrl = dotenv.get('API_URL');

  static Future<void> login() async {
    final res = await http.get(Uri.parse("$baseUrl/google/login"));
    final data = jsonDecode(res.body);

    final authUrl = data["auth_url"];

    debugPrint("AUTH URL: $authUrl");

    await launchUrl(
      Uri.parse(authUrl),
      mode: LaunchMode.externalApplication,
    );
  }
}