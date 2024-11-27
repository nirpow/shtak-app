part of 'noise_bloc.dart';

class NoiseState extends Equatable {
  final double currentDB;
  final double thresholdDB;
  final bool isListening;
  final String? error;
  final String selectedSoundId;
  final bool canPlaySound;

  const NoiseState({
    this.currentDB = 0.0,
    this.thresholdDB = 65.0,
    this.isListening = false,
    this.error,
    this.selectedSoundId = 'basic_shush',
    this.canPlaySound = true,
  });

  NoiseState copyWith({
    double? currentDB,
    double? thresholdDB,
    bool? isListening,
    String? error,
    String? selectedSoundId,
    bool? canPlaySound,
  }) {
    return NoiseState(
      currentDB: currentDB ?? this.currentDB,
      thresholdDB: thresholdDB ?? this.thresholdDB,
      isListening: isListening ?? this.isListening,
      error: error,
      selectedSoundId: selectedSoundId ?? this.selectedSoundId,
      canPlaySound: canPlaySound ?? this.canPlaySound,
    );
  }

  @override
  List<Object?> get props => [
        currentDB,
        thresholdDB,
        isListening,
        error,
        selectedSoundId,
        canPlaySound,
      ];
}
