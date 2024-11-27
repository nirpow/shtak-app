import 'package:audioplayers/audioplayers.dart';

import 'sound_service.dart';

class AudioPlayerService implements SoundService {
  final AudioPlayer _player;
  final Map<String, AssetSource> _sounds;

  AudioPlayerService()
      : _player = AudioPlayer(),
        _sounds = {
          // list of all sounds
          'shush': AssetSource('sounds/basic_shush.mp3'),
        };

  @override
  Future<void> init() async {
    await _player.setVolume(1.0);
  }

  @override
  Future<void> play(String soundId) async {
    final sound = _sounds[soundId];
    if (sound != null) {
      await _player.setSource(sound);
      await _player.resume();
    }
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }
}
