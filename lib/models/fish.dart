class FishData {
  final String binomialName;
  final String popularName;
  final String englishName;
  final List<String> localNames;
  final String description;
  final Map<String, FishNutrition> nutrients;
  final List<String> healthChecks;
  final List<String> healthRisks;
  final String source;

  FishData({
    required this.binomialName,
    required this.englishName,
    required this.localNames,
    required this.description,
    required this.nutrients,
    required this.healthChecks,
    required this.healthRisks,
    required this.source,
    required this.popularName,
  });

  factory FishData.fromMap(Map<String, dynamic> map) {
    final rawObject = Map<String, dynamic>.from(map['nutrients']);

    final Map<String, FishNutrition> nutrients = rawObject.map(
      (key, value) => MapEntry(
        key,
        FishNutrition.fromMap(
          Map<String, dynamic>.from(value as Map<String, dynamic>),
        ),
      ),
    );

    return FishData(
      binomialName: map['binomial_name'],
      popularName: map['popular_name'],
      englishName: map['english_name'],
      localNames: List<String>.from(map['local_names']),
      description: map['description'],
      nutrients: nutrients,
      healthChecks: List<String>.from(map['health_checks']),
      healthRisks: List<String>.from(map['health_risks']),
      source: map['source'],
    );
  }
}

class FishNutrition {
  final double value;
  final double min;
  final double max;
  final String unit;

  FishNutrition({
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
  });

  factory FishNutrition.fromMap(Map<String, dynamic> map) {
    return FishNutrition(
      value: map['value'],
      min: map['min'],
      max: map['max'],
      unit: map['unit'],
    );
  }
}
