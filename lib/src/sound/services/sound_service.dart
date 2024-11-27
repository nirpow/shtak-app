abstract class SoundService {
  Future<void> init();
  Future<void> play(String soundId);
  Future<void> dispose();
}
