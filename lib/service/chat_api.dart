import 'dart:convert';
import 'dart:io';
import 'package:ce_connect_app/models/chat_list.dart';
import 'package:ce_connect_app/models/chat_message.dart';
import 'package:ce_connect_app/models/chat_open.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ChatService {
  String get _baseUrl {
  if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080';   // iOS sim
  }

  Future<List<ChatRoom>> fetchChatList(String accId) async {
    final url = Uri.parse("$_baseUrl/chat/List?accId=$accId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['data'];

      return list.map((e) => ChatRoom.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load chat list");
    }
  }

  Future<ChatOpenResponse> openChat({
    required String accId,
    required String person2,
  }) async {
    final url = Uri.parse("$_baseUrl/chat/Open");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "accId": accId,
        "person_2": person2,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ChatOpenResponse.fromJson(data);
    } else {
      throw Exception("Failed to open chat");
    }
  }

  Future<List<ChatMessage>> fetchChatHistory(String roomId) async {
    final url = Uri.parse("$_baseUrl/Chat/History?room_id=$roomId");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['data'];

      return list.map((e) => ChatMessage.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load chat history");
    }
  }
}