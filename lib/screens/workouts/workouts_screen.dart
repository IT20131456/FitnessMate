import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_mate/repositories/workout_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fitness_mate/screens/workouts/counttime.dart';

import 'dart:math';

import 'dart:math';

import 'package:intl/intl.dart';

class Workouts extends StatefulWidget {
  // final User? user;
  const Workouts({super.key});
  @override
  State<Workouts> createState() => _WorkoutsState();
}

class _WorkoutsState extends State<Workouts> {
  final TextEditingController _workoutNameController = TextEditingController();
  final TextEditingController _workoutDescriptionController =
      TextEditingController();
  final TextEditingController _workoutTypeController = TextEditingController();
  final TextEditingController _workoutDurationController =
      TextEditingController();
  final TextEditingController _workoutDifficultyController =
      TextEditingController();
  final TextEditingController _workoutEquipmentController =
      TextEditingController();
  final TextEditingController _workoutExercisesController =
      TextEditingController();
  final TextEditingController _workoutDateController = TextEditingController();

  final CollectionReference _workout =
      FirebaseFirestore.instance.collection('workouts');

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    String? _selectedType;

    List<String> _typeList = [
      'Cardiovascular exercise (cardio)',
      'Strength training',
      'High-intensity interval training (HIIT)',
      'Yoga',
      'Pilates',
      'CrossFit',
      'Flexibility and mobility training',
      'Sports-specific training',
      'Outdoor activities'
    ];

    String? _selectedLevel;

    List<String> _levelList = ['Easy', 'Medium', 'Hard'];

    final _workoutNameController = TextEditingController();
    final _workoutDescriptionController = TextEditingController();
    final _workoutDurationController = TextEditingController(text: "0");
    final _workoutDifficultyController = TextEditingController();
    final _workoutEquipmentController = TextEditingController();
    final _workoutExercisesController = TextEditingController();
    final _workoutDateController = TextEditingController();

    @override
    void initState() {
      super.initState();
      _workoutDurationController.text = '0'; // set initial value to 0
    }

    @override
    void dispose() {
      _workoutDurationController.dispose();
      super.dispose();
    }

