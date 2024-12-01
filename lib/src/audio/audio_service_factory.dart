import 'package:shtak/src/audio/services/audio_player_service.dart';
import 'package:shtak/src/audio/services/audio_service.dart';

class AudioServiceFactory {
  static AudioService create() {
    return AudioPlayerService();
  }
}
