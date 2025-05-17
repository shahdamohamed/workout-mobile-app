import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/workout_plan_screen.dart';
import 'screens/exercises_screen.dart';
import 'providers/user_provider.dart';
import 'providers/workout_progress_provider.dart';

/// Entry point of the PopFit App.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create and initialize the user provider before running the app.
  final userProvider = UserProvider();
  await userProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        // Provide the user provider (already initialized)
        ChangeNotifierProvider.value(value: userProvider),
        // Provide the workout progress provider
        ChangeNotifierProvider(create: (context) => WorkoutProgressProvider()),
      ],
      child: const WorkoutApp(),
    ),
  );
}

/// Root widget for the PopFit App.
class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the user provider to determine the initial route
    final userProvider = Provider.of<UserProvider>(context);
    final initialRoute = userProvider.currentUser != null ? '/' : '/login';

    return MaterialApp(
      title: 'PopFit App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 2,
          centerTitle: true,
        ),
      ),
      // Set the initial route based on user login status
      initialRoute: initialRoute,
      // Define app routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/': (context) => const WorkoutBottomNavBar(),
        '/progress': (context) => const ProgressScreen(),
        '/workout-plan': (context) => const WorkoutPlanScreen(),
        '/exercises': (context) => const ExercisesScreen(),
      },
    );
  }
}
