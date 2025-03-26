import 'package:dartz/dartz.dart';

abstract class AudioRepository {
  Future<Either<String, bool>> startRecording();
  Future<Either<String, bool>> stopRecording();
  Future<bool> isRecording();
}
