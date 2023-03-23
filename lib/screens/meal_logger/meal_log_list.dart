import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_mate/models/meal_log_model.dart';
import 'package:fitness_mate/repositories/meal_logger_repository.dart';
import 'package:fitness_mate/services/meal_logger_service.dart';
import 'package:flutter/material.dart';

class MealLogs extends StatefulWidget {
  const MealLogs({Key? key}) : super(key: key);

  @override
  State<MealLogs> createState() => _MealLogsState();
}

class _MealLogsState extends State<MealLogs> {
  late List<MealLog> _mealLogList = [];
  final _mealLogService = MealLoggerService(MealLogRepository());
  late String userId = '';

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      debugPrint('User ID: ${FirebaseAuth.instance.currentUser?.uid}');
      userId = FirebaseAuth.instance.currentUser!.uid;
    }
    // get the existing list of meal logs
    _getMealList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Logs'),
      ),
      body: ListView.builder(
        itemCount: _mealLogList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Meal: ${_mealLogList[index].name}'),
            subtitle: Text('Date: ${_mealLogList[index].date}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _deleteMealLog(_mealLogList[index].id);
              },
            ),
          );
        },
      ),
    );
  }

  // get meal logs
  void _getMealList() async {
    debugPrint('Getting Meal Logs...');
    _mealLogList.clear();
    _mealLogList = await _mealLogService.getMealLogsByUserId(userId);

    for (var element in _mealLogList) {
      debugPrint('Document ID: ${element.id}');
    }
  }

  // update meal log
  void _updateMealLog(MealLog mealLog) async {
    await _mealLogService.updateMealLog(mealLog, mealLog.id);
    _getMealList();
  }

  // delete meal log
  void _deleteMealLog(String docId) async {
    await _mealLogService.deleteMealLog(docId);
    _getMealList();
  }
}
