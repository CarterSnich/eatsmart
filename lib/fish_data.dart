class Fish {
  final String englishName;
  final String binomialName;
  final List<String> localNames;
  final String description;
  final FishNutrition nutrition;
  final List<String> healthChecks;
  final List<String> healthRisks;

  Fish({
    required this.englishName,
    required this.binomialName,
    required this.localNames,
    required this.description,
    required this.nutrition,
    required this.healthChecks,
    required this.healthRisks,
  });

  factory Fish.fromMap(Map<String, dynamic> map) {
    return Fish(
      englishName: map['english_name'] as String,
      binomialName: map['binomial_name'] as String,
      localNames: List<String>.from(map['local_names']),
      description: map['description'] as String,
      nutrition: FishNutrition(
        protein: map['nutrition']['protein'],
        mercury: map['nutrition']['mercury'],
        omega3: map['nutrition']['omega3'],
      ),
      healthChecks: List<String>.from(map['health_checks']),
      healthRisks: List<String>.from(map['health_risks']),
    );
  }
}

class FishNutrition {
  final String? protein;
  final String? mercury;
  final String? omega3;

  FishNutrition({this.protein, this.mercury, this.omega3});

  factory FishNutrition.fromMap(Map<String, String?> map) {
    return FishNutrition(
      protein: map['protein'],
      mercury: map['mercury'],
      omega3: map['omega3'],
    );
  }
}

