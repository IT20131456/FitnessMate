import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_mate/models/meal_log_model.dart';
import 'package:fitness_mate/repositories/meal_logger_repository.dart';
import 'package:fitness_mate/screens/meal_logger/meal_log_adder.dart';
import 'package:fitness_mate/screens/meal_logger/meal_log_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MealLoggerMainScreen extends StatefulWidget {
  const MealLoggerMainScreen({super.key});

  @override
  State<MealLoggerMainScreen> createState() => _MealLoggerMainScreenState();
}

class _MealLoggerMainScreenState extends State<MealLoggerMainScreen> {
  late String userId = '';
  List<MealLog> mealLogs = [];
  final MealLogRepository _mealLogRepository = MealLogRepository();

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
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  'Your Meal Logger',
                  style: GoogleFonts.dancingScript(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // graph
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(
                    left: 5, right: 5, bottom: 10, top: 20),
                color: Colors.white.withOpacity(0.8),
                height: 300,
                child: Center(
                    child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Chart title
                  title: ChartTitle(text: 'Calory Intake'),
                  // Enable legend
                  legend: Legend(isVisible: true),
                  // Enable tooltip
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<MealLog, String>>[
                    LineSeries<MealLog, String>(
                        color: Colors.green,
                        dataSource: mealLogs,
                        xValueMapper: (MealLog mealLog, _) =>
                            mealLog.date.toString(),
                        yValueMapper: (MealLog mealLog, _) => mealLog.calories,
                        name: 'Calories',
                        // Enable data label
                        dataLabelSettings: DataLabelSettings(isVisible: true))
                  ],
                )),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(bottom: 10, top: 60),
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.5),
                ),
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
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.5),
                ),
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
