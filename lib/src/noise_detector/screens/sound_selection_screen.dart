import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shtak/src/noise_detector/bloc/noise_bloc.dart';
import 'package:shtak/src/noise_detector/widgets/record_sound_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SoundSelectionScreen extends StatefulWidget {
  static const routeName = '/sounds';
  const SoundSelectionScreen({super.key});

  @override
  SoundSelectionScreenState createState() => SoundSelectionScreenState();
}

class SoundSelectionScreenState extends State<SoundSelectionScreen> {
  String? selectedSoundId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: CupertinoNavigationBarBackButton(
          color: CupertinoColors.white,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(AppLocalizations.of(context).select_sound,
            style: const TextStyle(color: Colors.white)),
      ),
      body: BlocBuilder<NoiseBloc, NoiseState>(
        builder: (context, state) {
          final sounds = state.availableSounds.keys.toList();
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.availableSounds.length,
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
                          state.availableSounds[sounds[index]]!.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.play_arrow, color: Colors.blue),
                          onPressed: () {
                            context
                                .read<NoiseBloc>()
                                .playSoundById(sounds[index]);
                          },
                        ),
                        selected: selectedSoundId == sounds[index],
                        selectedTileColor: Colors.blue.withOpacity(0.2),
                        onTap: () {
                          context
                              .read<NoiseBloc>()
                              .add(SelectSound(sounds[index]));
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const RecordSoundDialog(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.mic, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context).record_your_own,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
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