final Map<String, Fish> fishes = {
  "bangus": Fish.fromMap({
    "english_name": "Milkfish",
    "binomial_name": "Chanos chanos",
    "local_names": ["Bangus"],
    "description":
        "A silvery, torpedo-shaped fish widely farmed across the Philippines and considered its national fish. It thrives in both freshwater and saltwater environments, making it ideal for aquaculture. Known for its mild flavor and tender flesh, though notably bony.",
    "nutrition": {"protein": "20.5g", "mercury": "Low", "omega3": "High"},
    "health_checks": [
      "High in Protein",
      "Zero Carbohydrates",
      "Good source of Vitamin B12",
      "Good source of Niacin (B3)",
      "Good source of Phosphorus",
      "Good source of Omega-3",
    ],
    "health_risks": ["Moderate mercury level", "High source of fat"],
  }),
  "budlis": Fish.fromMap({
    "english_name": "Skipjack Tuna",
    "binomial_name": "Katsuwonus pelamis",
    "local_names": ["Budlis", "Tulingan"],
    "description":
        "A streamlined, fusiform tuna with a dark purplish-blue back, silvery sides and belly, and 4–6 prominent dark longitudinal stripes along its lower sides. It is a highly migratory, schooling pelagic fish found in tropical and warm-temperate oceans, including Philippine waters.",
    "nutrition": {
      "protein": "22.3 g",
      "mercury": "Moderate",
      "omega3": "0.35 g",
    },
    "health_checks": [
      "Low in Cholesterol",
      "No Trans Fats",
      "Low in Saturated Fats",
      "Low in Sodium",
      "Low in Sugars",
    ],
    "health_risks": ["Risk of Histamine Poisoning", "Mercury Exposure"],
  }),
  "bolinao": Fish.fromMap({
    "english_name": "Priapium fish",
    "binomial_name": "Neostethus thessa",
    "local_names": ["Bolinao"],
    "description":
        "A tiny, elongated freshwater priapium fish endemic to Lake Mainit in Surigao, Mindanao, Philippines. It reaches only about 2.6 cm in males and 2.9 cm in females; males have modified pelvic fins forming a specialized thoracic clasping organ used during internal fertilization.",
    "nutrition": {"protein": "20 g", "mercury": null, "omega3": null},
    "health_checks": [],
    "health_risks": [],
  }),
  "tambakol": Fish.fromMap({
    "english_name": "Yellowfin Tuna",
    "binomial_name": "Thunnus albacares",
    "local_names": [
      "Albakora",
      "Badla-an",
      "Balarito",
      "Baliling",
      "Bangkulis",
      "Bankulis",
      "Bantala-an",
      "Barelis",
      "Bariles",
      "Barilis",
      "Bronsehan",
      "Bugo",
      "Buyo",
      "Carao",
      "Karaw",
      "Kikyawon",
      "Malaguno",
      "Malalag",
      "Oriles",
      "Painit",
      "Pak-an",
      "Pala-pala",
      "Panit",
      "Panitto",
      "Paranganon",
      "Pirit",
      "Tambakol",
      "Tambakul",
      "Tiklaw",
      "Tulingan",
      "Vahuyo",
    ],
    "description":
        "A large, elongated, streamlined tuna with a metallic dark-blue back transitioning to yellow and then silver on the belly. The dorsal and anal fins and their finlets are bright yellow, with the finlets having narrow black borders.",
    "nutrition": {
      "protein": "23.38 g",
      "mercury": "Moderate",
      "omega3": "100 mg",
    },
    "health_checks": [
      "High in Protein",
      "Low in Calories",
      "Good Source of Omega-3",
      "Rich in Selenium",
      "Rich in Vitamin B12",
      "Good Source of Vitamin D",
      "Low in Saturated Fat",
    ],
    "health_risks": [
      "Contains Moderate Mercury",
      "Risk of Histamine",
      "Risk Scombroid Poisoning",
    ],
  }),
  "tamban": Fish.fromMap({
    "english_name": "Bali Sardine",
    "binomial_name": "Sardinella lemuru",
    "local_names": ["Tamban"],
    "description":
        "Sardinella lemuru (Bali sardine) is a small, elongated, silvery pelagic fish with a faint golden spot behind the gill opening and a distinct dark spot on the rear edge of the gill cover. It forms large schools in coastal waters and occurs in Philippine waters. In the Philippines, it is commonly known as tamban.",
    "nutrition": {
      "protein": "20.3 g",
      "mercury": "Very low",
      "omega3": "286 mg",
    },
    "health_checks": [
      "High in Protein",
      "Rich in Omega-3",
      "Rich in Selenium",
      "Good Source of Calcium",
      "Good Source of Iron",
      "Good Source of Zinc",
      "Low in Mercury",
    ],
    "health_risks": ["High in Purines", "Risk of Histamine Poisoning"],
  }),
  "tilapia": Fish.fromMap({
    "english_name": "Tilapia",
    "binomial_name": "Oreochromis niloticus",
    "local_names": ["Tilapia", "Tilapya"],
    "description":
        "A freshwater fish native to Africa and widely farmed across the Philippines. It has white, mild-flavored, lean flesh with a firm texture. One of the most commercially important aquaculture species in the country.",
    "nutrition": {"protein": "20g", "mercury": "Low", "omega3": "0.27 g"},
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
  "sagision": Fish.fromMap({
    "english_name": "Celebes threadfin bream",
    "binomial_name": "Nemipterus celebicus",
    "local_names": [
      "Tingin",
      "Sagision",
      "Sagisi",
      "Lagaw",
      "Lagao",
      "Hotik",
      "Bisugo",
    ],
    "description":
        "Nemipterus celebicus (Celebes threadfin bream) is a small marine demersal fish with a pinkish upper body and silvery-white underside, marked by two silvery-mauve lines around the eye. It has long pectoral and pelvic fins and a slightly rounded, rosy upper caudal-fin lobe, and typically lives over sandy or muddy bottoms at depths of 30–100 m, feeding mainly on small crustaceans.",
    "nutrition": {"protein": null, "mercury": null, "omega3": null},
    "health_checks": [],
    "health_risks": [],
  }),
  "burao-burao": Fish.fromMap({
    "english_name": "Island Mackerel",
    "binomial_name": "Rastrelliger Faughni",
    "local_names": [
      "Alumahan",
      "Alumahan bato",
      "Andohaw",
      "Anduhan",
      "Anduhaw",
      "Bantala-an",
      "Bulao-bulao",
      "Burao",
      "Buraw",
      "Burirawan",
      "Gutob",
      "Hasa-hasa",
      "Kabalyas",
      "Kapisnon",
      "Karabalyas",
      "Lumahan",
      "Panit",
      "Tamarang",
    ],
    "description":
        "Rastrelliger faughni is a slender mackerel with a yellowish-silver belly, a black blotch behind the pectoral-fin base, 2–6 large spots at the base of the first dorsal fin, and sometimes two faint stripes along the lateral line.",
    "nutrition": {"protein": "20 g", "mercury": "High", "omega3": "1.56 g"},
    "health_checks": [
      "High in Protein",
      "Good Source of Omega-3",
      "Rich in Selenium",
      "Rich in Vitamin B12",
      "Good Source of Vitamin D",
      "Low in Saturated Fat",
      "No Trans Fats",
      "Low in Sodium",
    ],
    "health_risks": ["Mercury Exposure"],
  }),
  "talho": Fish.fromMap({
    "english_name": "Brushtooth lizardfish",
    "binomial_name": "Saurida Undosquamis",
    "local_names": [
      "Al-alibot",
      "Balanghutan",
      "Basasong",
      "Bubule",
      "Daldalag",
      "Kalaso",
      "Kamutihan",
      "Karaho",
      "Kuti-kuti",
      "Lamoryo",
      "Lusod",
      "Talad",
      "Talho",
      "Tamangkah",
      "Tambod",
      "Teki-teki",
      "Tigbasbay",
      "Tiki",
      "Tiki-tiki",
    ],
    "description":
        "Saurida undosquamis is an elongated, cigar-shaped marine lizardfish with a pointed, flattened head, rounded snout, brown-gray upper body, creamy underside, and 8–10 indistinct darker spots along its sides. It occurs in southern Philippine waters and is found over sandy or muddy coastal bottoms.",
    "nutrition": {"protein": "19 g", "mercury": null, "omega3": "0.105 g"},
    "health_checks": [
      "Good Source of Protein",
      "Good Source of Omega-3",
      "Good Source of Selenium",
      "Good Source of Vitamin A",
    ],
    "health_risks": [],
  }),
  "danggit": Fish.fromMap({
    "english_name": "White-spotted spinefoot",
    "binomial_name": "Siganus canaliculatus",
    "local_names": [
      "Balanglen kuyog",
      "Balawis",
      "Balawis bato",
      "Barangan",
      "Barangen",
      "Bararawan",
      "Bataway",
      "Bawis",
      "Borot",
      "Danggit",
      "Danggit balawis",
      "Dangit",
      "Dangit sa bato",
      "Dawis",
      "Kataway",
      "Manlalara",
      "Mublad",
      "Ngisi-ngisi",
      "Samaral",
      "Tamaral",
      "Turus",
    ],
    "description":
        "Siganus canaliculatus is a reef-associated rabbitfish found in marine and brackish waters, commonly around algae-covered reefs, seagrass beds, lagoons, and estuaries. It feeds mainly on benthic algae and seagrass.",
    "nutrition": {"protein": "19.6 g", "mercury": null, "omega3": "0.15 g"},
    "health_checks": [
      "High in Protein",
      "Good Source of Omega-3",
      "Rich in Selenium",
      "Good Source of Zinc",
      "Good Source of Iron",
      "Good Source of Calcium",
    ],
    "health_risks": ["Venomous spines"],
  }),
};

/*
References:

Bangus
  General information:
  - Wikipedia — Milkfish: https://en.wikipedia.org/wiki/Milkfish
  - FishBase — Chanos chanos: https://fishbase.se/summary/Chanos-chanos.html
  - SEAFDEC — Primer on Bangus: https://mb.com.ph/2022/05/19/a-primer-on-bangus/

  Nutrition:
  - USDA FoodData Central — Raw Milkfish: https://fdc.nal.usda.gov/food-details/173675/nutrients
  - FoodStruct (from USDA): https://foodstruct.com/food/milkfish-nutrition
  - Philstar / Doc Willie Ong (cites US FDA, CDC, DOH PH): https://www.philstar.com/lifestyle/health-and-family/2016/09/13/1623033/guidelines-eating-fish-safely
  - Doc Willie Ong website: https://docwillieongwebsite.com/which-fish-are-safe-to-eat/


Tilapia
  General information:
  - Wikipedia — Nile Tilapia: https://en.wikipedia.org/wiki/Tilapia
  - FishBase — Oreochromis niloticus: https://fishbase.se/summary/Oreochromis-niloticus.html
  - SEAFDEC Aquaculture Extension Manual No. 66: https://www.seafdec.org.ph/wp-content/uploads/2022/07/AEM66_cover-to-intro.pdf
  
  Nutrition:
  - USDA FoodData Central — Raw Tilapia: https://fdc.nal.usda.gov/food-details/175177/nutrients
  - FoodStruct (from USDA): https://foodstruct.com/food/tilapia
  - UP Manila / Science Diliman (tilapia: 0.004–0.017 mg/kg = Low): https://journals.upd.edu.ph/index.php/sciencedilimarticle/view/1530


Tambakol
  General information:
  - FishBase: https://fishbase.ca/summary/SpeciesSummary.php?ID=143&AT=tambakol
  
  Nutrition:
  - https://www.fisheries.noaa.gov/species/pacific-yellowfin-tuna/seafood
  - https://fooddata.the50.store/ingredients/15127-fish-tuna-fresh-yellowfin-raw
  - https://www.fda.gov/food/consumers/questions-answers-fdaepa-advice-about-eating-fish-those-who-might-become-or-are-pregnant-or
  - https://www.fda.gov/food/environmental-contaminants-food/mercury-levels-commercial-fish-and-shellfish-1990-2012
  - https://www.fda.gov/food/environmental-contaminants-food/technical-information-development-fdaepa-advice-about-eating-fish-those-who-might-become-or-are?

  Risks:
  - https://www.fda.gov/food/seafood-guidance-documents-regulatory-information/scombrotoxin-poisoning-and-decomposition?
  - https://www.fda.gov/food/environmental-contaminants-food/mercury-levels-commercial-fish-and-shellfish-1990-2012


Tamban
  General information:
  - https://fishbase.se/Fieldguide/FieldGuideSummary.php?c_code=360&genusname=Sardinella&speciesname=lemuru&

  Nutrition:
  - https://www.fishbase.org/summary/SpeciesSummary.php?id=1510&lang=English&
  - https://www.fishbase.se/country/CountrySpeciesSummary.php?c_code=036&genusname=Sardinella&speciesname=lemuru&
  - https://philjournalsci.dost.gov.ph/images/pdf/pjs_pdf/vol151no1/risk_profiling_of_methymercury_in_teh_consumption_of_dried_tamban_.pdf?
  - https://philjournalsci.dost.gov.ph/risk-profiling-of-methylmercury-in-the-consumption-of-dried-tamban-sardinella-lemuru-by-the-filipino-consuming-population/?
  
  Risks:
  - https://ojs.unud.ac.id/index.php/CTAS/article/download/73013/47922?


Budlis
  General information:
  - https://www.fishbase.se/Fieldguide/FieldGuideSummary.php?c_code=036&genusname=Katsuwonus&speciesname=pelamis&

  Nutrition:
  - https://www.fishbase.se/Country/CountrySpeciesSummary.php?c_code=608&id=107&
  - https://www.fda.gov/food/environmental-contaminants-food/mercury-levels-commercial-fish-and-shellfish-1990-2012?
  - https://en.wikipedia.org/wiki/Skipjack_tuna
  - https://foodstruct.com/food/skipjack-tuna

  Risks:
  - https://foodstruct.com/food/skipjack-tuna
  - https://www.cdc.gov/yellow-book/hcp/environmental-hazards-risks/food-poisoning-from-marine-toxins.html?
  - https://www.sciencedirect.com/science/article/abs/pii/S0889157516302101?


Bolinao
  General information:
  - https://www.fishbase.se/country/CountrySpeciesSummary.php?c_code=608&id=26943&


Sagision
  General information:
  - https://www.fishbase.se/FieldGuide/FieldGuideSummary.php?c_code=608&genusname=Nemipterus&print=1&speciesname=celebicus&


Burao-burao
  General information:
  - https://www.fishbase.se/FieldGuide/FieldGuideSummary.php?GenusName=Rastrelliger&SpeciesName=faughni&c_code=608&print=&

  Nutrition:
  - https://foodstruct.com/food/fish-mackerel-pacificandjack-mixedspecies-raw
  - https://pmc.ncbi.nlm.nih.gov/articles/PMC4334092/?


Talho
  General information:
  - https://www.fishbase.se/summary/Saurida-undosquamis.html
  - https://fishbase.org/ComNames/1055

  Nutrition:
  - https://fishbase.org/summary/Saurida_undosquamis.html


Danggit

  General information:
  - https://fishbase.se/Country/CountrySpeciesSummary.php?Country=Philippines&genusname=Siganus&speciesname=canaliculatus&

*/
