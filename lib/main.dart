import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/exercises_screen.dart';
import 'screens/workout_plan_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/progress_screen.dart';

void main() {
  runApp(const WorkoutApp());
}

class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 2,
          centerTitle: true,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomeScreen(),
        '/exercises': (context) => const ExercisesScreen(),
        '/workout-plan': (context) => const WorkoutPlanScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/progress': (context) => const ProgressScreen(),
      },
    );
  }
}
