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

  String? get accId => _accId;
  String? get role => _role;
  String? get email => _email;
  bool get hasPin => _hasPin;

  bool get isLoggedIn => _accId != null && _accId!.isNotEmpty;

  Future<void> load() async {
    _accId = await _storage.read(key: _kAccIdKey);
    _role = await _storage.read(key: _kRoleKey);
    _email = await _storage.read(key: _kEmailKey);
    final hasPinStr = await _storage.read(key: _kHasPinKey);
    _hasPin = hasPinStr == 'true';
    // if (_accId != null){
    //   debugPrint("accId: $_accId");
    //   debugPrint("role: $_role");
    //   debugPrint("email: $_email");
    //   debugPrint("hasPin: $_hasPin");
    // }
    notifyListeners();
  }

  Future<void> setSession({
    required String accId,
    required String role,
    required String email,
    required bool hasPin,
  }) async {

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

    notifyListeners();
  }

  Future<void> signOut() async {

    await _storage.delete(key: _kAccIdKey);
    await _storage.delete(key: _kRoleKey);
    await _storage.delete(key: _kEmailKey);
    await _storage.delete(key: _kHasPinKey);

    _accId = null;
    _role = null;
    _email = null;

    notifyListeners();
  }
}