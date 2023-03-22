class MealLog {
  late String userId;
  late String name;
  late DateTime date;
  late double calories;
  late double servingSizeG;
  late double proteinG;
  late double fatTotalG;
  late int sodiumMg;
  late int potassiumMg;
  late double fiberG;
  late int cholesterolMg;
  late double carbohydratesTotalG;
  late double sugarG;

  MealLog(
      {required this.userId,
      this.name = '',
      required this.date,
      this.calories = 0,
      this.servingSizeG = 0,
      this.proteinG = 0,
      this.fatTotalG = 0,
      this.sodiumMg = 0,
      this.potassiumMg = 0,
      this.fiberG = 0,
      this.cholesterolMg = 0,
      this.carbohydratesTotalG = 0,
      this.sugarG = 0});

  MealLog.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    date = DateTime.parse(json['date']);
    calories = json['calories'];
    servingSizeG = json['servingSizeG'];
    proteinG = json['proteinG'];
    fatTotalG = json['fatTotalG'];
    sodiumMg = json['sodiumMg'];
    potassiumMg = json['potassiumMg'];
    fiberG = json['fiberG'];
    cholesterolMg = json['cholesterolMg'];
    carbohydratesTotalG = json['carbohydratesTotalG'];
    sugarG = json['sugarG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = userId;
    data['name'] = name;
    data['date'] = date.toIso8601String();
    data['calories'] = calories;
    data['servingSizeG'] = servingSizeG;
    data['proteinG'] = proteinG;
    data['fatTotalG'] = fatTotalG;
    data['sodiumMg'] = sodiumMg;
    data['potassiumMg'] = potassiumMg;
    data['fiberG'] = fiberG;
    data['cholesterolMg'] = cholesterolMg;
    data['carbohydratesTotalG'] = carbohydratesTotalG;
    data['sugarG'] = sugarG;
    return data;
  }
}
