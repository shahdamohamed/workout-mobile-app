import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ممكن تضيفي رسم بياني لاحقًا
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: Colors.blue.shade600,
      ),
      body: const Center(
        child: Text(
          'Track your progress here!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
