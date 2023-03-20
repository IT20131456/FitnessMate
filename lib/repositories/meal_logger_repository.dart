import 'package:fitness_mate/models/meal_log_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealLogRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('meal_logs');

  Future getAllMealLogs() async {
    return _collection;
  }

  Future addMealLog(MealLog mealLog) async {
    return await _collection.add({
      'id': mealLog.id,
      'name': mealLog.name,
      'description': mealLog.description,
      'date': mealLog.date,
      'calories': mealLog.calories,
      'protein': mealLog.protein,
      'carbs': mealLog.carbs,
      'fat': mealLog.fat,
    });
  }

  Future<void> updateMealLog(MealLog mealLog) async {
    return await _collection.doc(mealLog.id.toString()).update({
      'id': mealLog.id,
      'name': mealLog.name,
      'description': mealLog.description,
      'date': mealLog.date,
      'calories': mealLog.calories,
      'protein': mealLog.protein,
      'carbs': mealLog.carbs,
      'fat': mealLog.fat,
    });
  }

  Future deleteMealLog(MealLog mealLog) async {
    await _collection.doc(mealLog.id.toString()).delete();
  }
}
