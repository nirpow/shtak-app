import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shtak/src/audio/models/sound_option.dart';

import 'dart:convert';

import 'audio_service.dart';

class SoundsPlayerService implements AudioService {
  final AudioPlayer _player;
  final Map<String, SoundOption> _sounds;

  SoundsPlayerService()
      : _player = AudioPlayer(),
        _sounds = {
          // list of all sounds
          'basic_shush':
              const SoundOption(id: "sounds/basic_shush.mp3", name: "Basic"),
          'bracha':
              const SoundOption(id: "sounds/bracha.mp3", name: "Mrs. Bracha"),
        };

  @override
  Future<void> init() async {
    await _player.setVolume(1.0);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? jsonString = prefs.getString('custom_sounds');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      final sounds = decoded
          .map((map) => SoundOption.fromMap(map as Map<String, dynamic>))
          .toList();

      _sounds.addEntries(sounds.map((sound) => MapEntry(sound.id, sound)));
    }
  }

  @override
  Future<void> play(String soundId) async {
    final sound = _sounds[soundId];

    if (sound == null) {
      throw Exception('Sound not found');
    }

    if (sound.isCustom) {
      final directory = await getApplicationDocumentsDirectory();
      await _player
          .setSource(DeviceFileSource('${directory.path}/${sound.id}'));
    } else {
      await _player.setSource(AssetSource(sound.id));
    }
    await _player.resume();
  }

  @override
  Future<void> playSoundByPath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    await _player.setSource(DeviceFileSource('${directory.path}/$filename'));
    await _player.resume();
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }

  @override
  Map<String, SoundOption> get availableSounds => Map.unmodifiable(_sounds);

  @override
  Future<void> addCustomSound(String filename, String nickname) async {
    final newSounds = SoundOption(
      id: filename,
      name: nickname,
      isCustom: true,
    );
    _sounds[filename] = newSounds;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? jsonString = prefs.getString('custom_sounds');
    final List<dynamic> decoded =
        jsonString == null ? [] : jsonDecode(jsonString);
    final sounds = decoded
        .map((map) => SoundOption.fromMap(map as Map<String, dynamic>))
        .toList();
    sounds.add(newSounds);

    final List<Map<String, dynamic>> mapList =
        sounds.map((sound) => sound.toMap()).toList();
    await prefs.setString('custom_sounds', jsonEncode(mapList));
  }
}
