import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionProvider with ChangeNotifier {
  static const _kAccIdKey = 'acc_id';
  static const _kRoleKey = 'role';
  static const _kEmailKey = 'email';
  static const _kHasPinKey = 'has_pin';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _accId;
  String? _role;
  String? _email;
  bool _hasPin = false;

  bool isLoading = true;

  String? get accId => _accId;
  String? get role => _role;
  String? get email => _email;
  bool get hasPin => _hasPin;

  bool get isLoggedIn => _accId != null && _accId!.isNotEmpty;

  Future<void> load() async {
    try {
      print("🔄 Loading session...");

      _accId = await _storage.read(key: _kAccIdKey);
      _role = await _storage.read(key: _kRoleKey);
      _email = await _storage.read(key: _kEmailKey);
      final hasPinStr = await _storage.read(key: _kHasPinKey);

      _hasPin = hasPinStr == 'true';

      print("Session loaded");
      print("accId: $_accId");
      print("email: $_email");
      print("role: $_role");
      print("hasPin: $_hasPin");

    } catch (e) {
      print("SESSION LOAD ERROR: $e");

      // fallback กันพัง
      _accId = null;
      _role = null;
      _email = null;
      _hasPin = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setSession({
    required String accId,
    required String role,
    required String email,
    required bool hasPin,
  }) async {
    try {
      _accId = accId;
      _role = role;
      _email = email;
      _hasPin = hasPin;

      await _storage.write(key: _kAccIdKey, value: accId);
      await _storage.write(key: _kRoleKey, value: role);
      await _storage.write(key: _kEmailKey, value: email);
      await _storage.write(
        key: _kHasPinKey,
        value: hasPin.toString(),
      );

      print("Session saved");

    } catch (e) {
      print("SESSION SAVE ERROR: $e");
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await _storage.delete(key: _kAccIdKey);
      await _storage.delete(key: _kRoleKey);
      await _storage.delete(key: _kEmailKey);
      await _storage.delete(key: _kHasPinKey);

      print("Session cleared");
    } catch (e) {
      print("SIGN OUT ERROR: $e");
    }

    _accId = null;
    _role = null;
    _email = null;
    _hasPin = false; 

    notifyListeners();
  }
}