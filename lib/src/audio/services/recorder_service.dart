import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class RecorderService {
  final _recorder = AudioRecorder();

  Future<String?> startRecording() async {
    try {
      if (!await _recorder.hasPermission()) {
        throw Exception('Permission required');
      }
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/custom_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(const RecordConfig(), path: path);

      return path;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<void> stopRecording() async {
    await _recorder.stop();
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
