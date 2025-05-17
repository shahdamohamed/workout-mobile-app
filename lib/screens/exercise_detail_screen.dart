import 'package:flutter/material.dart';
import '../models/exercise.dart';

/// Screen that displays detailed information about a specific exercise.
class ExerciseDetailScreen extends StatefulWidget {
  /// The exercise to display details for.
  final Exercise exercise;

  /// The tag used for the Hero animation.
  final String heroTag;

  /// Creates an [ExerciseDetailScreen].
  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    required this.heroTag,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Display the exercise name in the app bar.
        title: Text(
          widget.exercise.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Hero animation for the exercise image.
            Hero(
              tag: widget.heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.exercise.gifUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Image not available');
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Exercise name in uppercase, bold and centered.
            Text(
              widget.exercise.name.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Exercise details: target, equipment, and body part.
            Text(
              "🎯 Target: ${widget.exercise.target}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "🏋️ Equipment: ${widget.exercise.equipment}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "💪 Body Part: ${widget.exercise.bodyPart}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
