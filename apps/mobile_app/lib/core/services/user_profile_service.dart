import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService extends ChangeNotifier {
  UserProfileService._();

  static final UserProfileService instance = UserProfileService._();

  static const String _nameKey = 'user_name';
  static const String roleCacheKey = 'user_role';
  static const String _phoneKey = 'user_phone';

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _name = 'User';
  String _role = 'passenger';
  String _phone = '';

  String get name => _name;
  String get role => _role;
  String get phone => _phone;

  bool get isPassenger => _role == 'passenger';
  bool get isDriver => _role == 'driver';
  bool get isConductor => _role == 'conductor';

  Future<void> loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString(_nameKey) ?? 'User';

    _role = _normalizeRole(prefs.getString(roleCacheKey) ?? 'passenger');

    _phone = prefs.getString(_phoneKey) ?? '';

    notifyListeners();
  }

  Future<void> load() async {
    await loadFromCache();

    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      final document = await _firestore.collection('users').doc(user.uid).get();

      if (!document.exists) {
        return;
      }

      final data = document.data();

      final name = data?['fullName'] as String?;
      final role = data?['role'] as String?;
      final phone = data?['phoneNumber'] as String?;

      if (name != null && name.trim().isNotEmpty) {
        _name = name.trim();

        await prefs.setString(_nameKey, _name);
      }

      if (role != null && role.trim().isNotEmpty) {
        _role = _normalizeRole(role);

        await prefs.setString(roleCacheKey, _role);
      }

      if (phone != null && phone.trim().isNotEmpty) {
        _phone = phone.trim();

        await prefs.setString(_phoneKey, _phone);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load user profile: $e');

      notifyListeners();
    }
  }

  Future<void> save({
    required String name,
    required String role,
    required String phone,
  }) async {
    _name = name.trim();
    _role = _normalizeRole(role);
    _phone = phone.trim();

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await Future.wait([
      prefs.setString(_nameKey, _name),
      prefs.setString(roleCacheKey, _role),
      prefs.setString(_phoneKey, _phone),
    ]);
  }

  Future<void> clear() async {
    _name = 'User';
    _role = 'passenger';
    _phone = '';

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    await Future.wait([
      prefs.remove(_nameKey),
      prefs.remove(roleCacheKey),
      prefs.remove(_phoneKey),
    ]);
  }

  String _normalizeRole(String role) {
    switch (role.trim().toLowerCase()) {
      case 'driver':
        return 'driver';

      case 'conductor':
        return 'conductor';

      case 'passenger':
      default:
        return 'passenger';
    }
  }
}
