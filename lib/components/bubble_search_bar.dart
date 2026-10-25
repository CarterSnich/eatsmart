import 'package:eatsmart/theme/colors.dart';
import 'package:flutter/material.dart';

class MyBubbleSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const MyBubbleSearchBar({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(50),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: AppColors.of(context).border),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Icon(Icons.search), child],
          ),
        ),
      ),
    );
  }
}
