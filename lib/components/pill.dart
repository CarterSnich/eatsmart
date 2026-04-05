import 'package:flutter/material.dart';

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    this.foregroundColor,
    this.backgroundColor,
  });

  final String label;
  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: TextStyle(color: foregroundColor)),
    );
  }
}
