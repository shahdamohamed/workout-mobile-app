import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider to manage and persist completed workouts.
class WorkoutProgressProvider with ChangeNotifier {
  /// Internal list to store completed workouts.
  final List<Map<String, dynamic>> _completedWorkouts = [];

  /// Public getter for completed workouts.
  List<Map<String, dynamic>> get completedWorkouts => _completedWorkouts;

  /// Constructor: Loads completed workouts from persistent storage.
  WorkoutProgressProvider() {
    _loadCompletedWorkouts();
  }

  /// Loads completed workouts from SharedPreferences.
  Future<void> _loadCompletedWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('completed_workouts');
    if (data != null) {
      final List<dynamic> workouts = json.decode(data);
      _completedWorkouts
          .addAll(workouts.map((workout) => workout as Map<String, dynamic>));
    }
    notifyListeners();
  }

  /// Adds a completed workout for a specific day and exercise.
  Future<void> addCompletedWorkout(String day, String exerciseName) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    final workout = {
      'day': day,
      'exercise': exerciseName,
      'date': now.toIso8601String(),
      'time':
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
    };

    // Remove any existing entries for this exercise on the same day
    _completedWorkouts.removeWhere((existing) =>
        existing['day'] == day && existing['exercise'] == exerciseName);

    // Add the new workout
    _completedWorkouts.add(workout);

    // Sort workouts by date (newest first)
    _completedWorkouts.sort((a, b) {
      final dateA = DateTime.parse(a['date']!);
      final dateB = DateTime.parse(b['date']!);
      return dateB.compareTo(dateA); // Newest first
    });

    // Save to persistent storage
    await prefs.setString(
        'completed_workouts', json.encode(_completedWorkouts));

    notifyListeners();
  }

  /// Clears all completed workouts from memory and persistent storage.
  Future<void> clearCompletedWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    _completedWorkouts.clear();
    await prefs.remove('completed_workouts');
    notifyListeners();
  }

  /// Checks if a specific exercise is completed on a given day.
  bool isExerciseCompleted(String day, String exerciseName) {
    return _completedWorkouts.any((workout) =>
        workout['day'] == day && workout['exercise'] == exerciseName);
  }
}
