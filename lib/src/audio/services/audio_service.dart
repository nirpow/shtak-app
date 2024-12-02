import 'package:shtak/src/audio/models/sound_option.dart';

abstract class AudioService {
  Future<void> init();
  Future<void> play(String soundId);
  Future<void> playSoundByPath(String path);
  Future<void> dispose();
  Future<void> addCustomSound(String filename, String name);
  Map<String, SoundOption> get availableSounds;
}
