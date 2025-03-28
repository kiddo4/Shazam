import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mshasam/core/constants/app_colors.dart';
import 'package:mshasam/features/audio_recognition/presentation/screens/movie_recognition_screen.dart';
import 'package:mshasam/features/library/presentation/screens/library_screen.dart';
import 'package:mshasam/features/profile/presentation/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  final List<Widget> _screens = [
    const LibraryScreen(),
    const MovieRecognitionScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Scaffold(
          body: _screens[_selectedIndex],
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Material(
                  color: Colors.white
                      .withValues(alpha: 0.2), // Adjust opacity here

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                          0, Icons.library_music_outlined, Icons.library_music),
                      _buildNavItem(1, Icons.movie_outlined, Icons.movie),
                      _buildNavItem(2, Icons.person_outline, Icons.person),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
      int index, IconData unselectedIcon, IconData selectedIcon) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          color:
              isSelected ? AppColors.primary : AppColors.text.withOpacity(0.5),
          size: 28,
        ),
      ),
    );
  }
}
