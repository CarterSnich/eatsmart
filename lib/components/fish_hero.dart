import 'package:flutter/material.dart';

class MyFishHero extends StatelessWidget {
  final String popularName;
  final String binomialName;

  const MyFishHero({
    super.key,
    required this.popularName,
    required this.binomialName,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/fish_images/$binomialName.jpg",
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
