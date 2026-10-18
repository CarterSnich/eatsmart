import 'package:eatsmart/components/card.dart';
import 'package:eatsmart/helpers.dart';
import 'package:eatsmart/models/fish.dart';
import 'package:eatsmart/screens/fish.dart';
import 'package:flutter/material.dart';

class MyFishCard extends StatelessWidget {
  final FishData fish;

  const MyFishCard({super.key, required this.fish});

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: InkWell(
        onTap: () => navigatePush(context, FishPage(fish: fish)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              spacing: 10,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/fish_images/${fish.binomialName}.jpg",
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fish.localNames[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      fish.binomialName,
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    Row(
                      spacing: 8,
                      children: [
                        // if (fish.nutrition.mercury != null)
                        //   MyPill(
                        //     child: Text(
                        //       "MERCURY ${fish.nutrition.mercury?.toUpperCase()}",
                        //       style: Theme.of(context).textTheme.labelMedium,
                        //     ),
                        //   ),
                        // if (fish.nutrition.protein != null)
                        //   MyPill(
                        //     child: Text(
                        //       "PROTEIN ${fish.nutrition.protein}",
                        //       style: Theme.of(context).textTheme.labelMedium,
                        //     ),
                        //   ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
