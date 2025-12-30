import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();

    return this;
  }

  // String operations

  void writeString(String key, String value) {
    _prefs.setString(key, value);
  }

  String? readString(String key) {
    return _prefs.getString(key);
  }

  // Bool operations

  void writeBool(String key, bool value) {
    _prefs.setBool(key, value);
  }

  bool readBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  // Object operations

  void writeObject(String key, Map<String, dynamic> value) {
    _prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? readObject(String key) {
    final String? data = _prefs.getString(key);

    if (data != null) {
      return jsonDecode(data);
    }

    return null;
  }

  // Remove operations

  void remove(String key) {
    _prefs.remove(key);
  }

  void clearAll() {
    _prefs.clear();
  }
}
