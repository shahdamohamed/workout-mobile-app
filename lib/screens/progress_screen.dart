import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_progress_provider.dart';

/// Screen to display user's workout progress.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  /// Formats a time string (HH:mm) to 12-hour format with AM/PM.
  static String _formatTime12Hour(String? time) {
    if (time == null) return '';
    final parts = time.split(':');
    if (parts.length != 2) return time;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12;
    final formattedHour = hour12 == 0 ? '12' : hour12.toString();
    return '$formattedHour:$minute $suffix';
  }

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Progress', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        actions: [
          // Button to clear all progress
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final currentContext = context;
              // Show confirmation dialog before clearing progress
              final confirmed = await showDialog(
                context: currentContext,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Progress'),
                  content: const Text(
                    'Are you sure you want to clear all your progress? This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                if (!mounted) return;
                final provider = Provider.of<WorkoutProgressProvider>(
                    currentContext,
                    listen: false);
                await provider.clearCompletedWorkouts();

                if (!mounted) return;
                if (!currentContext.mounted) return;
                // Show a snackbar to confirm progress was cleared
                ScaffoldMessenger.of(currentContext).showSnackBar(
                  const SnackBar(
                    content: Text('Progress cleared successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<WorkoutProgressProvider>(
        builder: (context, provider, child) {
          final workouts = provider.completedWorkouts;

          // Show message if no workouts have been completed
          if (workouts.isEmpty) {
            return const Center(
              child: Text(
                'You haven\'t completed any workouts yet.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // Map to store unique days with their latest completion
          final Map<String, Map<String, dynamic>> uniqueWorkouts = {};
          for (var workout in workouts) {
            final day = workout['day']!;
            uniqueWorkouts[day] = workout;
          }
          final uniqueWorkoutList = uniqueWorkouts.values.toList();

          // List of completed workouts
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: uniqueWorkoutList.length,
              itemBuilder: (context, index) {
                final workout = uniqueWorkoutList[index];
                final date = DateTime.parse(workout['date']);

                return Card(
                  color: Colors.blue.shade700,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading:
                        const Icon(Icons.check_circle, color: Colors.white),
                    title: Text(
                      workout['day'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Workout completion date
                        Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        // Workout completion time
                        Text(
                          ProgressScreen._formatTime12Hour(workout['time']),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
