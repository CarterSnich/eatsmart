import 'package:flutter/material.dart';

class MyPill extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool border;
  final Color? borderColor;

  const MyPill({
    super.key,
    required this.child,
    this.backgroundColor,
    this.border = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(999),
          border: BoxBorder.all(width: .5, color: Colors.white),
        ),
        child: child,
      ),
    );
  }
}
