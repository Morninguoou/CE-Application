import 'dart:convert';
import 'dart:io';
import 'package:ce_connect_app/models/event_T.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EventService {
  String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:8080'; // Android emulator
    return 'http://localhost:8080'; // iOS sim
  }

  Future<List<ApiEventT>> fetchEventsT(String accId) async {
    final url = Uri.parse('$_baseUrl/Event/DisplayEvent?accId=$accId');

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List data = body['data'];
      return data.map((e) => ApiEventT.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<ApiEventT>> fetchEventsByDate({
    required String accId,
    required DateTime date,
  }) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);

    final url = Uri.parse(
      "$_baseUrl/Event/DisplayEvent?accId=$accId&date=$dateStr",
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List data = body["data"] ?? [];
      return data.map((e) => ApiEventT.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load events");
    }
  }

  Future<List<ApiEventT>> fetchOtherInvitations({
    required String accId,
  }) async {
    final url = Uri.parse(
      "$_baseUrl/Event/OtherInvitationList?accId=$accId",
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List data = body["data"] ?? [];
      return data.map((e) => ApiEventT.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load other events");
    }
  }

  Future<void> respondToInvitation({
    required String accId,
    required String eventId,
    required bool accept,
  }) async {
    final url = Uri.parse("$_baseUrl/Event/RespondToInvitation");

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "acc_id": accId,
        "event_id": eventId,
        "respond": accept.toString(),
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to respond invitation");
    }
  }

  String _formatUtc(DateTime dt) {
  return DateFormat("yyyy-MM-ddTHH:mm:ss'Z'")
      .format(dt);
}

Future<bool> createEvent({
  required String accId,
  required String name,
  required String location,
  required DateTime start,
  required DateTime end,
  required bool isAllDay,
  required bool sendToAll,
}) async {
  final url = Uri.parse("$_baseUrl/Event/Create");

  final body = {
    "name": name,
    "location": location,
    "startDateTime": _formatUtc(start),
    "endDateTime": _formatUtc(end),
    "allDayChecked": isAllDay,
    "status": sendToAll ? 1 : 0,
    "accId": accId,
  };

  final res = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(body),
  );

  if (res.statusCode == 200) {
    return true;
  } else {
    throw Exception(
        "Create event failed (${res.statusCode}): ${res.body}");
  }
}
}