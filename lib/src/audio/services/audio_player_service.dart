import 'package:audioplayers/audioplayers.dart';
import 'package:shtak/src/audio/models/sound_option.dart';

import 'audio_service.dart';

class AudioPlayerService implements AudioService {
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

  @override
  Future<void> init() async {
    // await _player.setVolume(1.0);
    // await _player.setPlayerMode(PlayerMode.lowLatency);
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
  Future<void> playSoundByPath(String path) async {
    await _player.setSourceDeviceFile(path);
    await _player.resume();
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }

  @override
  Map<String, SoundOption> get availableSounds => Map.unmodifiable(_sounds);

  @override
  void addCustomSound(String path, String name) {
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    _sounds[id] = SoundOption(
      id: id,
      name: name,
      assetPath: DeviceFileSource(path),
      isCustom: true,
    );
  }
}
