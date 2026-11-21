import 'package:flutter/material.dart';
import 'package:isdasmart/components/section.dart';

class MySettingsItem extends StatelessWidget {
  final String label;
  final String? description;
  final VoidCallback onPress;

  const MySettingsItem({
    super.key,
    required this.label,
    required this.onPress,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return MySectionListItem(
      onPress: onPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          if (description != null) Text(description!),
        ],
      ),
    );
  }
}
