import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box preferencesBox;

  ThemeCubit(this.preferencesBox) : super(_loadInitialTheme(preferencesBox)) {
    _saveThemeMode(state);
  }

  static ThemeMode _loadInitialTheme(Box box) {
    final savedTheme = box.get('theme_mode', defaultValue: 'system');
    switch (savedTheme) {
      case 'light': return ThemeMode.light;
      case 'dark': return ThemeMode.dark;
      default: return ThemeMode.system;
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = _getNextThemeMode(state);
    emit(newTheme);
    await _saveThemeMode(newTheme);
  }

  ThemeMode _getNextThemeMode(ThemeMode current) {
    switch (current) {
      case ThemeMode.light: return ThemeMode.dark;
      case ThemeMode.dark: return ThemeMode.system;
      case ThemeMode.system: return ThemeMode.light;
    }
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final value = themeMode == ThemeMode.light ? 'light' :
    themeMode == ThemeMode.dark ? 'dark' : 'system';
    await preferencesBox.put('theme_mode', value);
  }
}