import 'package:fitness_mate/models/meal_log_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealLogRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('meal_logs');
  // get all meal logs
  Future<List<MealLog>> getAllMealLogs() async {
    return await _collection.get().then((querySnapshot) {
      List<MealLog> mealLogs = [];
      querySnapshot.docs.forEach((doc) {
        mealLogs.add(MealLog(
          id: doc.id,
          userId: doc['userId'],
          name: doc['name'],
          date: doc['date'].toDate(),
          calories: doc['calories'],
          proteinG: doc['proteinG'],
          servingSizeG: doc['servingSizeG'],
          fatTotalG: doc['fatTotalG'],
          sodiumMg: doc['sodiumMg'],
          potassiumMg: doc['potassiumMg'],
          fiberG: doc['fiberG'],
          cholesterolMg: doc['cholesterolMg'],
          carbohydratesTotalG: doc['carbohydratesTotalG'],
          sugarG: doc['sugarG'],
          mealType: doc['mealType'],
        ));
      });
      return mealLogs;
    });
  }

  // get meal logs by user id
  Future<List<MealLog>> getMealLogsByUserId(String userId) async {
    return await _collection
        .where('userId', isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      List<MealLog> mealLogs = [];
      querySnapshot.docs.forEach((doc) {
        mealLogs.add(MealLog(
          id: doc.id,
          userId: doc['userId'],
          name: doc['name'],
          date: doc['date'].toDate(),
          calories: doc['calories'],
          proteinG: doc['proteinG'],
          servingSizeG: doc['servingSizeG'],
          fatTotalG: doc['fatTotalG'],
          sodiumMg: doc['sodiumMg'],
          potassiumMg: doc['potassiumMg'],
          fiberG: doc['fiberG'],
          cholesterolMg: doc['cholesterolMg'],
          carbohydratesTotalG: doc['carbohydratesTotalG'],
          sugarG: doc['sugarG'],
          mealType: doc['mealType'],
        ));
      });
      return mealLogs;
    });
  }

  Future addMealLog(MealLog mealLog) async {
    return await _collection.add({
      'userId': mealLog.userId,
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
      'mealType': mealLog.mealType,
    });
  }

  Future<void> updateMealLog(MealLog mealLog, String id) async {
    await _collection.doc(id).update({
      'userId': mealLog.userId,
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
      'mealType': mealLog.mealType,
    });
  }

  Future deleteMealLog(String id) async {
    await _collection.doc(id).delete();
  }
}
