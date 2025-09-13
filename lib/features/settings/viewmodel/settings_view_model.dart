import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  static const _themeModeKey = 'theme_mode';
  static const _currencyKey = 'currency_code';

  final SharedPreferences _prefs;
  SettingsViewModel(this._prefs);

  ThemeMode _themeMode = ThemeMode.system;
  String? _currencyCode;

  ThemeMode get themeMode => _themeMode;
  String get currencyCode => _currencyCode ?? 'NGN';

  final kCurrencies = <String, String>{
    'USD': '\$',
    'NGN': '₦',
    'EUR': '€',
    'GBP': '£',
    'EGP': 'E£',
    'JPY': '¥',
  };

  void init() {
    _themeMode =
        _parseMode(_prefs.getString(_themeModeKey)) ?? ThemeMode.system;
    _currencyCode = _prefs.getString(_currencyKey) ?? 'NGN';
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs.setString(_themeModeKey, _modeToString(mode));
  }

  Future<void> setCurrency(String code) async {
    if (_currencyCode == code) return;
    _currencyCode = code;
    notifyListeners();
    await _prefs.setString(_currencyKey, code);
  }

  // helpers
  String _modeToString(ThemeMode m) {
    switch (m) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  ThemeMode? _parseMode(String? s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return null;
    }
  }

  String themeLabel() {
    switch (_themeMode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}

