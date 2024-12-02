part of 'noise_bloc.dart';

abstract class NoiseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSounds extends NoiseEvent {}

class StartListening extends NoiseEvent {}

class StopListening extends NoiseEvent {}

class UpdateThreshold extends NoiseEvent {
  final double threshold;

  UpdateThreshold(this.threshold);

  @override
  List<Object?> get props => [threshold];
}

class SelectSound extends NoiseEvent {
  final String? soundId;

  SelectSound(this.soundId);

  @override
  List<Object?> get props => [soundId];
}

class NoiseReadingReceived extends NoiseEvent {
  final double decibels;

  NoiseReadingReceived(this.decibels);

  @override
  List<Object?> get props => [decibels];
}

class AddCustomSound extends NoiseEvent {
  final String filename;
  final String nickname;

  AddCustomSound(this.filename, this.nickname);

  @override
  List<Object?> get props => [filename, nickname];
}

class NoiseError extends NoiseEvent {
  final String message;

  NoiseError(this.message);

  @override
  List<Object?> get props => [message];
}
