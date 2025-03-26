import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

class AudioRepositoryImpl {
  final AudioRecorder _audioRecorder;

  AudioRepositoryImpl(this._audioRecorder);

  Future<Either<String, bool>> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final path = '/tmp/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);
        return const Right(true);
      }
      return const Left('Microphone permission denied');
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> stopRecording() async {
    try {
      await _audioRecorder.stop();
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<bool> isRecording() async {
    return _audioRecorder.isRecording();
  }
}

final audioRepositoryProvider = Provider((ref) {
  return AudioRepositoryImpl(AudioRecorder());
});
