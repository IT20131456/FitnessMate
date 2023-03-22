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
      'name': mealLog.name,
      'date': mealLog.date,
      'calories': mealLog.calories,
      'proteinG': mealLog.proteinG,
      'servingSizeG': mealLog.servingSizeG,
      'fatTotalG': mealLog.fatTotalG,
      'sodiumMg': mealLog.sodiumMg,
      'potassiumMg': mealLog.potassiumMg,
      'fiberG': mealLog.fiberG,
      'cholesterolMg': mealLog.cholesterolMg,
      'carbohydratesTotalG': mealLog.carbohydratesTotalG,
      'sugarG': mealLog.sugarG,
    });
  }

  Future<void> updateMealLog(MealLog mealLog, String id) async {
    return await _collection.doc(id).update({
      'name': mealLog.name,
      'date': mealLog.date,
      'calories': mealLog.calories,
      'servingSizeG': mealLog.servingSizeG,
      'proteinG': mealLog.proteinG,
      'fatTotalG': mealLog.fatTotalG,
      'sodiumMg': mealLog.sodiumMg,
      'potassiumMg': mealLog.potassiumMg,
      'fiberG': mealLog.fiberG,
      'cholesterolMg': mealLog.cholesterolMg,
      'carbohydratesTotalG': mealLog.carbohydratesTotalG,
      'sugarG': mealLog.sugarG,
    });
  }

  Future deleteMealLog(String id) async {
    await _collection.doc(id).delete();
  }
}
