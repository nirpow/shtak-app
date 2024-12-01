import 'package:shtak/src/audio/models/sound_option.dart';

abstract class AudioService {
  Future<void> init();
  Future<void> play(String soundId);
  Future<void> playSoundByPath(String path);
  Future<void> dispose();
  void addCustomSound(String path, String name);
  Map<String, SoundOption> get availableSounds;
}
