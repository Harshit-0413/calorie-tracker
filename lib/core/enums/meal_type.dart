enum MealType {
  breakfast,
  lunch,
  snack,
  dinner;

  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return "Breakfast";
      case MealType.lunch:
        return "Lunch";
      case MealType.snack:
        return "Snack";
      case MealType.dinner:
        return "Dinner";
    }
  }
}
