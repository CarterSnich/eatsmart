import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key, this.radius = 8.0, required this.child});

  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Padding(padding: EdgeInsets.all(radius * .5), child: child),
    );
  }
}
