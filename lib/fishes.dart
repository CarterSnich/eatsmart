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
    "nutrition": {"protein": "22g", "mercury": "LOW", "omega3": "HIGH"},
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
  "Tenpounder": Fish.fromMap({
    "popular_name": "Tenpounder",
    "binomial_name": "Elops hawaiensis",
    "english_names": [
      "Tenpounder",
      "Hawaiian Ladyfish",
      "Banana Fish",
      "Giant Herring",
    ],
    "local_names": ["Bidbid", "Bid-bid", "Awa", "Alho"],
    "description":
        "A long, slender, silvery marine fish found in Philippine coastal waters, estuaries, and brackish lagoons. Known for its large eyes, deeply forked tail, and bluish-silver sheen. Edible but notably bony, making it less popular than other food fish. Commonly caught as bycatch.",
    "nutrition": {"protein": "17g", "mercury": "LOW", "omega3": "LOW"},
    "health_checks": [
      "Good source of Protein",
      "Low in Mercury",
      "Good source of Selenium",
      "Good source of Calcium",
      "Low in Fat",
    ],
    "health_risks": [
      "Very bony — poses choking risk especially for children and elderly",
      "Low omega-3 content compared to other marine fish",
      "May trigger allergic reactions in individuals with finfish allergy",
    ],
  }),
  "Scat Fish": Fish.fromMap({
    "popular_name": "Scat Fish",
    "binomial_name": "Scatophagus argus",
    "english_names": ["Spotted Scat", "Spotted Butterfish", "Tiger Scat"],
    "local_names": ["Kitang", "Kikilo", "Akikiro", "Bayang", "Kapiged"],
    "description":
        "A deep-bodied, disc-shaped brackish and saltwater fish found in Philippine estuaries, mangroves, and coastal waters. Recognizable by its greenish-brown body covered in brown to reddish-brown spots. Highly valued as a food fish in Southeast Asia for its delicate flavor and high nutritional quality. Also kept as an ornamental fish.",
    "nutrition": {"protein": "19g", "mercury": "LOW", "omega3": "LOW"},
    "health_checks": [
      "High in Protein",
      "Low in Mercury",
      "Good source of Calcium",
      "Good source of Selenium",
      "Good source of Vitamin A",
      "Low in Fat",
    ],
    "health_risks": [
      "Dorsal, anal, and pelvic spines are venomous — puncture wounds can cause pain and swelling",
      "Low omega-3 content compared to other marine fish",
      "May trigger allergic reactions in individuals with finfish allergy",
    ],
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

/*
References:

Bangus
  Nutrition:
  - USDA FoodData Central — Raw Milkfish: https://fdc.nal.usda.gov/food-details/173675/nutrients
  - FoodStruct (from USDA): https://foodstruct.com/food/milkfish-nutrition

  Mercury:
  - Philstar / Doc Willie Ong (cites US FDA, CDC, DOH PH): https://www.philstar.com/lifestyle/health-and-family/2016/09/13/1623033/guidelines-eating-fish-safely
  - Doc Willie Ong website: https://docwillieongwebsite.com/which-fish-are-safe-to-eat/

  General Species:
  - Wikipedia — Milkfish: https://en.wikipedia.org/wiki/Milkfish
  - FishBase — Chanos chanos: https://fishbase.se/summary/Chanos-chanos.html
  - SEAFDEC — Primer on Bangus: https://mb.com.ph/2022/05/19/a-primer-on-bangus/


Tilapia
  Nutrition:
  - USDA FoodData Central — Raw Tilapia: https://fdc.nal.usda.gov/food-details/175177/nutrients
  - FoodStruct (from USDA): https://foodstruct.com/food/tilapia

  Mercury:
  - UP Manila / Science Diliman (tilapia: 0.004–0.017 mg/kg = LOW): https://journals.upd.edu.ph/index.php/sciencediliman/article/view/1530

  General Species:
  - Wikipedia — Nile Tilapia: https://en.wikipedia.org/wiki/Tilapia
  - FishBase — Oreochromis niloticus: https://fishbase.se/summary/Oreochromis-niloticus.html
  - SEAFDEC Aquaculture Extension Manual No. 66: https://www.seafdec.org.ph/wp-content/uploads/2022/07/AEM66_cover-to-intro.pdf


Bighead Carp
  Nutrition:
  - USDA FoodData Central — Raw Carp (closest available; no specific bighead carp entry): https://fdc.nal.usda.gov/food-details/174185/nutrients
  - FoodStruct (from USDA): https://foodstruct.com/food/carp
  - PMC — Muscle quality analysis of Aristichthys nobilis (peer-reviewed, species-specific): https://pmc.ncbi.nlm.nih.gov/articles/PMC10742691/

  Mercury:
    - US FDA Mercury Levels in Commercial Fish (carp listed at 0.110 ppm = LOW): https://www.fda.gov/food/environmental-contaminants-food/mercury-levels-commercial-fish-and-shellfish-1990-2012
    - ⚠️ Note: FDA data covers general carp (Cyprinus carpio), not bighead carp specifically. No Philippine-specific study found.

  General Species:
  - Wikipedia — Bighead Carp: https://en.wikipedia.org/wiki/Hypophthalmichthys_nobilis
  - FishBase — Hypophthalmichthys nobilis: https://fishbase.se/summary/Hypophthalmichthys-nobilis.html
  - SEAFDEC — Bighead Carp Grow-out Production: https://www.seafdec.org.ph/wp-content/content/pages/freedownloads/flyers/bighead_carp_grow.pdf


Scat Fish
  Nutrition:
  - FishBase — Scatophagus argus nutrient data (protein: 19.2g/100g, omega-3: 0.092g/100g): https://fishbase.se/summary/Scatophagus-argus.html
  - ⚠️ Note: No USDA FoodData Central entry exists for scat fish specifically.

  Mercury:
  - US FDA Mercury Levels in Commercial Fish (used as general reference framework): https://www.fda.gov/food/environmental-contaminants-food/mercury-levels-commercial-fish-and-shellfish-1990-2012
  - ⚠️ Note: No direct mercury measurement found for Scatophagus argus. LOW is inferred from shallow coastal/estuarine habitat and low food chain position.

  General Species:
  - Wikipedia — Spotted Scat: https://en.wikipedia.org/wiki/Scatophagus_argus
  - FishBase — Scatophagus argus: https://fishbase.se/summary/Scatophagus-argus.html
  - ResearchGate — Biology of the Spotted Scat in the Philippines (Barry & Fast, 1992): https://www.researchgate.net/publication/259863575_Biology_of_the_spotted_scat_Scatophagus_argus_in_the_Philippines
  - FishBase — Venomous spines note (Philippines): https://fishbase.mnhn.fr/Country/CountrySpeciesSummary.php?Country=Philippines&genusname=Scatophagus&speciesname=argus

*/
