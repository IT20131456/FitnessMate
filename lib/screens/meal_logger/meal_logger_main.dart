import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_mate/models/meal_log_model.dart';
import 'package:fitness_mate/repositories/meal_logger_repository.dart';
import 'package:fitness_mate/screens/meal_logger/meal_log_adder.dart';
import 'package:fitness_mate/screens/meal_logger/meal_log_list.dart';
import 'package:fitness_mate/services/meal_logger_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MealLoggerMainScreen extends StatefulWidget {
  const MealLoggerMainScreen({super.key});

  @override
  State<MealLoggerMainScreen> createState() => _MealLoggerMainScreenState();
}

class _MealLoggerMainScreenState extends State<MealLoggerMainScreen> {
  late String userId = '';
  List<MealLog> mealLogs = [];
  MealLogRepository _mealLogRepository = MealLogRepository();

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      debugPrint('User ID: ${FirebaseAuth.instance.currentUser?.uid}');
      userId = FirebaseAuth.instance.currentUser!.uid;
    }

    _mealLogRepository.getMealLogsByUserId(userId).then((value) {
      setState(() {
        mealLogs = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/meal1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // graph
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 20),
                color: Colors.white.withOpacity(0.8),
                height: 300,
                child: Center(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    title: ChartTitle(text: 'Calories'),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <ChartSeries>[
                      // Render column series
                      ColumnSeries<MealLog, String>(
                        dataSource: mealLogs,
                        xValueMapper: (MealLog mealLog, _) =>
                            mealLog.date.toString(),
                        yValueMapper: (MealLog mealLog, _) => mealLog.calories,
                        name: 'Calories',
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 150),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MealLogAdder(),
                      ),
                    );
                  },
                  child: const Text('Add Meal Log'),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MealLogs(),
                      ),
                    );
                  },
                  child: const Text('View Meal Logs'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
