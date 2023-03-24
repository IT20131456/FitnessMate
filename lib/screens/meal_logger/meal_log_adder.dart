import 'dart:developer';
import 'package:fitness_mate/models/meal_log_model.dart';
import 'package:fitness_mate/repositories/meal_logger_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final TextEditingController _mealTypeController = TextEditingController();

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
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: Text(
                  'Add a meal',
                  style: GoogleFonts.dancingScript(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: 200, left: 20, right: 20, bottom: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.9),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // add a dropdown to select the meal type
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          child: DropdownButton(
                              style: const TextStyle(color: Colors.black),
                              hint: _mealTypeController.text == ''
                                  ? const Text('Select Meal Type')
                                  : Text(_mealTypeController.text),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Breakfast',
                                  child: Text('Breakfast'),
                                ),
                                DropdownMenuItem(
                                  value: 'Lunch',
                                  child: Text('Lunch'),
                                ),
                                DropdownMenuItem(
                                  value: 'Dinner',
                                  child: Text('Dinner'),
                                ),
                                DropdownMenuItem(
                                  value: 'Snack',
                                  child: Text('Snack'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _mealTypeController.text = value.toString();
                                });
                              }),
                        ),
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: "Meal name *",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: const Text(
                            'Eg: 1lb brisket and fries',
                            style: TextStyle(
                                color: Color.fromARGB(255, 112, 112, 112)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 100),
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _addMealLog(MealLog(
                                userId: userId,
                                date: DateTime.now(),
                                name: _nameController.text,
                              ));
                              _nameController.clear();
                            },
                            child: const Text('Add'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
        if (jsonDecode(response.body).length == 0) {
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
          return;
        } else if (jsonDecode(response.body).length > 1) {
          // calculate total values for the meal
          double calories = 0;
          double servingSizeG = 0;
          double proteinG = 0;
          double fatTotalG = 0;
          double sodiumMg = 0;
          double potassiumMg = 0;
          double carbohydratesTotalG = 0;
          double fiberG = 0;
          double sugarG = 0;
          double cholesterolMg = 0;

          for (var i = 0; i < jsonDecode(response.body).length; i++) {
            calories += jsonDecode(response.body)[i]['calories'];
            servingSizeG += jsonDecode(response.body)[i]['serving_size_g'];
            proteinG += jsonDecode(response.body)[i]['protein_g'];
            fatTotalG += jsonDecode(response.body)[i]['fat_total_g'];
            sodiumMg += jsonDecode(response.body)[i]['sodium_mg'];
            potassiumMg += jsonDecode(response.body)[i]['potassium_mg'];
            carbohydratesTotalG +=
                jsonDecode(response.body)[i]['carbohydrates_total_g'];
            fiberG += jsonDecode(response.body)[i]['fiber_g'];
            sugarG += jsonDecode(response.body)[i]['sugar_g'];
            cholesterolMg += jsonDecode(response.body)[i]['cholesterol_mg'];
          }

          // assign the total values to the meal log
          mealLog.calories = calories;
          mealLog.servingSizeG = servingSizeG;
          mealLog.proteinG = proteinG;
          mealLog.fatTotalG = fatTotalG;
          mealLog.sodiumMg = int.parse(sodiumMg.toStringAsFixed(0));
          mealLog.potassiumMg = int.parse(potassiumMg.toStringAsFixed(0));
          mealLog.carbohydratesTotalG = carbohydratesTotalG;
          mealLog.fiberG = fiberG;
          mealLog.sugarG = sugarG;
          mealLog.cholesterolMg = int.parse(cholesterolMg.toStringAsFixed(0));
        }
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
        mealLog.cholesterolMg = jsonDecode(response.body)[0]['cholesterol_mg'];
        mealLog.mealType = _mealTypeController.text;

        // add the meal log to the database
        try {
          await _mealLogRepository.addMealLog(mealLog);
          Fluttertoast.showToast(
              msg: 'Meal Log Added',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          _nameController.clear();
          _mealTypeController.clear();
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
