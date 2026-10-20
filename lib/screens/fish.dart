import 'package:eatsmart/components/card.dart';
import 'package:eatsmart/components/fish_hero.dart';
import 'package:eatsmart/components/pill.dart';
import 'package:eatsmart/components/section.dart';
import 'package:eatsmart/components/sliver_scaffold.dart';
import 'package:eatsmart/data/nutrients_metadata.dart';
import 'package:eatsmart/models/fish.dart';
import 'package:flutter/material.dart';

class FishPage extends StatefulWidget {
  final FishData fish;

  const FishPage({super.key, required this.fish});

  @override
  State<FishPage> createState() => _FishPageState();
}

class _FishPageState extends State<FishPage> {
  @override
  Widget build(BuildContext context) {
    final FishData fish = widget.fish;

    return MySliverScaffold(
      padding: 0,
      children: [
        MyFishHero(
          popularName: fish.popularName,
          binomialName: fish.binomialName,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              // LOCAL NAMES
              MyNakedSection(
                label: "LOCAL NAMES",
                child: Wrap(
                  spacing: 4,
                  runSpacing: 8,
                  children: List.generate(
                    fish.localNames.length,
                    (index) => MyPill(child: Text(fish.localNames[index])),
                  ),
                ),
              ),
              // DESCRIPTION
              MySection(label: "DESCRIPTION", child: Text(fish.description)),
              // NUTRIENTS
              MyNakedSection(
                label: "NUTRIENTS",
                child: Column(
                  children: fish.nutrients.entries.map((n) {
                    final key = n.key;
                    final nutritionData = n.value;
                    final meta = nutrientMeta[key];

                    final textStyle = TextStyle(
                      color: meta?['color'],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    );

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(meta?['label'], style: textStyle),
                        Text(
                          "${nutritionData.value} ${nutritionData.unit}",
                          style: textStyle,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              MyNakedSection(
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
                          Icon(Icons.check_circle_outline, color: Colors.green),
                          Expanded(child: Text(fish.healthChecks[index])),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              MyNakedSection(
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
                            Icons.error_outline,
                            color: Colors.yellow.shade900,
                          ),
                          Expanded(
                            child: Text(
                              fish.healthChecks[index],
                              style: TextStyle(color: Colors.yellow.shade900),
                            ),
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
