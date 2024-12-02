import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shtak/src/audio/models/sound_option.dart';
import 'package:shtak/src/audio/services/audio_service.dart';

part 'noise_event.dart';
part 'noise_state.dart';

class NoiseBloc extends Bloc<NoiseEvent, NoiseState> {
  final NoiseMeter _noiseMeter;
  final AudioService _soundService;

  StreamSubscription<NoiseReading>? _noiseSubscription;

  NoiseBloc({required AudioService soundService})
      : _noiseMeter = NoiseMeter(),
        _soundService = soundService,
        super(const NoiseState()) {
    on<StartListening>(_onStartListening);
    on<StopListening>(_onStopListening);
    on<UpdateThreshold>(_onUpdateThreshold);
    on<NoiseReadingReceived>(_onNoiseReadingReceived);
    on<NoiseError>(_onNoiseError);
    on<SelectSound>(_onSelectSound);
    on<LoadSounds>(_onLoadSounds);
    on<AddCustomSound>(_onAddCustomSound);
    on<RemoveCustomSound>(_onRemoveCustomSound);
    add(LoadSounds());

    _init();
  }

  Future<void> _init() async {
    await _soundService.init();
  }

  Future<void> playSoundByPath(String path) async {
    await _soundService.playSoundByPath(path);
  }

  Future<void> playSoundById(String id) async {
    await _soundService.play(id);
  }

  Future<void> _onLoadSounds(LoadSounds event, Emitter<NoiseState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedSoundId = prefs.getString('selected_sound_id');
    await _soundService.init();
    emit(state.copyWith(
      availableSounds: _soundService.availableSounds,
      selectedSoundId: savedSoundId ?? _soundService.availableSounds.keys.first,
    ));
  }

  Future<void> _onSelectSound(
      SelectSound event, Emitter<NoiseState> emit) async {
    emit(state.copyWith(selectedSoundId: event.soundId));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_sound_id', event.soundId ?? 'basic_shush');
  }

  Future<void> _onAddCustomSound(
      AddCustomSound event, Emitter<NoiseState> emit) async {
    await _soundService.addCustomSound(event.filename, event.nickname);
    emit(state.copyWith(
      availableSounds: _soundService.availableSounds,
    ));
  }

  Future<void> _onRemoveCustomSound(
      RemoveCustomSound event, Emitter<NoiseState> emit) async {
    await _soundService.removeCustomSound(event.soundId);
    emit(state.copyWith(
      availableSounds: _soundService.availableSounds,
    ));
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
