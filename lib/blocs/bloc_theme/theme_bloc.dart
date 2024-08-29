import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';


part 'theme_event.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ThemeChanged>(_onThemeChanged);
  }

  void _onThemeChanged(ThemeChanged even, Emitter<ThemeMode> emit) {
    emit(even.isDark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    // Convert the JSON representation to a ThemeMode
    switch (json['themeMode'] as String?) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // Convert the ThemeMode to a JSON representation
    return {
      'themeMode': state == ThemeMode.dark ? 'dark' : 'light',
    };
  }
}