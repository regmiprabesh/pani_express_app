import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pani_express/blocs/theme/theme_event.dart';
import 'package:pani_express/blocs/theme/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themePreferenceKey = 'app_theme';

  ThemeBloc() : super(ThemeState.initial()) {
    on<ThemeLoaded>(_onThemeLoaded);
    on<ThemeChanged>(_onThemeChanged);

    // Load saved theme when bloc is created
    add(ThemeLoaded());
  }

  Future<void> _onThemeLoaded(
    ThemeLoaded event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themePreferenceKey);

    if (themeIndex != null) {
      final themeMode = ThemeMode.values[themeIndex];
      emit(state.copyWith(themeMode: themeMode));
    }
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePreferenceKey, event.themeMode.index);

    emit(state.copyWith(themeMode: event.themeMode));
  }
}
