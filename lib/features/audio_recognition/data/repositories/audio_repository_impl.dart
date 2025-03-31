import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mshasam/features/library/data/repositories/movie_repository.dart';

final audioRepositoryProvider = Provider<AudioRepositoryImpl>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return AudioRepositoryImpl(movieRepository);
});

class AudioRepositoryImpl {
  final _audioRecorder = AudioRecorder();
  final MovieRepository _movieRepository;
  Timer? _recordingTimer;
  bool _isRecording = false;

  AudioRepositoryImpl(this._movieRepository);

  // In your startRecording method, add more debugging and error handling:
  
  Future<Either<String, Unit>> startRecording() async {
    try {
      // Cancel any existing timer
      _recordingTimer?.cancel();
      
      // Stop any ongoing recording
      if (_isRecording) {
        await _audioRecorder.stop();
        _isRecording = false;
      }
      
      // Check permission with more detailed logging
      final status = await Permission.microphone.status;
      print('Current microphone permission status: $status');
  
      if (!status.isGranted) {
        // If not granted, request it
        print('Requesting microphone permission...');
        final result = await Permission.microphone.request();
        print('Permission request result: $result');
  
        if (!result.isGranted) {
          return left(
              'Microphone permission is required. Please enable it in settings.');
        }
      }
  
      // Double check with the recorder
      final isAvailable = await _audioRecorder.hasPermission();
      print('Recorder hasPermission result: $isAvailable');
      
      if (!isAvailable) {
        return left(
            'Microphone is not available. Please check your device settings.');
      }
  
      // Get a proper file path for the recording
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/audio_recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      print('Recording to path: $path');
      
      // Configure recording with better quality
      final config = RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      );
      
      print('Starting recording...');
      await _audioRecorder.start(config, path: path);
      _isRecording = true;
      print('Recording started successfully');
  
      // Record for 10 seconds then process
      _recordingTimer = Timer(const Duration(seconds: 10), () async {
        print('Recording timer completed');
        if (_isRecording) {
          await stopRecording();
        }
      });
  
      return right(unit);
    } catch (e) {
      print('Error starting recording: $e');
      _isRecording = false;
      return left('Failed to start recording: ${e.toString()}');
    }
  }

  Future<Either<String, Map<String, String>>> stopRecording() async {
    _recordingTimer?.cancel();

    try {
      if (!_isRecording) {
        return left('No active recording found');
      }

      final path = await _audioRecorder.stop();
      _isRecording = false;

      if (path == null) {
        return left('No recording data available');
      }

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
        'overview':
            'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
        'director': 'Christopher Nolan',
        'rating': '8.8',
      };

      // Save to repository
      await _movieRepository.addRecognizedMovie(recognizedMovie);

      return right(recognizedMovie);
    } catch (e) {
      _isRecording = false;
      return left('Failed to process recording: ${e.toString()}');
    }
  }

  Future<void> dispose() async {
    _recordingTimer?.cancel();
    if (_isRecording) {
      await _audioRecorder.stop();
      _isRecording = false;
    }
    await _audioRecorder.dispose();
  }
}
