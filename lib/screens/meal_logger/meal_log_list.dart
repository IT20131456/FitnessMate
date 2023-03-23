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
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/meal1.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView.builder(
            itemCount: _mealLogList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: ListTile(
                  onTap: () {
                    _viewMealLog(_mealLogList[index]);
                  },
                  title: Text('Meal: ${_mealLogList[index].name}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Text('Date: ${_mealLogList[index].date}'),
                      Text('Calories: ${_mealLogList[index].calories}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _updateMealLog(_mealLogList[index]);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          _deleteMealLog(_mealLogList[index].id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  // view meal log details in a dialog
  void _viewMealLog(MealLog mealLog) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Meal: ${mealLog.name}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${mealLog.date}'),
                Text('Serving Size: ${mealLog.servingSizeG} g'),
                Text('Calories: ${mealLog.calories}'),
                Text('Protein: ${mealLog.proteinG} g'),
                Text('Carbohydrates: ${mealLog.carbohydratesTotalG} g'),
                Text('Fat: ${mealLog.fatTotalG} g'),
                Text('Fiber: ${mealLog.fiberG} g'),
                Text('Sodium: ${mealLog.sodiumMg} mg'),
                Text('Sugar: ${mealLog.sugarG} g'),
                Text('Cholesterol: ${mealLog.cholesterolMg} mg'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
  }

  // get meal logs
  Future<void> _getMealList() async {
    debugPrint('Getting Meal Logs...');
    _mealLogList.clear();
    _mealLogList = await _mealLogService.getMealLogsByUserId(userId);

    for (var element in _mealLogList) {
      debugPrint('Document ID: ${element.id}');
    }

    setState(() {});
  }

  // update meal log
  void _updateMealLog(MealLog mealLog) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Meal Log'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: TextEditingController(text: mealLog.name),
                    decoration: const InputDecoration(
                      hintText: 'Enter meal name',
                      labelText: 'Meal Name',
                    ),
                    onChanged: (value) {
                      mealLog.name = value;
                    },
                  ),
                  TextField(
                    controller:
                        TextEditingController(text: mealLog.date.toString()),
                    decoration: const InputDecoration(
                      hintText: 'Enter date',
                      labelText: 'Date',
                    ),
                    onChanged: (value) {
                      mealLog.date = value as DateTime;
                    },
                  ),
                  TextField(
                    controller: TextEditingController(
                        text: mealLog.calories.toString()),
                    decoration: const InputDecoration(
                      hintText: 'Enter calories',
                      labelText: 'Calories',
                    ),
                    onChanged: (value) {
                      mealLog.calories = value as double;
                    },
                  ),
                  TextField(
                    controller: TextEditingController(
                        text: mealLog.proteinG.toString()),
                    decoration: const InputDecoration(
                      hintText: 'Enter protein',
                      labelText: 'Protein (g)',
                    ),
                    onChanged: (value) {
                      mealLog.proteinG = value as double;
                    },
                  ),
                  TextField(
                    controller: TextEditingController(
                        text: mealLog.carbohydratesTotalG.toString()),
                    decoration: const InputDecoration(
                      hintText: 'Enter carbohydrates',
                      labelText: 'Carbohydrates (g)',
                    ),
                    onChanged: (value) {
                      mealLog.carbohydratesTotalG = value as double;
                    },
                  ),
                  TextField(
                    controller: TextEditingController(
                        text: mealLog.fatTotalG.toString()),
                    decoration: const InputDecoration(
                      hintText: 'Enter fat',
                      labelText: 'Fat (g)',
                    ),
                    onChanged: (value) {
                      mealLog.fatTotalG = value as double;
                    },
                  ),
                  TextField(
                    controller:
                        TextEditingController(text: mealLog.fiberG.toString()),
                    decoration: const InputDecoration(
                      hintText: 'Enter fiber',
                      labelText: 'Fiber (g)',
                    ),
                    onChanged: (value) {
                      mealLog.fiberG = value as double;
                    },
                  ),
                  TextField(
                    controller: TextEditingController(
                        text: mealLog.sodiumMg.toString()),
                    decoration: const InputDecoration(
                      hintText: 'Enter sodium',
                      labelText: 'Sodium  (mg)',
                    ),
                    onChanged: (value) {
                      mealLog.sodiumMg = value as int;
                    },
                  ),
                  TextField(
                    controller:
                        TextEditingController(text: mealLog.sugarG.toString()),
                    decoration: const InputDecoration(
                      hintText: 'Enter sugar',
                      labelText: 'Sugar (g)',
                    ),
                    onChanged: (value) {
                      mealLog.sugarG = value as double;
                    },
                  ),
                  TextField(
                    controller: TextEditingController(
                        text: mealLog.cholesterolMg.toString()),
                    decoration: const InputDecoration(
                      hintText: 'Enter cholesterol',
                      labelText: 'Cholesterol (mg)',
                    ),
                    onChanged: (value) {
                      mealLog.cholesterolMg = value as int;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _mealLogService.updateMealLog(mealLog, mealLog.id);
                  Navigator.of(context).pop();
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }

  // delete meal log
  void _deleteMealLog(String docId) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Meal Log'),
            content:
                const Text('Are you sure you want to delete this meal log?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _mealLogService.deleteMealLog(docId);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }
}
