import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileService {
  static const String _nameKey = 'user_name';
  static const String _roleKey = 'user_role';
  static const String _phoneKey = 'user_phone';

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String _name = 'User';
  static String _role = 'Passenger';
  static String _phone = '';

  static String get name => _name;
  static String get role => _role;
  static String get phone => _phone;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString(_nameKey) ?? 'User';
    _role = prefs.getString(_roleKey) ?? 'Passenger';
    _phone = prefs.getString(_phoneKey) ?? '';

    final user = _auth.currentUser;

    if (user == null) return;

    try {
      final document = await _firestore.collection('users').doc(user.uid).get();

      if (!document.exists) return;

      final data = document.data();

      final name = data?['fullName'] as String?;
      final role = data?['role'] as String?;
      final phone = data?['phoneNumber'] as String?;

      if (name != null && name.trim().isNotEmpty) {
        _name = name.trim();
        await prefs.setString(_nameKey, _name);
      }

      if (role != null && role.trim().isNotEmpty) {
        _role = role.trim();
        await prefs.setString(_roleKey, _role);
      }

      if (phone != null && phone.trim().isNotEmpty) {
        _phone = phone.trim();
        await prefs.setString(_phoneKey, _phone);
      }
    } catch (_) {
      // Cached data remains available if Firestore is unavailable.
    }
  }

  static Future<void> save({
    required String name,
    required String role,
    required String phone,
  }) async {
    _name = name;
    _role = role;
    _phone = phone;

    final prefs = await SharedPreferences.getInstance();

    await Future.wait([
      prefs.setString(_nameKey, name),
      prefs.setString(_roleKey, role),
      prefs.setString(_phoneKey, phone),
    ]);
  }

  static Future<void> clear() async {
    _name = 'User';
    _role = 'Passenger';
    _phone = '';

    final prefs = await SharedPreferences.getInstance();

    await Future.wait([
      prefs.remove(_nameKey),
      prefs.remove(_roleKey),
      prefs.remove(_phoneKey),
    ]);
  }
}
