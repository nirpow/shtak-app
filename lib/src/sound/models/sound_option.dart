import 'package:audioplayers/audioplayers.dart';

class SoundOption {
  final String id;
  final String name;
  final AssetSource assetPath;

  const SoundOption({
    required this.id,
    required this.name,
    required this.assetPath,
  });
}
