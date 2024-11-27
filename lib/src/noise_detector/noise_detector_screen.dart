import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtak/src/noise_detector/bloc/noise_bloc.dart';
import 'package:shtak/src/noise_detector/widgets/control_button.dart';
import 'package:shtak/src/noise_detector/widgets/header.dart';
import 'package:shtak/src/noise_detector/widgets/noise_slider.dart';

class NoiseDetectorScreen extends StatelessWidget {
  const NoiseDetectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NoiseDetectorView();
  }
}

class NoiseDetectorView extends StatelessWidget {
  const NoiseDetectorView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<NoiseBloc, NoiseState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: state.currentDB > state.thresholdDB
                  ? [Colors.red.withOpacity(0.3), Colors.black]
                  : [Colors.black, Colors.black],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  const NoiseHeader(),
                  const Spacer(),
                  NoiseSlider(height: height * 0.6),
                  const Spacer(),
                  const ControlButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
