import 'package:flutter/material.dart';
import 'package:isdasmart/theme/colors.dart';

class MyCard extends StatelessWidget {
  final double radius;
  final Widget child;
  final double padding;
  final Color? bgColor;
  final double borderWidth;

  const MyCard({
    super.key,
    this.radius = 8.0,
    required this.child,
    this.padding = 0,
    this.bgColor,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor ?? Theme.of(context).cardColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: AppColors.of(context).border,
          width: borderWidth,
        ),
      ),
      child: Padding(padding: EdgeInsets.all(padding), child: child),
    );
  }
}
