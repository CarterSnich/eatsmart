import 'package:eatsmart/components/bubble_search_bar.dart';
import 'package:eatsmart/components/fish_card.dart';
import 'package:eatsmart/components/sliver_scaffold.dart';
import 'package:eatsmart/data/fish_data.dart';
import 'package:eatsmart/models/fish.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FishesPage extends StatefulWidget {
  const FishesPage({super.key});

  @override
  State<FishesPage> createState() => _FishesPageState();
}

class _FishesPageState extends State<FishesPage> {
  List<FishData> _results = List.from(fishes.values);

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return MySliverScaffold(
      customAppBar: SliverAppBar(
        title: Hero(
          tag: 'fishes',
          child: MyBubbleSearchBar(
            child: Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search fish',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                onChanged: (query) {
                  setState(() {
                    _results = fishes.values.where((fish) {
                      final q = query.toLowerCase();
                      final hasEnglishName = fish.englishName
                          .toLowerCase()
                          .contains(q);
                      final hasBinomialName = fish.binomialName
                          .toLowerCase()
                          .contains(q);
                      final hasPopularName = fish.popularName
                          .toLowerCase()
                          .contains(q);

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
                },
              ),
            ),
          ),
        ),
        floating: true,
        snap: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF08111F),
      ),
      spacing: 10,
      children: List.generate(
        _results.length,
        (i) => MyFishCard(fish: _results[i]),
      ),
    );
  }
}
