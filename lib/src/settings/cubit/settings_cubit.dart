import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shtak/src/settings/services/settings_service.dart';
import 'settings_state.dart';
import 'dart:ui' as ui;

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsService _settingsService;

  SettingsCubit(this._settingsService)
      : super(SettingsState(
            locale: _getDeviceLocale(), isLogoutRequested: false));

  Future<void> loadSettings() async {
    final locale = await _settingsService.locale();
    emit(state.copyWith(locale: locale));
  }

  Future<void> updateLanguage(Locale newLocale) async {
    if (newLocale == ui.PlatformDispatcher.instance.locale) {
      emit(state.copyWith(locale: null));
    } else {
      await _settingsService.updateLanguage(newLocale.languageCode);
      emit(state.copyWith(locale: newLocale));
    }
  }

  static Locale _getDeviceLocale() {
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    if (['en', 'he'].contains(deviceLocale.languageCode)) {
      return deviceLocale;
    }
    return const Locale('en', '');
  }

  Future<void> resetSettings() async {
    await _settingsService.resetSettings();
    await loadSettings();
  }
}
