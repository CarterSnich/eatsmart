import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isdasmart/components/fish_card.dart';
import 'package:isdasmart/data/fish_data.dart';
import 'package:isdasmart/models/fish.dart';

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
  static const double _maxSheet = 0.60;
  static const double _minImageHeight = 120;

  final ValueNotifier<double> _extent = ValueNotifier(_minSheet);

  @override
  void dispose() {
    _extent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
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
                    final imageHeight = (h * (1 - extent)).clamp(
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Stack(
                              fit: StackFit.passthrough,
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.memory(
                                    _imageBytes,
                                    fit: BoxFit.contain,
                                    gaplessPlayback: true,
                                  ),
                                ),
                                Positioned.fill(
                                  child: CustomPaint(painter: CornerPainter()),
                                ),
                              ],
                            ),
                          ),
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
                        clipBehavior: Clip.antiAlias,
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

class CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const length = 24.0;
    const radius = 8.0;
    const stroke = 3.0;
    const inset = stroke / 2;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width - inset;
    final h = size.height - inset;
    const l = inset;
    const t = inset;
    const r = Radius.circular(radius);

    final path = Path()
      // Top-left
      ..moveTo(l, t + length)
      ..lineTo(l, t + radius)
      ..arcToPoint(const Offset(l + radius, t), radius: r, clockwise: true)
      ..lineTo(l + length, t)
      // Top-right
      ..moveTo(w - length, t)
      ..lineTo(w - radius, t)
      ..arcToPoint(Offset(w, t + radius), radius: r, clockwise: true)
      ..lineTo(w, t + length)
      // Bottom-right
      ..moveTo(w, h - length)
      ..lineTo(w, h - radius)
      ..arcToPoint(Offset(w - radius, h), radius: r, clockwise: true)
      ..lineTo(w - length, h)
      // Bottom-left
      ..moveTo(l + length, h)
      ..lineTo(l + radius, h)
      ..arcToPoint(Offset(l, h - radius), radius: r, clockwise: true)
      ..lineTo(l, h - length);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CornerPainter oldDelegate) => false;
}
