import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mshasam/core/constants/app_colors.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary movie data for demonstration
    final movies = [
      {'title': 'Inception', 'year': '2010', 'timestamp': '2 hours ago'},
      {'title': 'Black panther', 'year': '2020', 'timestamp': '1 hour ago'},
      {'title': 'Inception', 'year': '2010', 'timestamp': '2 hours ago'},
      {'title': 'The Dark Knight', 'year': '2008', 'timestamp': '5 hours ago'},
      {'title': 'Interstellar', 'year': '2014', 'timestamp': 'Yesterday'},
      {'title': 'avenegers', 'year': '2013', 'timestamp': '2 weeks ago'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Your Library',
                style: TextStyle(color: Colors.white),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0),
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 90),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final movie = movies[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
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
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.movie,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(
                          movie['title']!,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              movie['year']!,
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              movie['timestamp']!,
                              style: TextStyle(
                                color: AppColors.text.withOpacity(0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                           
                          },
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: (100 * index).milliseconds)
                      .slideX(begin: 0.2, end: 0);
                },
                childCount: movies.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
