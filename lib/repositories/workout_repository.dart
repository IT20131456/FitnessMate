import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class WorkoutRepository {
  final CollectionReference _workouts =
      FirebaseFirestore.instance.collection('workouts');

  // Get all workouts
  Future getAllWorkouts() async {
    return _workouts;
  }

  // Add new workout
  Future addWorkout(String name, String description, String workouttype, String duration, String difficulty, String equipment, String exercises, String date  ) async {
    return await _workouts.add({
      "name": name,
      "description": description,
      "workouttype": workouttype,
      "duration": duration,
      "difficulty": difficulty,
      "equipment": equipment,
      "exercises": exercises,
      "date": date,

      "ingredients": ["sample01", "sample02"],
    });
  }

  // Update workouts
  Future<void> updateWorkout(String id, String name, String description,String workouttype, String duration, String difficulty, String equipment, String exercises, String date ) async {
    return await _workouts.doc(id).update({
      "name": name,
      "description": description,
      "workouttype": workouttype,
      "duration": duration,
      "difficulty": difficulty,
      "equipment": equipment,
      "exercises": exercises,
      "date": date,
      
      "ingredients": ["sample01", "sample02"],
    });
  }

  // Delete workouts
  Future deleteWorkout(id) async {
    await _workouts.doc(id).delete();
  }
}
