import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_notes.dart';

class StorageService {
  SharedPreferences? _preferences;

  /// Initialize the storage service
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Save a string value by key
  Future<bool> saveString(String key, String value) async {
    if (_preferences == null) await init();
    return await _preferences!.setString(key, value);
  }

  /// Get a string value by key
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  /// Save UserNotes by key
  Future<bool> saveUserNotes(String key, UserNotes userNotes) async {
    if (_preferences == null) await init();
    final jsonString = jsonEncode(userNotes.toJson());
    return await _preferences!.setString(key, jsonString);
  }

  /// Get UserNotes by key
  UserNotes? getUserNotes(String key) {
    final jsonString = _preferences?.getString(key);
    if (jsonString == null) return null;

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserNotes.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Remove a value by key
  Future<bool> remove(String key) async {
    if (_preferences == null) await init();
    return await _preferences!.remove(key);
  }

  /// Clear all stored values
  Future<bool> clear() async {
    if (_preferences == null) await init();
    return await _preferences!.clear();
  }

  /// Check if a key exists
  bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }
}
