import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mshasam/core/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MShasam',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme.copyWith(
                displayLarge: const TextStyle(
                  fontSize: 48,
                  letterSpacing: 0.5,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
                displayMedium: const TextStyle(
                  fontSize: 36,
                  letterSpacing: 0.3,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
                displaySmall: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 0.2,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
                headlineMedium: const TextStyle(
                  fontSize: 20,
                  letterSpacing: 0.2,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
                titleLarge: const TextStyle(
                  fontSize: 18,
                  letterSpacing: 0.1,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
                bodyLarge: const TextStyle(
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: FontWeight.w400,
                ),
                bodyMedium: const TextStyle(
                  fontSize: 14,
                  height: 1.2,
                  fontWeight: FontWeight.w400,
                ),
              ),
        ),
      ),
      home: const SplashScreen(), // This will navigate to MainScreen after splash
    );
  }
}

