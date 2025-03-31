import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mshasam/core/constants/app_colors.dart';
import 'package:mshasam/features/audio_recognition/data/repositories/audio_repository_impl.dart';
import 'package:mshasam/features/library/presentation/screens/movie_detail_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class MovieRecognitionScreen extends ConsumerStatefulWidget {
  const MovieRecognitionScreen({super.key});

  @override
  ConsumerState<MovieRecognitionScreen> createState() =>
      _MovieRecognitionScreenState();
}

enum RecognitionState { idle, listening, recognizing, recognized, error }

class _MovieRecognitionScreenState
    extends ConsumerState<MovieRecognitionScreen> {
  RecognitionState _state = RecognitionState.idle;
  Map<String, String>? _recognizedMovie;
  String? _errorMessage;

  // Add method to open app settings
  void _openAppSettings() async {
    await openAppSettings();
  }

  void _toggleListening() async {
    final audioRepository = ref.read(audioRepositoryProvider);

    if (_state == RecognitionState.listening) {
      setState(() => _state = RecognitionState.recognizing);

      final result = await audioRepository.stopRecording();
      result.fold(
        (error) {
          setState(() {
            _state = RecognitionState.error;
            _errorMessage = error;
          });
        },
        (movie) {
          setState(() {
            _state = RecognitionState.recognized;
            _recognizedMovie = movie;
          });
        },
      );
    } else if (_state == RecognitionState.idle ||
        _state == RecognitionState.error ||
        _state == RecognitionState.recognized) {
      // Check microphone permission before starting
      final permissionStatus = await Permission.microphone.status;
      if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        final result = await Permission.microphone.request();
        if (!result.isGranted) {
          setState(() {
            _state = RecognitionState.error;
            _errorMessage =
                'Microphone permission denied. Please enable it in settings.';
          });
          return;
        }
      }

      final result = await audioRepository.startRecording();
      result.fold(
        (error) {
          setState(() {
            _state = RecognitionState.error;
            _errorMessage = error;
          });
        },
        (_) {
          setState(() {
            _state = RecognitionState.listening;
            _errorMessage = null;
          });
        },
      );
    }
  }

  void _resetRecognition() {
    setState(() {
      _state = RecognitionState.idle;
      _recognizedMovie = null;
      _errorMessage = null;
    });
  }

  void _viewMovieDetails() {
    if (_recognizedMovie != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailScreen(movie: _recognizedMovie!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.background,
                ],
                // Fixed: 3 stops for 3 colors
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Enhanced title animation
                  Text(
                    _getStatusText(),
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ).animate(
                    effects: [
                      FadeEffect(duration: 600.ms),
                      SlideEffect(
                          begin: const Offset(0, -0.2), end: Offset.zero),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Enhanced subtitle animation
                  Text(
                    _getSubtitleText(),
                    style: TextStyle(
                      color: AppColors.text.withOpacity(0.7),
                      fontSize: 18,
                      letterSpacing: 0.3,
                    ),
                  ).animate(
                    delay: 200.ms,
                    effects: [
                      FadeEffect(duration: 600.ms),
                      SlideEffect(
                          begin: const Offset(0, -0.2), end: Offset.zero),
                    ],
                  ),
                  // Add settings button when permission is denied
                  if (_state == RecognitionState.error &&
                      (_errorMessage?.contains('permission') ?? false))
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: _openAppSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Open Settings'),
                      ),
                    ).animate().fadeIn().scale(),

                  // Existing movie details button
                  if (_state == RecognitionState.recognized &&
                      _recognizedMovie != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: _viewMovieDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('View Movie Details'),
                      ),
                    ).animate().fadeIn().scale(),
                  const Spacer(),
                  // Enhanced button animations
                  GestureDetector(
                    onTap: _state == RecognitionState.recognizing
                        ? null
                        : _toggleListening,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_state == RecognitionState.listening)
                          ...List.generate(
                            3,
                            (index) => Container(
                              width: 240 + (index * 40),
                              height: 240 + (index * 40),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.4),
                                  width: 3,
                                ),
                              ),
                            )
                                .animate(
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .scale(
                                  duration: 2.seconds,
                                  delay: (index * 400).milliseconds,
                                  begin: const Offset(0.6, 0.6),
                                  end: const Offset(1.2, 1.2),
                                  curve: Curves.easeOutCubic,
                                )
                                .fadeOut(
                                  duration: 1.5.seconds,
                                  delay: (index * 400).milliseconds,
                                  curve: Curves.easeOutCubic,
                                ),
                          ),
                        // Enhanced main button
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            color: _getButtonColor(),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _getButtonColor().withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                          child: Icon(
                            _getButtonIcon(),
                            size: 90,
                            color: _state == RecognitionState.listening ||
                                    _state == RecognitionState.recognized
                                ? Colors.white
                                : AppColors.text,
                          ).animate(
                            effects: [
                              ScaleEffect(
                                duration: 300.ms,
                                curve: Curves.easeOutBack,
                              ),
                            ],
                          ),
                        ).animate(
                          onPlay: (controller) => controller.repeat(),
                          effects: [
                            ScaleEffect(
                              duration: 2.seconds,
                              begin: const Offset(0.95, 0.95),
                              end: const Offset(1, 1),
                              curve: Curves.easeInOut,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Enhanced footer
                  Text(
                    'Powered by MShazam',
                    style: TextStyle(
                      color: AppColors.text.withOpacity(0.5),
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ).animate(
                    delay: 400.ms,
                    effects: [
                      FadeEffect(duration: 600.ms),
                      SlideEffect(
                          begin: const Offset(0, 0.2), end: Offset.zero),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (_state) {
      case RecognitionState.idle:
        return 'Tap to Discover Movies';
      case RecognitionState.listening:
        return 'Listening for Movies...';
      case RecognitionState.recognizing:
        return 'Recognizing...';
      case RecognitionState.recognized:
        return 'Found: ${_recognizedMovie?['title'] ?? 'Unknown'}';
      case RecognitionState.error:
        return 'Recognition Failed';
    }
  }

  String _getSubtitleText() {
    switch (_state) {
      case RecognitionState.idle:
        return 'Hold tight while we identify your movie';
      case RecognitionState.listening:
        return 'Playing something?';
      case RecognitionState.recognizing:
        return 'Processing audio...';
      case RecognitionState.recognized:
        return 'Added to your library!';
      case RecognitionState.error:
        return _errorMessage ?? 'Something went wrong';
    }
  }

  Color _getButtonColor() {
    switch (_state) {
      case RecognitionState.listening:
        return Colors.red;
      case RecognitionState.recognizing:
        return Colors.orange;
      case RecognitionState.recognized:
        return Colors.green;
      case RecognitionState.error:
        return Colors.redAccent;
      case RecognitionState.idle:
        return AppColors.surface;
    }
  }

  IconData _getButtonIcon() {
    switch (_state) {
      case RecognitionState.listening:
        return Icons.stop;
      case RecognitionState.recognizing:
        return Icons.hourglass_top;
      case RecognitionState.recognized:
        return Icons.check;
      case RecognitionState.error:
        return Icons.error_outline;
      case RecognitionState.idle:
        return Icons.movie_outlined;
    }
  }
}
