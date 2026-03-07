import 'package:shared_preferences/shared_preferences.dart';

class PreferenceStore {
  SharedPreferences? _prefs;

  /// Must be called before use.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get _requirePrefs {
    if (_prefs == null) {
      throw StateError('PreferenceStore not initialized. Call init() first.');
    }
    return _prefs!;
  }

  String? getString(String key) => _requirePrefs.getString(key);
  Future<bool> setString(String key, String value) =>
      _requirePrefs.setString(key, value);

  int? getInt(String key) => _requirePrefs.getInt(key);
  Future<bool> setInt(String key, int value) =>
      _requirePrefs.setInt(key, value);

  bool? getBool(String key) => _requirePrefs.getBool(key);
  Future<bool> setBool(String key, bool value) =>
      _requirePrefs.setBool(key, value);

  double? getDouble(String key) => _requirePrefs.getDouble(key);
  Future<bool> setDouble(String key, double value) =>
      _requirePrefs.setDouble(key, value);

  List<String>? getStringList(String key) => _requirePrefs.getStringList(key);
  Future<bool> setStringList(String key, List<String> value) =>
      _requirePrefs.setStringList(key, value);

  Future<bool> remove(String key) => _requirePrefs.remove(key);
  Future<bool> clear() => _requirePrefs.clear();
}
