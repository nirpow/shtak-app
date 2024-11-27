import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtak/src/noise_detector/bloc/noise_bloc.dart';

class NoiseSlider extends StatelessWidget {
  final double height;

  const NoiseSlider({super.key, required this.height});

  Color _getColorForDB(double db, NoiseState state) {
    if (db > state.thresholdDB + 10) return Colors.red;
    if (db > state.thresholdDB) return Colors.orange;
    if (db > state.thresholdDB - 10) return Colors.yellow;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoiseBloc, NoiseState>(
      builder: (context, state) {
        return Container(
          height: height,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(
            children: [
              ...List.generate(120 ~/ 5, (index) {
                final db = index * 5.0;
                final color = _getColorForDB(db, state);
                return Positioned(
                  left: 40,
                  right: 40,
                  bottom: (db / 120) * height,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                );
              }),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                left: 40,
                right: 40,
                bottom: (state.currentDB / 120) * height,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color:
                        _getColorForDB(state.currentDB, state).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(1.5),
                    boxShadow: [
                      BoxShadow(
                        color: _getColorForDB(state.currentDB, state)
                            .withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(13, (index) {
                    final value = (120 - (index * 10));
                    return Text(
                      '$value',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    );
                  }),
                ),
              ),
              Center(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 2,
                      activeTrackColor: Colors.green.withOpacity(0.8),
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 16,
                      ),
                    ),
                    child: Slider(
                      min: 0,
                      max: 120,
                      value: state.thresholdDB,
                      onChanged: (value) {
                        context.read<NoiseBloc>().add(UpdateThreshold(value));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
