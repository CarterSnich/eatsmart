import 'package:eatsmart/components/card.dart';
import 'package:flutter/material.dart';

class MyNutritionCard extends StatelessWidget {
  final IconData iconData;
  final String nutrition;
  final double nutritionValue;
  final Color bgColor;
  final Color fgColor;

  const MyNutritionCard({
    super.key,
    required this.fgColor,
    required this.iconData,
    required this.nutrition,
    required this.nutritionValue,
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
              nutritionValue.toString(),
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
