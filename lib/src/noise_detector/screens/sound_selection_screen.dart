import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtak/src/noise_detector/bloc/noise_bloc.dart';
import 'package:shtak/src/sound/services/audio_player_service.dart';

class SoundSelectionScreen extends StatefulWidget {
  static const routeName = '/sound';
  const SoundSelectionScreen({super.key});

  @override
  SoundSelectionScreenState createState() => SoundSelectionScreenState();
}

class SoundSelectionScreenState extends State<SoundSelectionScreen> {
  final sounds = AudioPlayerService().availableSounds.keys.toList();
  String? selectedSoundId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title:
            const Text('Select Sound', style: TextStyle(color: Colors.white)),
      ),
      body: BlocBuilder<NoiseBloc, NoiseState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: AudioPlayerService().availableSounds.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: state.selectedSoundId == sounds[index]
                          ? Colors.grey[600]
                          : Colors.grey[900],
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading:
                            const Icon(Icons.music_note, color: Colors.blue),
                        title: Text(
                          AudioPlayerService()
                              .availableSounds[sounds[index]]!
                              .name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.play_arrow, color: Colors.blue),
                          onPressed: () {
                            AudioPlayerService().play(sounds[index]);
                          },
                        ),
                        selected: selectedSoundId == sounds[index],
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                        onTap: () {
                          context
                              .read<NoiseBloc>()
                              .add(UpdateSound(sounds[index]));
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle record functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mic, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Record Your Own',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
