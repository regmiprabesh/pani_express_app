import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pani_express/blocs/language/language_event.dart';
import 'package:pani_express/blocs/language/language_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const String _languagePreferenceKey = 'app_language';

  LanguageBloc() : super(LanguageState.initial()) {
    on<LanguageLoaded>(_onLanguageLoaded);
    on<LanguageChanged>(_onLanguageChanged);

    // Load saved language when bloc is created
    add(LanguageLoaded());
  }

  Future<void> _onLanguageLoaded(
    LanguageLoaded event,
    Emitter<LanguageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString(_languagePreferenceKey);

    if (language != null) {
      emit(state.copyWith(locale: Locale(language, '')));
    }
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<LanguageState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languagePreferenceKey, event.locale.languageCode);

    emit(state.copyWith(locale: event.locale));
  }
}
