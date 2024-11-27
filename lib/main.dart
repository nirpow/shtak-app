import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtak/src/settings/cubit/settings_cubit.dart';
import 'package:shtak/src/settings/services/settings_service.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure that the app is in portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Set up the SettingsService
  final settingsService = SettingsService();

  // Run the app and provide the SettingsCubit
  runApp(
    BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(settingsService)..loadSettings(),
      child: const MyApp(),
    ),
  );
}
