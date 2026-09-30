import 'package:eatsmart/components/my_card.dart';
import 'package:eatsmart/components/section.dart';
import 'package:eatsmart/components/sliver_scaffold.dart';
import 'package:eatsmart/fish_data.dart';
import 'package:eatsmart/generated_assets/assets.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FishPage extends StatefulWidget {
  final Fish fish;

  const FishPage({super.key, required this.fish});

  @override
  State<FishPage> createState() => _FishPageState();
}

class _FishPageState extends State<FishPage> {
  @override
  Widget build(BuildContext context) {
    final Fish fish = widget.fish;

    return SliverScaffold(
      padding: 0,
      children: [
        _FishHero(
          popularName: fish.englishName,
          binomialName: fish.binomialName,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              // LOCAL NAMES
              NakedSection(
                label: "LOCAL NAMES",
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: List.generate(
                    fish.localNames.length,
                    (index) =>
                        MyCard(padding: 8, child: Text(fish.localNames[index])),
                  ),
                ),
              ),
              // DESCRIPTION
              Section(label: "DESCRIPTION", child: Text(fish.description)),
              // NUTRIENTS
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    Row(
                      spacing: 20,
                      children: [
                        _NutritionCard(
                          iconData: MdiIcons.triangleWave,
                          nutrition: "PROTEIN",
                          nutritionValue: fish.nutrition.protein,
                          bgColor: Colors.blue.shade200,
                          fgColor: Colors.blue.shade500,
                        ),
                        _NutritionCard(
                          iconData: MdiIcons.lightningBoltOutline,
                          nutrition: "MERCURY",
                          nutritionValue: fish.nutrition.mercury,
                          bgColor: Colors.purple.shade100,
                          fgColor: Colors.purple.shade800,
                        ),
                        _NutritionCard(
                          iconData: MdiIcons.omega,
                          nutrition: "OMEGA",
                          nutritionValue: fish.nutrition.omega3,
                          bgColor: Colors.yellow.shade200,
                          fgColor: Colors.yellow.shade800,
                        ),
                      ],
                    ),
                    Text("*per 100 g consumption"),
                  ],
                ),
              ),
              NakedSection(
                label: "HEALTH BENEFITS",
                child: Column(
                  spacing: 10,
                  children: List.generate(
                    fish.healthChecks.length,
                    (index) => MyCard(
                      padding: 10,
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(
                            MdiIcons.checkCircleOutline,
                            color: Colors.green,
                          ),
                          Text(fish.healthChecks[index]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              NakedSection(
                label: "CONSUMPTION RISKS",
                child: Column(
                  spacing: 10,
                  children: List.generate(
                    fish.healthChecks.length,
                    (index) => MyCard(
                      borderWidth: 0,
                      bgColor: Colors.yellow.shade200,
                      padding: 10,
                      child: Row(
                        spacing: 8,
                        children: [
                          Icon(
                            MdiIcons.alertCircleOutline,
                            color: Colors.yellow.shade900,
                          ),
                          Text(
                            fish.healthChecks[index],
                            style: TextStyle(color: Colors.yellow.shade900),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FishHero extends StatelessWidget {
  final String popularName;
  final String binomialName;

  const _FishHero({required this.popularName, required this.binomialName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          Assets.fishImagesBangus,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                popularName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(binomialName, style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ],
    );
  }
}

class _NutritionCard extends StatelessWidget {
  final IconData iconData;
  final String nutrition;
  final String? nutritionValue;
  final Color bgColor;
  final Color fgColor;

  const _NutritionCard({
    required this.fgColor,
    required this.iconData,
    required this.nutrition,
    this.nutritionValue,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MyCard(
        padding: 16,
        bgColor: bgColor,
        borderWidth: 0,
        child: Column(
          children: [
            Icon(iconData, color: fgColor),
            Text(
              nutrition,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: fgColor,
              ),
            ),
            Text(
              nutritionValue ?? "N/A",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
