import 'package:flutter/material.dart';
import '../screens/exercises_screen.dart';
import '../screens/workout_plan_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/progress_screen.dart';

/// Bottom navigation bar for main app navigation.
class WorkoutBottomNavBar extends StatefulWidget {
  const WorkoutBottomNavBar({super.key});

  @override
  State<WorkoutBottomNavBar> createState() => _WorkoutBottomNavBarState();
}

class _WorkoutBottomNavBarState extends State<WorkoutBottomNavBar> {
  int _selectedIndex = 0;

  /// List of screens corresponding to each tab.
  static const List<Widget> _widgetOptions = <Widget>[
    ExercisesScreen(),
    WorkoutPlanScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  /// Handles navigation tab selection.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the selected screen.
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Bottom navigation bar with four tabs.
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Workout Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blueAccent.withOpacity(0.5),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
