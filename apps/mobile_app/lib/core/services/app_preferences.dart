import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const String _setupCompletedKey = 'setup_completed';
  static const String _lastSelectedTabKey = 'last_selected_tab';
  static const String _themeModeKey = 'theme_mode';

  final SharedPreferences _prefs;

  AppPreferences(this._prefs);


  bool get setupCompleted => _prefs.getBool(_setupCompletedKey) ?? false;

  Future<void> setSetupCompleted(bool value) async {
    await _prefs.setBool(_setupCompletedKey, value);
  }


  int get lastSelectedTab => _prefs.getInt(_lastSelectedTabKey) ?? 0;

  Future<void> setLastSelectedTab(int index) async {
    await _prefs.setInt(_lastSelectedTabKey, index);
  }


  String get themeMode => _prefs.getString(_themeModeKey) ?? 'system';

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }


  Future<void> clear() async {
    await _prefs.remove(_setupCompletedKey);
    await _prefs.remove(_lastSelectedTabKey);
    await _prefs.remove(_themeModeKey);
  }
}
