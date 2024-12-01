import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shtak/src/noise_detector/bloc/noise_bloc.dart';
import 'package:shtak/src/noise_detector/screens/noise_detector_screen.dart';
import 'package:shtak/src/noise_detector/screens/sound_selection_screen.dart';
import 'package:shtak/src/settings/cubit/settings_cubit.dart';
import 'package:shtak/src/settings/cubit/settings_state.dart';
import 'package:shtak/src/settings/views/settings_page.dart';
import 'package:shtak/src/audio/audio_service_factory.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoiseBloc>(
          create: (BuildContext context) => NoiseBloc(
            soundService: AudioServiceFactory.create(),
          ),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp(
            restorationScopeId: 'app',
            locale: settingsState.locale,
            // Localization setup
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context).appTitle,

            // Theme configuration
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
            ),

            // Route generation
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SoundSelectionScreen.routeName:
                      return const SoundSelectionScreen();
                    case SettingsPage.routeName:
                      return const SettingsPage();
                    case '/':
                    default:
                      return const NoiseDetectorScreen();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
