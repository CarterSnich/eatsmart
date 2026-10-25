import 'package:eatsmart/components/fish_card.dart';
import 'package:eatsmart/data/fish_data.dart';
import 'package:eatsmart/models/fish.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final Uint8List imageBytes;
  final List<String> labels;
  final int imageRotation;

  const ResultPage({
    super.key,
    required this.imageBytes,
    required this.labels,
    this.imageRotation = 0,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<String> get _labels => widget.labels;
  Uint8List get _imageBytes => widget.imageBytes;
  int get _imageRotation => widget.imageRotation;

  static const double _minSheet = 0.2;
  static const double _maxSheet = 0.70;
  static const double _minImageHeight = 120;

  final ValueNotifier<double> _extent = ValueNotifier(_minSheet);

  @override
  void dispose() {
    _extent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;

          return Stack(
            children: [
              ValueListenableBuilder<double>(
                valueListenable: _extent,
                builder: (_, extent, child) {
                  final imageHeight = (h * (1 - extent) + 24).clamp(
                    _minImageHeight,
                    h,
                  );
                  return Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: imageHeight,
                    child: child!,
                  );
                },
                child: ColoredBox(
                  color: Colors.black,
                  child: SizedBox.expand(
                    child: RotatedBox(
                      quarterTurns: _imageRotation,
                      child: Image.memory(
                        _imageBytes,
                        fit: BoxFit.contain,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                ),
              ),
              NotificationListener<DraggableScrollableNotification>(
                onNotification: (n) {
                  _extent.value = n.extent;
                  return false;
                },
                child: DraggableScrollableSheet(
                  initialChildSize: _minSheet,
                  minChildSize: _minSheet,
                  maxChildSize: _maxSheet,
                  snap: true,
                  snapSizes: [_minSheet, _maxSheet],
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        boxShadow: const [
                          BoxShadow(blurRadius: 8, color: Colors.black26),
                        ],
                      ),
                      child: CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          SliverPersistentHeader(
                            pinned: true,
                            floating: true,
                            delegate: _HandleDelegate(
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            sliver: SliverList.builder(
                              itemCount: _labels.length,
                              itemBuilder: (_, i) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: MyFishCard(
                                  fish: fishes[_labels[i]] as FishData,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HandleDelegate extends SliverPersistentHeaderDelegate {
  final Color color;
  _HandleDelegate({required this.color});

  @override
  double get minExtent => 28;
  @override
  double get maxExtent => 28;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: color,
      alignment: Alignment.center,
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_HandleDelegate old) => old.color != color;
}
