import 'package:audioplayers/audioplayers.dart';

class SoundOption {
  final String id;
  final String name;
  final bool isCustom;

  const SoundOption({
    required this.id,
    required this.name,
    this.isCustom = false,
  });

  factory SoundOption.fromMap(Map<String, dynamic> json) {
    return SoundOption(
      id: json['id'] as String,
      name: json['name'] as String,
      isCustom: json['isCustom'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isCustom': isCustom,
    };
  }

  @override
  String toString() {
    return 'SoundOption{id: $id, name: $name, isCustom: $isCustom}';
  }
}
