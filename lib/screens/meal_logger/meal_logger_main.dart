import 'package:fitness_mate/screens/meal_logger/meal_log_adder.dart';
import 'package:fitness_mate/screens/meal_logger/meal_log_list.dart';
import 'package:flutter/material.dart';

class MealLoggerMainScreen extends StatefulWidget {
  const MealLoggerMainScreen({super.key});

  @override
  State<MealLoggerMainScreen> createState() => _MealLoggerMainScreenState();
}

class _MealLoggerMainScreenState extends State<MealLoggerMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Logger'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered))
                        return Colors.blue.withOpacity(0.04);
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed))
                        return Colors.blue.withOpacity(0.12);
                      return null; // Defer to the widget's default.
                    },
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MealLogAdder()),
                  );
                },
                child: const Text('Click here to add new log')),
            TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered))
                        return Colors.blue.withOpacity(0.04);
                      if (states.contains(MaterialState.focused) ||
                          states.contains(MaterialState.pressed))
                        return Colors.blue.withOpacity(0.12);
                      return null; // Defer to the widget's default.
                    },
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MealLogs()),
                  );
                },
                child: const Text('Click here to view meal logs')),
          ],
        ),
      ),
    );
  }
}
