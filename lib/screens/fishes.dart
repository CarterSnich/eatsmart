import 'package:eatsmart/components/pill.dart';
import 'package:eatsmart/fishes.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FishesScreen extends StatefulWidget {
  const FishesScreen({super.key});

  @override
  State<FishesScreen> createState() => _PageState();
}

class _PageState extends State<FishesScreen> {
  final entries = fishDatabase.keys.toList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        spacing: 16,
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(MdiIcons.magnify),
              hintText: 'Search',
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final fish = entries[index];
                final fishData = fishDatabase[fish] as Fish;
                return buildListItemCard(context, fish, fishData);
              },
            ),
          ),
        ],
      ),
    );
  }
}

MaterialColor getColor(String level) {
  if (level == "HIGH") {
    return Colors.red;
  } else if (level == "MEDIUM") {
    return Colors.yellow;
  } else {
    return Colors.green;
  }
}

Widget buildListItemCard(
  BuildContext context,
  String fish,
  Fish fishData,
) => Card(
  elevation: 0,
  color: Theme.of(context).canvasColor,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: Color(0xE4E1E1FF), width: 2),
  ),
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        SizedBox(
          height: 76,
          width: 76,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              "assets/$fish.jpg",
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fishData.popularName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              fishData.englishNames[0],
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Row(
              spacing: 8,
              children: [
                Pill(
                  label:
                      "${fishData.nutrition.mercury.substring(0, 3)} MERCURY",
                  foregroundColor: getColor(fishData.nutrition.mercury),
                  backgroundColor: getColor(
                    fishData.nutrition.mercury,
                  ).shade100,
                ),
                Pill(
                  label: "${fishData.nutrition.protein} PROTEIN",
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ),
);
