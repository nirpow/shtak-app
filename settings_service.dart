import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
class SettingsService {
  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings.theme', theme.name);
  }

  /// Loads the User's preferred Locale from local or remote storage.
  Future<Locale> locale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? language = prefs.getString('settings.local');
    return Locale(language ?? "en", '');
  }

  /// update user language
  Future<void> updateLanguage(String language) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings.local', language);
  }

  /// Restore all settings to their default values.
  Future<void> resetSettings() async {
    // remove all settings thats starts with "settings."
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.getKeys().forEach((key) {
      if (key.startsWith('settings.')) {
        prefs.remove(key);
      }
    });
  }
}
