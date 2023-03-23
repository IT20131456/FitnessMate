import 'package:fitness_mate/models/meal_log_model.dart';
import 'package:fitness_mate/repositories/meal_logger_repository.dart';

class MealLoggerService {
  final MealLogRepository _mealLoggerRepository;

  MealLoggerService(this._mealLoggerRepository);

  Future<List<MealLog>> getMealLogs() async {
    return await _mealLoggerRepository.getAllMealLogs();
  }

  Future<List<MealLog>> getMealLogsByUserId(String userId) async {
    return await _mealLoggerRepository.getMealLogsByUserId(userId);
  }

  Future<void> addMealLog(MealLog mealLog) async {
    await _mealLoggerRepository.addMealLog(mealLog);
  }

  Future<void> updateMealLog(MealLog mealLog, String id) async {
    await _mealLoggerRepository.updateMealLog(mealLog, id);
  }

  Future<void> deleteMealLog(String mealLogId) async {
    await _mealLoggerRepository.deleteMealLog(mealLogId);
  }
}
