import 'package:flutter/material.dart';

/// Entry point for the dumbbell favicon widget demo.
void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        // Display a large blue dumbbell icon as a favicon.
        child: Icon(
          Icons.fitness_center,
          size: 100,
          color: Colors.blue,
        ),
      ),
    ),
  ));
}
