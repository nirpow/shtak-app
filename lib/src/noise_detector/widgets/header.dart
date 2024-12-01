import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtak/src/noise_detector/bloc/noise_bloc.dart';
import 'package:shtak/src/noise_detector/screens/sound_selection_screen.dart';
import 'package:shtak/src/settings/views/settings_page.dart';

class NoiseHeader extends StatelessWidget {
  const NoiseHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: BlocBuilder<NoiseBloc, NoiseState>(
        buildWhen: (previous, current) =>
            previous.isListening != current.isListening,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.settings_outlined,
                  size: 32,
                ),
                onPressed: () {
                  if (state.isListening) {
                    context.read<NoiseBloc>().add(StopListening());
                  }
                  Navigator.of(context).pushNamed(SettingsPage.routeName);
                },
                color: Colors.white60,
              ),
              IconButton(
                icon: const Icon(
                  Icons.record_voice_over_rounded,
                  size: 32,
                ),
                onPressed: () {
                  if (state.isListening) {
                    context.read<NoiseBloc>().add(StopListening());
                  }
                  Navigator.of(context)
                      .pushNamed(SoundSelectionScreen.routeName);
                },
                color: Colors.white60,
              ),
            ],
          );
        },
      ),
    );
  }
}
