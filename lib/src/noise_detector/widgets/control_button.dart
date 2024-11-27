import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtak/src/noise_detector/bloc/noise_bloc.dart';

class ControlButton extends StatelessWidget {
  const ControlButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoiseBloc, NoiseState>(
      buildWhen: (previous, current) =>
          previous.isListening != current.isListening,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: ElevatedButton(
            onPressed: () {
              context.read<NoiseBloc>().add(
                    state.isListening ? StopListening() : StartListening(),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: state.isListening ? Colors.red : Colors.indigo,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              state.isListening ? 'STOP' : 'START',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}
