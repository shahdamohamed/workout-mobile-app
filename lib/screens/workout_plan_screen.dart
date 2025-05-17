import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_progress_provider.dart';

/// Screen displaying the user's weekly workout plan.
class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({super.key});

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen>
    with SingleTickerProviderStateMixin {
  /// List of days and their corresponding workouts.
  final List<Map<String, String>> weeklyPlan = [
    {'day': 'Monday', 'workout': 'Chest and Triceps'},
    {'day': 'Tuesday', 'workout': 'Back and Biceps'},
    {'day': 'Wednesday', 'workout': 'Rest Day'},
    {'day': 'Thursday', 'workout': 'Legs'},
    {'day': 'Friday', 'workout': 'Shoulders'},
    {'day': 'Saturday', 'workout': 'Cardio'},
    {'day': 'Sunday', 'workout': 'Rest Day'},
  ];

  /// Tracks completion status for each day.
  final Map<String, bool> _completedDays = {};

  late AnimationController _cardController;

  @override
  void initState() {
    super.initState();
    // Animation controller for card transitions.
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadCompletedDays();
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  /// Loads completed days from the provider and updates local state.
  Future<void> _loadCompletedDays() async {
    if (!mounted) return;
    final currentContext = context;
    final provider =
        Provider.of<WorkoutProgressProvider>(currentContext, listen: false);
    final workouts = provider.completedWorkouts;

    if (!mounted) return;
    setState(() {
      for (var day in weeklyPlan) {
        final dayName = day['day']!;
        _completedDays[dayName] =
            workouts.any((workout) => workout['day'] == dayName);
      }
    });
  }

  /// Toggles the completion status for a given day.
  Future<void> _toggleDayCompletion(String day, bool isCompleted) async {
    if (!mounted) return;
    final currentContext = context;
    final provider =
        Provider.of<WorkoutProgressProvider>(currentContext, listen: false);

    if (!mounted) return;
    setState(() {
      _completedDays[day] = isCompleted;
    });

    if (isCompleted) {
      // Mark the workout as completed in the provider.
      final workoutName =
          weeklyPlan.firstWhere((workout) => workout['day'] == day)['workout'];
      await provider.addCompletedWorkout(day, workoutName!);
    } else {
      // Remove the workout from progress when unchecking.
      final workouts = provider.completedWorkouts;
      final updatedWorkouts =
          workouts.where((workout) => workout['day'] != day).toList();
      await provider.clearCompletedWorkouts();
      for (var workout in updatedWorkouts) {
        await provider.addCompletedWorkout(
            workout['day'] as String, workout['exercise'] as String);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Workout Plan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: weeklyPlan.length,
          itemBuilder: (context, index) {
            final dayPlan = weeklyPlan[index];
            final dayName = dayPlan['day']!;
            final workoutName = dayPlan['workout']!;
            final isCompleted = _completedDays[dayName] ?? false;

            return AnimatedBuilder(
              animation: _cardController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -_cardController.value * 20),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1)
                        .animate(_cardController),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3 + _cardController.value * 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Colors.blue.shade300.withOpacity(0.8),
                          child: Text(
                            dayName.substring(0, 1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          dayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(workoutName),
                        trailing: Checkbox(
                          value: isCompleted,
                          onChanged: (value) {
                            if (value != null) {
                              _toggleDayCompletion(dayName, value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
