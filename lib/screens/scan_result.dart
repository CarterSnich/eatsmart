import "dart:typed_data";

import "package:eatsmart/fishes.dart";
import "package:flutter/material.dart";
import "package:material_design_icons_flutter/material_design_icons_flutter.dart";

Widget buildScanResult(
  BuildContext context,
  String label,
  Fish fishData,
  Uint8List? imageBytes,
) {
  return Column(
    children: [
      Stack(
        children: [
          imageBytes == null
              ? Image.asset("assets/$label.jpg")
              : Image.memory(imageBytes),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Theme.of(context).canvasColor],
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
                  fishData.popularName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  fishData.binomialName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              color: Colors.blue.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text("LOCAL NAMES"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: fishData.localNames
                    .map(
                      (item) => Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Theme.of(context).canvasColor,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(item),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            // DESCRIPTION
            Text(
              "Description",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              fishData.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            // MINERAL
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      color: Colors.blue.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(MdiIcons.triangleWave),
                            Text(
                              "PROTEIN",
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                            ),
                            Text(
                              fishData.nutrition.protein,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      color: Colors.purple.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(MdiIcons.lightningBoltOutline),
                            Text(
                              "MERCURY",
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade800,
                                  ),
                            ),
                            Text(
                              fishData.nutrition.mercury,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      color: Colors.yellow.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(MdiIcons.omega),
                            Text(
                              "OMEGA",
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow.shade800,
                                  ),
                            ),
                            Text(
                              fishData.nutrition.omega3,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // HEALTH BENEFITS
            Row(
              spacing: 8,
              children: [
                Icon(
                  MdiIcons.informationSlabCircleOutline,
                  color: Colors.green.shade300,
                ),
                Text(
                  "Health Benefits",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: fishData.healthChecks.map((data) {
                return Card(
                  color: Theme.of(context).canvasColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xE4E1E1FF)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(MdiIcons.check, color: Colors.green.shade300),
                        Text(
                          data,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Consumption Risks
            Row(
              spacing: 8,
              children: [
                Icon(
                  MdiIcons.alertCircleOutline,
                  color: Colors.yellow.shade400,
                ),
                Text(
                  "Consumption Risks",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: fishData.healthRisks.map((data) {
                return Card(
                  color: Colors.yellow.shade200,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      data,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade900,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ],
  );
}
