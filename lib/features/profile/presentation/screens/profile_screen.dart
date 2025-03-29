import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mshasam/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<String> _usernameFuture;

  @override
  void initState() {
    super.initState();
    _usernameFuture = _getOrGenerateUsername();
  }

  Future<String> _getOrGenerateUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUsername = prefs.getString('username');

      if (storedUsername != null) {
        return storedUsername;
      }

      final username = _generateUsername();
      await prefs.setString('username', username);
      return username;
    } catch (e) {
      // Fallback to generate a new username if storage fails
      return _generateUsername();
    }
  }

  String _generateUsername() {
    final adjectives = [
      'Curious',
      'Mystic',
      'Cinematic',
      'Adventurous'
          'Stellar',
      'Epic',
      'Golden',
      'Silver',
    ];

    final nouns = [
      'Cinephile',
      'Viewer',
      'Explorer',
      'Watcher',
      'Director',
      'Producer',
      'Wizard',
    ];

    // Simple random selection
    final adjective =
        adjectives[DateTime.now().microsecond % adjectives.length];
    final noun = nouns[DateTime.now().second % nouns.length];

    return '$adjective$noun';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<String>(
        future: _usernameFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: AppColors.text),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No username found',
                style: TextStyle(color: AppColors.text),
              ),
            );
          }

          final username = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.background,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
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
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Text(
                        username.substring(0, 2),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ).animate().fadeIn().scale(delay: 200.ms),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                              ),
                    ).animate().fadeIn().slideY(
                          begin: 0.3,
                          end: 0,
                          delay: 300.ms,
                        ),
                    const SizedBox(height: 8),
                    Text(
                      'Movie Explorer',
                      style: TextStyle(
                        color: AppColors.text.withOpacity(0.7),
                      ),
                    ).animate().fadeIn().slideY(
                          begin: 0.3,
                          end: 0,
                          delay: 400.ms,
                        ),
                    const SizedBox(height: 24),
                    // Stats Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('12', 'Movies\nRecognized'),
                          _buildStatItem('3', 'This\nWeek'),
                          _buildStatItem('2', 'Day\nStreak'),
                        ],
                      ),
                    ).animate().fadeIn(delay: 500.ms),

                    const SizedBox(height: 32),
                    // Settings Section
                    // ..._buildSettingsSection(context),

                    const SizedBox(height: 32),
                    // App Info Section
                    ..._buildAppInfoSection(context),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSettingsSection(BuildContext context) {
    return [
      _buildSectionHeader('Settings'),
      _buildSettingsTile(
        icon: Icons.palette_outlined,
        title: 'App Theme',
        subtitle: 'Dark',
        onTap: () {},
      ),
      _buildSettingsTile(
        icon: Icons.notifications_outlined,
        title: 'Notifications',
        subtitle: 'Enabled',
        onTap: () {},
      ),
      _buildSettingsTile(
        icon: Icons.language_outlined,
        title: 'Language',
        subtitle: 'English',
        onTap: () {},
      ),
    ];
  }

  List<Widget> _buildAppInfoSection(BuildContext context) {
    return [
      _buildSectionHeader('App Info'),
      _buildSettingsTile(
        icon: Icons.info_outline,
        title: 'About MShasam',
        subtitle: 'Version 1.0.0',
        onTap: () {},
      ),
      _buildSettingsTile(
        icon: Icons.privacy_tip_outlined,
        title: 'Privacy Policy',
        onTap: () {},
      ),
      _buildSettingsTile(
        icon: Icons.help_outline,
        title: 'Help & Support',
        onTap: () {},
      ),
    ];
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).animate().fadeIn().slideX(begin: -0.2, end: 0);
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(color: AppColors.text.withOpacity(0.7)),
                )
              : null,
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.primary,
          ),
          onTap: onTap,
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.2, end: 0);
  }
}
