import 'package:flutter/material.dart';

class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({super.key});

  @override
  State<WorkoutPlanScreen> createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  List<Map<String, String>> weeklyPlan = [
    {'day': 'Monday', 'workout': 'Chest and Triceps'},
    {'day': 'Tuesday', 'workout': 'Back and Biceps'},
    {'day': 'Wednesday', 'workout': 'Rest Day'},
    {'day': 'Thursday', 'workout': 'Legs'},
    {'day': 'Friday', 'workout': 'Shoulders'},
    {'day': 'Saturday', 'workout': 'Cardio'},
    {'day': 'Sunday', 'workout': 'Rest Day'},
  ];

  Future<void> _editWorkoutPlan(BuildContext context, int index) async {
    TextEditingController controller = TextEditingController(
      text: weeklyPlan[index]['workout'],
    );

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Workout for ${weeklyPlan[index]['day']}'),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Workout',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    weeklyPlan[index]['workout'] =
                        controller.text.trim().isEmpty
                            ? weeklyPlan[index]['workout']!
                            : controller.text.trim();
                  });
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plan'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: weeklyPlan.length,
          itemBuilder: (context, index) {
            final dayPlan = weeklyPlan[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade300,
                  child: Text(
                    dayPlan['day']!.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  dayPlan['day']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(dayPlan['workout']!),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editWorkoutPlan(context, index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