    List<String> _workoutEquipmentList = [];

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Add Workout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _workoutNameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextField(
                        controller: _workoutDescriptionController,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                      ),
                      TextField(
                        controller: _workoutDurationController,
                        decoration: InputDecoration(
                          labelText: 'Duration',
                          suffixIcon: GestureDetector(
                            child: Icon(Icons.arrow_drop_up),
                            onTap: () {
                              // get the current value from the controller
                              int currentValue =
                                  int.parse(_workoutDurationController.text);
                              // increment the value by 1
                              currentValue++;
                              // clamp the value between 0 and 999
                              currentValue = currentValue.clamp(0, 999);
                              // update the controller with the new value
                              _workoutDurationController.text =
                                  currentValue.toString();
                              // move the cursor to the end of the text field
                              _workoutDurationController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset:
                                        _workoutDurationController.text.length),
                              );
                            },
                          ),
                          suffixText: 'min',
                          suffixStyle: TextStyle(color: Colors.grey),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          // make sure the value is a number and is not empty
                          if (int.tryParse(value) != null && value.isNotEmpty) {
                            int newValue = int.parse(value);
                            // clamp the value between 0 and 999
                            newValue = newValue.clamp(0, 999);
                            // update the controller with the new value
                            _workoutDurationController.text =
                                newValue.toString();
                            // move the cursor to the end of the text field
                            _workoutDurationController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset:
                                      _workoutDurationController.text.length),
                            );
                          }
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedType = newValue;
                          });
                        },
                        items: _typeList.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Type',
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedLevel,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedLevel = newValue;
                          });
                        },
                        items: _levelList.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Select Difficulty Level',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        child: const Text('Create'),
                        onPressed: () async {
                          final String name = _workoutNameController.text;
                          final String description =
                              _workoutDescriptionController.text;
                          final String? workouttype = _selectedType;
                          final String duration =
                              _workoutDurationController.text;

                          final String? difficulty = _selectedLevel;
                          final String equipment =
                              _workoutEquipmentController.text;
                          final String exercises =
                              _workoutExercisesController.text;
                          final String date = _workoutDateController.text;

                          if (name.isEmpty ||
                              description.isEmpty ||
                              workouttype == null ||
                              duration.isEmpty ||
                              difficulty == null) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Alert',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                content: Text(
                                  'Please fill all the fields',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'OK',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Colors.white,
                                elevation: 5.0,
                                insetPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                              ),
                            );
                          } else {
                            // Store data here

                            await WorkoutRepository().addWorkout(
                                name,
                                description,
                                workouttype,
                                duration,
                                difficulty,
                                equipment,
                                exercises,
                                date);

                            _workoutNameController.text = '';
                            _workoutDescriptionController.text = '';
                            _workoutTypeController.text = '';
                            _workoutDurationController.text = '';
                            _workoutDifficultyController.text = '';
                            _workoutEquipmentController.text = '';
                            _workoutExercisesController.text = '';
                            _workoutDateController.text = '';

                            Navigator.of(context).pop();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  // Update a workout function
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _workoutNameController.text = documentSnapshot['name'];
      _workoutDescriptionController.text = documentSnapshot['description'];
      _workoutTypeController.text = documentSnapshot['workouttype'];
      _workoutDurationController.text = documentSnapshot['duration'];
      _workoutDifficultyController.text = documentSnapshot['difficulty'];
      _workoutEquipmentController.text = documentSnapshot['equipment'];
      _workoutExercisesController.text = documentSnapshot['exercises'];
      _workoutDateController.text = documentSnapshot['date'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _workoutNameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _workoutDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _workoutTypeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextField(
                  controller: _workoutDurationController,
                  decoration: const InputDecoration(labelText: 'Duratiom'),
                ),
                TextField(
                  controller: _workoutDifficultyController,
                  decoration: const InputDecoration(labelText: 'Difficulty'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = _workoutNameController.text;
                    final String description =
                        _workoutDescriptionController.text;
                    final String workouttype = _workoutTypeController.text;
                    final String duration = _workoutDurationController.text;
                    final String difficulty = _workoutDifficultyController.text;
                    final String equipment = _workoutEquipmentController.text;
                    final String exercises = _workoutExercisesController.text;
                    final String date = _workoutDateController.text;

                    final String id = documentSnapshot!.id;

                    await WorkoutRepository().updateWorkout(
                        id,
                        name,
                        description,
                        workouttype,
                        duration,
                        difficulty,
                        equipment,
                        exercises,
                        date);
                    _workoutNameController.text = '';
                    _workoutDescriptionController.text = '';
                    _workoutTypeController.text = '';
                    _workoutDurationController.text = '';
                    _workoutDifficultyController.text = '';
                    _workoutEquipmentController.text = '';
                    _workoutExercisesController.text = '';
                    _workoutDateController.text = '';

                    // Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Workouts()));
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _showWorkout(DocumentSnapshot documentSnapshot) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Stack(children: [
            Image.asset(
              'assets/images/fitness1.jpg', // path to your image asset
              fit: BoxFit.cover,
              width: MediaQuery.of(ctx).size.width,
              height: MediaQuery.of(ctx).size.height,
              color: Colors.black
                  .withOpacity(0.5), // adjust the opacity of the image
              colorBlendMode: BlendMode.darken,
              filterQuality: FilterQuality.high,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 20, // increased blur radius
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  // top: MediaQuery.of(ctx).viewInsets.top + 20,
                  top: 200,
                  left: 20,
                  right: 20,
                  // bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                  bottom: 20,
                ),
                child: Card(
                  color: Color.fromARGB(255, 218, 223, 218).withOpacity(0.7),
                  // shadowColor: Color.fromARGB(255, 231, 231, 231).withOpacity(0.5),
                  elevation: 5,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(15),
                  // elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 8.0),
                          child: Text(
                            documentSnapshot['name'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            documentSnapshot['description'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            Text(
                              'Type',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              documentSnapshot['workouttype'],
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Duration',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              documentSnapshot['duration'] + ' minute',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Difficulty  ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              documentSnapshot['difficulty'],
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(height: 20),
                            MaterialButton(
                              onPressed: () {
                                int duration =
                                    int.parse(documentSnapshot['duration']);
                              },
                              child: TimeCountWidget(
                                  countTimeInMinutes:
                                      int.parse(documentSnapshot['duration'])),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _delete(documentSnapshot.id);
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: 24,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: ElevatedButton(
                                    onPressed: () => _update(documentSnapshot),
                                    child: Icon(
                                      Icons.edit,
                                      size: 24,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        });
  }

  // Delete a workout
  Future<void> _delete(String recipeId) async {
    await WorkoutRepository().deleteWorkout(recipeId);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a workout!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My Workouts'),
      //   backgroundColor: Color(0xFF40D876),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/fitness1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: _workout.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.separated(
                itemCount: streamSnapshot.data!.docs.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

// Define a list of image paths

                  List<String> imagePaths = [
                    'assets/images/fit1.png',
                    'assets/images/fit2.png',
                    'assets/images/fit3.png',
                    'assets/images/fit4.png',
                    'assets/images/fit5.png',
                    'assets/images/fit6.png',
                  ];

// Get a random number between 0 and the number of images minus 1
                  int randomNumber = Random().nextInt(imagePaths.length);

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.only(top: 16),
                    child: Card(
                      color:
                          Color.fromARGB(255, 218, 223, 218).withOpacity(0.7),
                      // shadowColor: Color.fromARGB(255, 231, 231, 231).withOpacity(0.5),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(20),
                        onTap: () => _showWorkout(documentSnapshot),
                        title: Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    documentSnapshot['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  Text(
                                    documentSnapshot['description'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 20,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    documentSnapshot['duration'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'min',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Montserrat',
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20),
                            Image.asset(
                              imagePaths[randomNumber],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        child: const Icon(Icons.add),
        backgroundColor:
            Color(0xFF40D876), // add a background color to the button
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
