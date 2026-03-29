class Fish {
  final String popularName;
  final String binomialName;
  final List<String> englishNames;
  final List<String> localNames;
  final String description;
  final FishNutrition nutrition;
  final List<String> healthChecks;
  final List<String> healthRisks;

  Fish({
    required this.popularName,
    required this.binomialName,
    required this.englishNames,
    required this.localNames,
    required this.description,
    required this.nutrition,
    required this.healthChecks,
    required this.healthRisks,
  });

  factory Fish.fromMap(Map<String, dynamic> map) {
    return Fish(
      popularName: map['popular_name'] as String,
      binomialName: map['binomial_name'] as String,
      englishNames: List<String>.from(map['english_names']),
      localNames: List<String>.from(map['local_names']),
      description: map['description'] as String,
      nutrition: FishNutrition.fromMap(map['nutrition']),
      healthChecks: List<String>.from(map['health_checks']),
      healthRisks: List<String>.from(map['health_risks']),
    );
  }
}

class FishNutrition {
  final String protein;
  final String mercury;
  final String omega3;

  FishNutrition({
    required this.protein,
    required this.mercury,
    required this.omega3,
  });

  factory FishNutrition.fromMap(Map<String, dynamic> map) {
    return FishNutrition(
      protein: map['protein'] as String,
      mercury: map['mercury'] as String,
      omega3: map['omega3'] as String,
    );
  }
}

final Map<String, Fish> fishDatabase = {
  "Bangus": Fish.fromMap({
    "popular_name": "Bangus",
    "binomial_name": "Chanos chanos",
    "english_names": ["Milkfish"],
    "local_names": ["Bangus"],
    "description":
        "A silvery, torpedo-shaped fish widely farmed across the Philippines and considered its national fish. It thrives in both freshwater and saltwater environments, making it ideal for aquaculture. Known for its mild flavor and tender flesh, though notably bony.",
    "nutrition": {"protein": "22g", "mercury": "MEDIUM", "omega3": "HIGH"},
    "health_checks": [
      "High in Protein",
      "Zero Carbohydrates",
      "Good source of Vitamin B12",
      "Good source of Niacin (B3)",
      "Good source of Phosphorus",
      "Good source of Omega-3",
    ],
    "health_risks": [
      "Moderate mercury level — limit to 1-2 servings per week",
      "Relatively high in fat compared to leaner fish",
    ],
  }),
  "Big Head Carp": Fish.fromMap({
    "popular_name": "Big Head Carp",
    "binomial_name": "Hypophthalmichthys nobilis",
    "english_names": ["Bighead Carp"],
    "local_names": ["Karpa", "Imelda"],
    "description":
        "A large freshwater fish introduced to the Philippines from mainland Asia for aquaculture. Widely farmed in Laguna Lake alongside tilapia and milkfish. Known for rapid growth and mild-flavored white flesh, though it has a notably large head and many small bones.",
    "nutrition": {"protein": "18g", "mercury": "LOW", "omega3": "MEDIUM"},
    "health_checks": [
      "High in Protein",
      "Good source of Omega-3",
      "Low in Mercury",
      "Good source of Vitamin B12",
      "Low in Saturated Fat",
    ],
    "health_risks": [
      "Moderate omega-6 content may offset some omega-3 benefits",
      "Lower omega-3 levels compared to marine fish",
    ],
  }),
  "Tilapia": Fish.fromMap({
    "popular_name": "Tilapia",
    "binomial_name": "Oreochromis niloticus",
    "english_names": ["Nile Tilapia", "Gray Tilapia"],
    "local_names": ["Tilapia", "Tilapya"],
    "description":
        "A freshwater fish native to Africa and widely farmed across the Philippines. It has white, mild-flavored, lean flesh with a firm texture. One of the most commercially important aquaculture species in the country.",
    "nutrition": {"protein": "20g", "mercury": "LOW", "omega3": "LOW"},
    "health_checks": [
      "High in Protein",
      "Low in Calories",
      "Low in Fat",
      "Low in Mercury",
      "Good source of Vitamin D",
      "Good source of Vitamin B12",
      "Zero Carbohydrates",
      "Low in Saturated Fat",
    ],
    "health_risks": [
      "High omega-6 to omega-3 ratio may promote inflammation",
      "Low omega-3 content compared to other fish",
      "Low in heart-healthy fatty acids",
    ],
  }),
  "Gold Fish": Fish.fromMap({
    "popular_name": "Gold Fish",
    "binomial_name": "Carassius auratus",
    "english_names": ["Gold fish"],
    "local_names": [],
    "description": "",
    "nutrition": {"protein": "0g", "mercury": "UNKNOWN", "omega3": "UNKNOWN"},
    "health_checks": [],
    "health_risks": [],
  }),
  "Black Spotted Barb": Fish.fromMap({
    "popular_name": "Black Spotted Barb",
    "binomial_name": "Puntius nigrofasciatus",
    "english_names": ["Black Spotted Barb"],
    "local_names": [],
    "description": "",
    "nutrition": {"protein": "0g", "mercury": "UNKNOWN", "omega3": "UNKNOWN"},
    "health_checks": [],
    "health_risks": [],
  }),
};

const List<String> fishBuyingTips = [
  "Check that the eyes are clear and bulging, not sunken or cloudy.",
  "Smell the fish — it should smell like the sea, not sour or ammonia-like.",
  "Press the flesh — it should spring back, not leave a dent.",
  "Look for bright red or pink gills, not brown or gray.",
  "The skin should be shiny and moist, not dry or dull.",
  "Scales should be intact and firmly attached.",
  "Buy from clean, well-iced displays — avoid fish sitting in warm water.",
  "Whole fish should feel stiff and firm, not limp or floppy.",
  "Avoid fish with discolored or bruised flesh.",
  "Buy local and in-season fish for the freshest and most affordable options.",
];
