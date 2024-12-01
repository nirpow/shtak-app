import 'package:audioplayers/audioplayers.dart';

class SoundOption {
  final String id;
  final String name;
  final Source assetPath;
  final bool isCustom;

  const SoundOption({
    required this.id,
    required this.name,
    required this.assetPath,
    this.isCustom = false,
  });
}
