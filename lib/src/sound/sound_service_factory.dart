import 'package:shtak/src/sound/services/audio_player_service.dart';
import 'package:shtak/src/sound/services/sound_service.dart';

class SoundServiceFactory {
  static SoundService create() {
    return AudioPlayerService();
  }
}
