import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionProvider with ChangeNotifier {
  static const _kAccIdKey = 'acc_id';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _accId;
  String? get accId => _accId;
  bool get isLoggedIn => _accId != null && _accId!.isNotEmpty;

  /// โหลดตอนเปิดแอป (hydrate)
  Future<void> load() async {
    _accId = await _storage.read(key: _kAccIdKey);
    if (_accId != null){
      debugPrint(_accId);
    }
    notifyListeners();
  }

  Future<void> setAccId(String? value) async {
    _accId = value;
    if (value == null || value.isEmpty) {
      await _storage.delete(key: _kAccIdKey);
    } else {
      await _storage.write(key: _kAccIdKey, value: value);
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _storage.delete(key: _kAccIdKey);
    _accId = null;
    notifyListeners();
  }
}