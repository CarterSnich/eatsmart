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

class MySettingsSliderItem extends StatelessWidget {
  final String label;
  final String? description;
  final double value;
  final void Function(double value) onChange;
  final Widget Function(BuildContext context, double value) sliderLabelBuilder;
  final double min;
  final double max;
  final int divisions;

  const MySettingsSliderItem({
    super.key,
    required this.label,
    this.description,
    required this.value,
    required this.onChange,
    required this.sliderLabelBuilder,
    this.min = 0,
    this.max = 1,
    this.divisions = 0,
  });

  @override
  Widget build(BuildContext context) {
    return MySectionListItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Row(
            children: [
              sliderLabelBuilder(context, value),
              Expanded(
                child: Slider(
                  onChanged: onChange,
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MySettingsSwitchItem extends StatelessWidget {
  final String label;
  final String? description;
  final bool value;
  final void Function(bool value) onChange;

  const MySettingsSwitchItem({
    super.key,
    required this.label,
    this.description,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return MySectionListItem(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodyLarge),
                if (description != null) Text(description!),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChange),
        ],
      ),
    );
  }
}
