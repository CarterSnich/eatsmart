import 'package:eatsmart/components/section.dart';
import 'package:flutter/material.dart';

class MyResearcherTile extends StatelessWidget {
  final String initials;
  final String name;
  final String email;
  final Color bgColor;
  final Color fgColor;

  const MyResearcherTile({
    super.key,
    required this.bgColor,
    required this.fgColor,
    required this.initials,
    required this.name,
    required this.email,
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
            decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
            child: Text(
              initials,
              style: TextStyle(
                color: fgColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: Colors.white)),
                Text(email, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
