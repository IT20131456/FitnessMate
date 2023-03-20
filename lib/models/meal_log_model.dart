class MealLog {
  late int id;
  late String name;
  late String description;
  late DateTime date;
  late int calories;
  late int protein;
  late int carbs;
  late int fat;

  MealLog(
      {this.id = 0,
      this.name = '',
      this.description = '',
      required this.date,
      this.calories = 0,
      this.protein = 0,
      this.carbs = 0,
      this.fat = 0});

  MealLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    date = DateTime.parse(json['date']);
    calories = json['calories'];
    protein = json['protein'];
    carbs = json['carbs'];
    fat = json['fat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['date'] = this.date.toIso8601String();
    data['calories'] = this.calories;
    data['protein'] = this.protein;
    data['carbs'] = this.carbs;
    data['fat'] = this.fat;
    return data;
  }
}
