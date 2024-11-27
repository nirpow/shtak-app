import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtak/src/noise_detector/bloc/noise_bloc.dart';

class NoiseHeader extends StatelessWidget {
  const NoiseHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
            color: Colors.white54,
          ),
          BlocBuilder<NoiseBloc, NoiseState>(
            buildWhen: (previous, current) =>
                previous.isListening != current.isListening,
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isListening ? Icons.volume_up : Icons.volume_off,
                ),
                color: state.isListening ? Colors.greenAccent : Colors.white54,
                onPressed: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
