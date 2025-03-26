import 'package:flutter/material.dart';
import 'package:mshasam/core/constants/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mshasam/features/audio_recognition/presentation/screens/movie_recognition_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MovieRecognitionScreen(),
            ),
          );
        },
        child: Container(
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
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Logo or Icon
                  Icon(
                    Icons.movie_outlined,
                    size: 120,
                    color: AppColors.text,
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 2.seconds, color: AppColors.primary)
                      .animate()
                      .scale(
                        duration: 1.seconds,
                        curve: Curves.easeOutBack,
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                      ),
                  const SizedBox(height: 40),
                  // App Name
                  Text(
                    "MShasam",
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 1.seconds)
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 16),
                  // Tagline
                  Text(
                    "Where Movie Magic Begins",
                    style: TextStyle(
                      color: AppColors.text.withOpacity(0.7),
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.milliseconds, duration: 1.seconds)
                      .slideY(begin: 0.3, end: 0),
                  const Spacer(),
                  // Bottom text
                  Text(
                    "Tap anywhere to start",
                    style: TextStyle(
                      color: AppColors.text.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .fadeIn(duration: 1.seconds)
                      .then()
                      .fadeOut(duration: 1.seconds),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
