/* Flutter Imports */
import 'package:flutter/material.dart';

/* Package Imports */
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* Project Imports */
import 'package:prism/core/themes/theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme';

  ThemeCubit() : super(ThemeInitialState()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey) ?? 'light';
    final themeData = themeString == 'dark' ? CustomTheme.dark : CustomTheme.light;
    emit(ThemeChangedState(themeData));
  }

  Future<void> update(ThemeData themeData) async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = themeData.brightness == Brightness.dark ? 'dark' : 'light';
    await prefs.setString(_themeKey, themeString);
    emit(ThemeChangedState(themeData));
  }
}
