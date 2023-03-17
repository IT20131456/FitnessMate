import 'package:flutter/material.dart';

class MealLoggerMainScreen extends StatefulWidget {
  const MealLoggerMainScreen({super.key});

  @override
  State<MealLoggerMainScreen> createState() => _MealLoggerMainScreenState();
}

class _MealLoggerMainScreenState extends State<MealLoggerMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Meal Logger Main'),
      ),
    );
  }
}
