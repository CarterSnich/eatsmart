import 'package:flutter/material.dart';

class MyPill extends StatelessWidget {
  const MyPill({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.border = true,
    this.borderColor,
  });

  final Widget child;
  final Color backgroundColor;
  final bool border;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: BoxBorder.all(
            width: 2,
            color: border
                ? borderColor ?? Colors.grey.shade300
                : backgroundColor,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: child,
      ),
    );
  }
}
