import 'dart:developer';
import 'package:fitness_mate/models/meal_log_model.dart';
import 'package:fitness_mate/repositories/meal_logger_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class MealLogAdder extends StatefulWidget {
  const MealLogAdder({super.key});

  @override
  State<MealLogAdder> createState() => _MealLogAdderState();
}

class _MealLogAdderState extends State<MealLogAdder> {
  final _mealLogRepository = MealLogRepository();
  final TextEditingController _nameController = TextEditingController();
  String _errorMessage = '';
  late String userId = '';

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      debugPrint('User ID: ${FirebaseAuth.instance.currentUser?.uid}');
      userId = FirebaseAuth.instance.currentUser!.uid;
    }
    dotenv.load(fileName: ".env");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Meal Log'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: "Enter the meal's name",
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addMealLog(MealLog(
                      userId:
                          userId,
                      date: DateTime.now(),
                      name: _nameController.text,
                    ));
                    _nameController.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ));
  }

  // add meal log
  Future<void> _addMealLog(MealLog mealLog) async {
    log('add meal log.... ');
    log('mealLog: $mealLog');

    if (mealLog.name == '') {
      setState(() {
        _errorMessage = 'meal name is not given';
        AlertDialog(
          title: const Text('Error'),
          content: const Text('Please enter a meal name'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      });
      return;
    }

    // getting nutrition data from API
    String apiKey = dotenv.env['NINJA_API_KEY_FOR_NUTRITION']!;
    if (apiKey == '') {
      debugPrint('API key is null');
      return;
    }

      String url =
          'https://api.api-ninjas.com/v1/nutrition?query=${mealLog.name}';

      debugPrint('calling url: $url to get nutrition data');
      http.get(Uri.parse(url), headers: {
        'X-Api-Key': apiKey,
      }).then((response) async {
        if (response.statusCode == 200) {
          // if the meal name found, assign the nutrition data to the meal log
          mealLog.date = DateTime.now();
          mealLog.calories = jsonDecode(response.body)[0]['calories'];
          mealLog.servingSizeG = jsonDecode(response.body)[0]['serving_size_g'];
          mealLog.proteinG = jsonDecode(response.body)[0]['protein_g'];
          mealLog.fatTotalG = jsonDecode(response.body)[0]['fat_total_g'];
          mealLog.sodiumMg = jsonDecode(response.body)[0]['sodium_mg'];
          mealLog.carbohydratesTotalG =
              jsonDecode(response.body)[0]['carbohydrates_total_g'];
          mealLog.fiberG = jsonDecode(response.body)[0]['fiber_g'];
          mealLog.sugarG = jsonDecode(response.body)[0]['sugar_g'];

          // add the meal log to the database
          try {
            await _mealLogRepository.addMealLog(mealLog);
            AlertDialog(
              title: const Text('Success'),
              content: const Text('Meal log added successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          } catch (e) {
            debugPrint(e.toString());
          }
        } else {
          debugPrint('Error: ${response.statusCode} ${response.body}');
          AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Sorry we could not find nutrition data for this meal'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
      });
    }
  
}
