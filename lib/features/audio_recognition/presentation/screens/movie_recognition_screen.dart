import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mshasam/core/constants/app_colors.dart';
import 'package:mshasam/features/audio_recognition/data/repositories/audio_repository_impl.dart';

class MovieRecognitionScreen extends ConsumerStatefulWidget {
  const MovieRecognitionScreen({super.key});

  @override
  ConsumerState<MovieRecognitionScreen> createState() =>
      _MovieRecognitionScreenState();
}

class _MovieRecognitionScreenState
    extends ConsumerState<MovieRecognitionScreen> {
  bool _isListening = false;

  void _toggleListening() async {
    final audioRepository = ref.read(audioRepositoryProvider);

    if (_isListening) {
      final result = await audioRepository.stopRecording();
      result.fold(
        (error) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        ),
        (_) => setState(() => _isListening = false),
      );
    } else {
      final result = await audioRepository.startRecording();
      result.fold(
        (error) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        ),
        (_) => setState(() => _isListening = true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Enhanced gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.background,
                ],
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
                    _isListening
                        ? 'Listening for Movies...'
                        : 'Tap to Discover Movies',
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
                    _isListening
                        ? 'Playing something?'
                        : 'Hold tight while we identify your movie',
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
                  const Spacer(),
                  // Enhanced button animations
                  GestureDetector(
                    onTap: _toggleListening,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_isListening)
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
                            color: _isListening
                                ? AppColors.primary
                                : AppColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_isListening
                                        ? AppColors.primary
                                        : AppColors.surface)
                                    .withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 15,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isListening ? Icons.movie : Icons.movie_outlined,
                            size: 90,
                            color: _isListening ? Colors.white : AppColors.text,
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

                  Spacer(),
                  // Enhanced footer
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
