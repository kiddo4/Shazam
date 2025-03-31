import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository();
});

class MovieRepository {
  static const String _moviesKey = 'recognized_movies';
  
  Future<List<Map<String, String>>> getRecognizedMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final moviesJson = prefs.getStringList(_moviesKey) ?? [];
    
    return moviesJson
        .map((json) => Map<String, String>.from(jsonDecode(json)))
        .toList();
  }
  
  Future<void> addRecognizedMovie(Map<String, String> movie) async {
    final prefs = await SharedPreferences.getInstance();
    final moviesJson = prefs.getStringList(_moviesKey) ?? [];
    
    // Add timestamp if not present
    if (!movie.containsKey('timestamp')) {
      movie['timestamp'] = DateTime.now().toString();
    }
    
    // Convert to JSON string
    final movieJson = jsonEncode(movie);
    
    // Check if movie already exists by title
    final exists = moviesJson.any((json) {
      final existingMovie = Map<String, String>.from(jsonDecode(json));
      return existingMovie['title'] == movie['title'];
    });
    
    // Add to list if not already present
    if (!exists) {
      moviesJson.add(movieJson);
      await prefs.setStringList(_moviesKey, moviesJson);
    }
  }
  
  Future<void> removeRecognizedMovie(Map<String, String> movie) async {
    final prefs = await SharedPreferences.getInstance();
    final moviesJson = prefs.getStringList(_moviesKey) ?? [];
    
    // Remove movie with matching title
    final updatedMovies = moviesJson.where((json) {
      final existingMovie = Map<String, String>.from(jsonDecode(json));
      return existingMovie['title'] != movie['title'];
    }).toList();
    
    await prefs.setStringList(_moviesKey, updatedMovies);
  }
}