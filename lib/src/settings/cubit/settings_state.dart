import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final Locale locale;
  final bool isLogoutRequested;

  const SettingsState({
    required this.locale,
    this.isLogoutRequested = false,
  });

  SettingsState copyWith({
    Locale? locale,
    bool? isLogoutRequested,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      isLogoutRequested: isLogoutRequested ?? this.isLogoutRequested,
    );
  }

  @override
  List<Object> get props => [locale, isLogoutRequested];
}
