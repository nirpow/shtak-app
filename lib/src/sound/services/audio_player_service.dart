import 'package:audioplayers/audioplayers.dart';
import 'package:shtak/src/sound/models/sound_option.dart';

import 'sound_service.dart';

class AudioPlayerService implements SoundService {
  final AudioPlayer _player;
  final Map<String, SoundOption> _sounds;

  AudioPlayerService()
      : _player = AudioPlayer(),
        _sounds = {
          // list of all sounds
          'basic_shush': SoundOption(
              assetPath: AssetSource('sounds/basic_shush.mp3'),
              id: "basic_shush",
              name: "Basic"),
          'bracha': SoundOption(
              assetPath: AssetSource('sounds/bracha.mp3'),
              id: "bracha",
              name: "Mrs. Bracha"),
        };

  Map<String, SoundOption> get availableSounds => _sounds;

  @override
  Future<void> init() async {
    await _player.setVolume(1.0);
  }

  @override
  Future<void> play(String soundId) async {
    final sound = _sounds[soundId];
    if (sound != null) {
      await _player.setSource(sound.assetPath);
      await _player.resume();
    }
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }
}
