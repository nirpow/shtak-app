import 'package:flutter/material.dart';
import 'package:shtak/src/noise_detector/bloc/noise_bloc.dart';
import 'package:shtak/src/audio/services/recorder_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordSoundDialog extends StatefulWidget {
  const RecordSoundDialog({super.key});

  @override
  State<RecordSoundDialog> createState() => _RecordSoundDialogState();
}

class _RecordSoundDialogState extends State<RecordSoundDialog> {
  final _recorder = RecorderService();
  bool _isRecording = false;
  String? _recordedFilename;
  bool _hasRecording = false;
  final _nameController = TextEditingController();
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_currentStep == 0) ...[
              const Text(
                'Record Custom Sound',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording ? Colors.red : Colors.white24,
                ),
                child: IconButton(
                  iconSize: 36,
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                  ),
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
              ),
              if (_hasRecording) ...[
                const SizedBox(height: 16),
                IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  onPressed: () {
                    if (_recordedFilename != null) {
                      context
                          .read<NoiseBloc>()
                          .playSoundByPath(_recordedFilename!);
                    }
                  },
                  // onPressed: null,
                ),
              ],
              const SizedBox(height: 24),
              Text(
                _isRecording ? 'Recording...' : 'Tap to Record',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              if (_hasRecording) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => setState(() => _currentStep = 1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child:
                      const Text('Next', style: TextStyle(color: Colors.black)),
                ),
              ],
            ] else ...[
              const Text(
                'Name Your Sound',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter sound name',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _currentStep = 0),
                    child: Text(
                      'Back',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ValueListenableBuilder(
                      valueListenable: _nameController,
                      builder: (context, value, child) {
                        return ElevatedButton(
                          // onPressed: _saveRecording,
                          onPressed: _nameController.text.trim().isNotEmpty
                              ? _saveRecording
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('Save'),
                        );
                      }),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      _recordedFilename = await _recorder.startRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Something went wrong. Please try again."),
      ));
    }
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecording();
    setState(() {
      _isRecording = false;
      _hasRecording = true;
    });
  }

  void _saveRecording() {
    if (_recordedFilename != null && _nameController.text.trim().isNotEmpty) {
      context.read<NoiseBloc>().add(
            AddCustomSound(_recordedFilename!, _nameController.text.trim()),
          );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _recorder.dispose();

    super.dispose();
  }
}
