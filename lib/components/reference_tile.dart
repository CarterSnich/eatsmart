import 'package:eatsmart/components/section.dart';
import 'package:flutter/material.dart';

class MyReferenceTile extends StatelessWidget {
  final String icon;
  final String name;
  final String description;

  const MyReferenceTile({
    super.key,
    required this.icon,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return MySectionListItem(
      onPress: () {},
      child: Row(
        spacing: 8,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.asset(icon),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: Colors.white)),
                Text(description, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
