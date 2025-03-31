import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

final audioRecognitionProvider = Provider<AudioRecognitionService>((ref) {
  return AudioRecognitionService();
});

enum RecognitionState { idle, listening, recognizing, recognized, error }

class AudioRecognitionService {
  final _audioRecorder = AudioRecorder();
  RecognitionState _state = RecognitionState.idle;
  Timer? _recordingTimer;

  RecognitionState get state => _state;

  Future<bool> checkPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> startListening() async {
    if (!await checkPermission()) {
      _state = RecognitionState.error;
      return;
    }

    try {
      _state = RecognitionState.listening;
      final config = RecordConfig();
      final path = 'path_to_audio_file.m4a';
      await _audioRecorder.start(config, path: path);

      // Record for 10 seconds then process
      _recordingTimer = Timer(const Duration(seconds: 10), () async {
        await stopListening();
      });
    } catch (e) {
      _state = RecognitionState.error;
    }
  }

  Future<Map<String, String>?> stopListening() async {
    _recordingTimer?.cancel();
    _state = RecognitionState.recognizing;

    try {
      final path = await _audioRecorder.stop();
      if (path == null) return null;

      // Here we would send the audio to an API for recognition
      // For now, we'll simulate a response
      await Future.delayed(const Duration(seconds: 2));

      // Simulate a recognized movie
      final recognizedMovie = {
        'title': 'Inception',
        'year': '2010',
        'timestamp': DateTime.now().toString(),
        'posterUrl':
            'https://image.tmdb.org/t/p/w500/8IB2e4r4oVhHnANbnm7O3Tj4dYz.jpg',
      };

      _state = RecognitionState.recognized;
      return recognizedMovie;
    } catch (e) {
      _state = RecognitionState.error;
      return null;
    }
  }

  void reset() {
    _state = RecognitionState.idle;
  }

  Future<void> dispose() async {
    _recordingTimer?.cancel();
    await _audioRecorder.dispose();
  }
}
