import 'package:flutter/material.dart';
import 'package:isdasmart/components/bubble_search_bar.dart';
import 'package:isdasmart/components/fish_card.dart';
import 'package:isdasmart/components/sliver_scaffold.dart';
import 'package:isdasmart/data/fish_data.dart';
import 'package:isdasmart/helpers.dart';
import 'package:isdasmart/models/fish.dart';

class FishesPage extends StatefulWidget {
  const FishesPage({super.key});

  @override
  State<FishesPage> createState() => _FishesPageState();
}

class _FishesPageState extends State<FishesPage> {
  List<FishData> _results = List.from(fishes.values);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNotifBar(context);
  }

  void _onTextChange(String query) {
    setState(() {
      _results = fishes.values.where((fish) {
        final q = query.toLowerCase();
        final hasEnglishName = fish.englishName.toLowerCase().contains(q);
        final hasBinomialName = fish.binomialName.toLowerCase().contains(q);
        final hasPopularName = fish.popularName.toLowerCase().contains(q);

        bool hasLocalName = false;
        for (var ln in fish.localNames) {
          hasLocalName = ln.toLowerCase().contains(q);
          if (hasLocalName) break;
        }

        return hasEnglishName ||
            hasBinomialName ||
            hasPopularName ||
            hasLocalName;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MySliverScaffold(
      spacing: 10,
      title: 'Fishes',
      stickyBottom: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Hero(
          tag: "fishes-button",
          child: MyBubbleSearchBar(
            child: Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search local name, English name, binomial name',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                onChanged: _onTextChange,
              ),
            ),
          ),
        ),
      ),
      stickyBottomHeight: 56,
      children: List.generate(
        _results.length,
        (i) => MyFishCard(fish: _results[i]),
      ),
    );
  }
}
