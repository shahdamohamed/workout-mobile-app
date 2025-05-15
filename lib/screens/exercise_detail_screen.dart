import 'package:flutter/material.dart';
import '../models/exercise.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;
  final String heroTag;

  const ExerciseDetailScreen({super.key, required this.exercise, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  exercise.gifUrl,
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
            Text(
              exercise.name.toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text("🎯 Target: ${exercise.target}", style: const TextStyle(fontSize: 16)),
            Text("🏋️ Equipment: ${exercise.equipment}", style: const TextStyle(fontSize: 16)),
            Text("💪 Body Part: ${exercise.bodyPart}", style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
