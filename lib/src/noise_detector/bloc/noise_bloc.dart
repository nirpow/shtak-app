import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shtak/src/sound/services/sound_service.dart';

part 'noise_event.dart';
part 'noise_state.dart';

class NoiseBloc extends Bloc<NoiseEvent, NoiseState> {
  final NoiseMeter _noiseMeter;
  final SoundService _soundService;
  StreamSubscription<NoiseReading>? _noiseSubscription;

  NoiseBloc({required SoundService soundService})
      : _noiseMeter = NoiseMeter(),
        _soundService = soundService,
        super(const NoiseState()) {
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<UpdateThreshold>(_onUpdateThreshold);
    on<NoiseReadingReceived>(_onNoiseReadingReceived);
    on<NoiseError>(_onNoiseError);
    on<UpdateSound>(_onUpdateSound);
    _init();
  }

  Future<void> _init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final selectedSoundId = prefs.getString('selectedSoundId');
    if (state.selectedSoundId != selectedSoundId) {
      add(UpdateSound(selectedSoundId));
    }
    await _soundService.init();
  }

  Future<void> _onUpdateSound(
      UpdateSound event, Emitter<NoiseState> emit) async {
    emit(state.copyWith(selectedSoundId: event.soundId));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedSoundId', event.soundId ?? 'basic_shush');
  }

  Future<void> _onStartListening(
      StartListening event, Emitter<NoiseState> emit) async {
    final hasPermission = await Permission.microphone.request();
    if (!hasPermission.isGranted) {
      emit(state.copyWith(
        error: 'Microphone permission denied',
        isListening: false,
      ));
      return;
    }

    try {
      _noiseSubscription = _noiseMeter.noise.listen(
        (NoiseReading reading) {
          add(NoiseReadingReceived(reading.maxDecibel));
        },
        onError: (Object error) {
          add(NoiseError(error.toString()));
        },
      );

      emit(state.copyWith(
        isListening: true,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isListening: false,
      ));
    }
  }

  Future<void> _onStopListening(
      StopListening event, Emitter<NoiseState> emit) async {
    _noiseSubscription?.cancel();
    emit(state.copyWith(
      isListening: false,
      currentDB: 0.0,
      error: null,
    ));
  }

  void _onUpdateThreshold(UpdateThreshold event, Emitter<NoiseState> emit) {
    emit(state.copyWith(thresholdDB: event.threshold));
  }

  Future<void> _onNoiseReadingReceived(
    NoiseReadingReceived event,
    Emitter<NoiseState> emit,
  ) async {
    final isOverThreshold = event.decibels > state.thresholdDB;

    if (isOverThreshold && state.canPlaySound) {
      await _soundService.play(state.selectedSoundId);
      emit(state.copyWith(canPlaySound: false));
    } else if (!isOverThreshold && !state.canPlaySound) {
      emit(state.copyWith(canPlaySound: true));
    }

    emit(state.copyWith(
      currentDB: event.decibels,
      error: null,
    ));
  }

  void _onNoiseError(NoiseError event, Emitter<NoiseState> emit) {
    emit(state.copyWith(
      error: event.message,
      isListening: false,
    ));
  }

  @override
  Future<void> close() async {
    await _noiseSubscription?.cancel();
    await _soundService.dispose();
    return super.close();
  }
}
