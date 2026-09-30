import 'package:eatsmart/components/bubble_search_bar.dart';
import 'package:eatsmart/components/my_card.dart';
import 'package:eatsmart/components/my_pill.dart';
import 'package:eatsmart/components/sliver_scaffold.dart';
import 'package:eatsmart/fish_data.dart';
import 'package:eatsmart/generated_assets/assets.dart';
import 'package:eatsmart/helpers.dart';
import 'package:eatsmart/screens/fish.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FishesPage extends StatefulWidget {
  const FishesPage({super.key});

  @override
  State<FishesPage> createState() => _FishesPageState();
}

class _FishesPageState extends State<FishesPage> {
  List<Fish> _results = List.from(fishes.values);

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
    return SliverScaffold(
      customAppBar: SliverAppBar(
        title: Hero(
          tag: 'fishes',
          child: BubbleSearchBar(
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
                      return fish.englishName.toLowerCase().contains(q) ||
                          fish.binomialName.toLowerCase().contains(q);
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
        (i) => _FishCard(fish: _results[i]),
      ),
    );
  }
}

class _FishCard extends StatelessWidget {
  final Fish fish;
  const _FishCard({required this.fish});

  @override
  Widget build(BuildContext context) {
    return MyCard(
      child: InkWell(
        onTap: () => navigatePush(context, FishPage(fish: fish)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              spacing: 10,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    Assets.fishImagesBangus,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fish.englishName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      fish.binomialName,
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    Row(
                      spacing: 8,
                      children: [
                        if (fish.nutrition.mercury != null)
                          MyPill(
                            child: Text(
                              "MERCURY ${fish.nutrition.mercury?.toUpperCase()}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        if (fish.nutrition.protein != null)
                          MyPill(
                            child: Text(
                              "PROTEIN ${fish.nutrition.protein}",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
