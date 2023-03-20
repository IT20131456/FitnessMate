import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class MealLogs extends StatelessWidget {
  const MealLogs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Logs'),
      ),
      body: const Text("All the meal logs will be displayed here"),
    );
  }
}
