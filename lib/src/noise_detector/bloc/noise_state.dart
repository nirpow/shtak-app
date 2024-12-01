part of 'noise_bloc.dart';

class NoiseState extends Equatable {
  final double currentDB;
  final double thresholdDB;
  final bool isListening;
  final String? error;
  final String selectedSoundId;
  final bool canPlaySound;
  final Map<String, SoundOption> availableSounds;

  const NoiseState({
    this.currentDB = 0.0,
    this.thresholdDB = 65.0,
    this.isListening = false,
    this.error,
    this.selectedSoundId = 'basic_shush',
    this.canPlaySound = true,
    this.availableSounds = const {},
  });

  NoiseState copyWith({
    double? currentDB,
    double? thresholdDB,
    bool? isListening,
    String? error,
    String? selectedSoundId,
    bool? canPlaySound,
    Map<String, SoundOption>? availableSounds,
  }) {
    return NoiseState(
        currentDB: currentDB ?? this.currentDB,
        thresholdDB: thresholdDB ?? this.thresholdDB,
        isListening: isListening ?? this.isListening,
        error: error,
        selectedSoundId: selectedSoundId ?? this.selectedSoundId,
        canPlaySound: canPlaySound ?? this.canPlaySound,
        availableSounds: availableSounds ?? this.availableSounds);
  }

  @override
  List<Object?> get props => [
        currentDB,
        thresholdDB,
        isListening,
        error,
        selectedSoundId,
        canPlaySound,
        availableSounds
      ];
}
