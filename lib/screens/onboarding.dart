import 'package:eatsmart/components/my_card.dart';
import 'package:eatsmart/components/my_pill.dart';
import 'package:eatsmart/components/text_button.dart';
import 'package:eatsmart/screens/scan.dart';
import 'package:eatsmart/welcome_messages_data.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentQouteIndex = 0;

  void _navigate() async {
    await GetStorage().write("is_first_launch", false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScanPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16.0,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyCard(
                    radius: 32,
                    borderWidth: 0,
                    padding: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 12.0,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: _AnimatedCircles(),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: MyPill(
                                  child: Row(
                                    spacing: 8,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.yellow.shade900,
                                        ),
                                      ),
                                      Text("Welcome aboard"),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          layoutBuilder: (currentChild, previousChildren) {
                            return Stack(
                              alignment: Alignment.centerLeft,
                              children: [...previousChildren, ?currentChild],
                            );
                          },
                          child: Text(
                            welcomeMessages[_currentQouteIndex]['headline']!,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            key: ValueKey(
                              welcomeMessages[_currentQouteIndex]['headline']!,
                            ),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            welcomeMessages[_currentQouteIndex]['body']!,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                            key: ValueKey(
                              welcomeMessages[_currentQouteIndex]['body']!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentQouteIndex,
                  count: welcomeMessages.length,
                  effect: WormEffect(
                    dotWidth: 12,
                    dotHeight: 12,
                    activeDotColor: Colors.white,
                    dotColor: Colors.grey.shade700,
                  ),
                  onDotClicked: (index) => setState(() {
                    _currentQouteIndex = index;
                  }),
                ),
              ),
              Row(
                spacing: 10.0,
                children: [
                  MyTextButton(onPress: _navigate, text: "Skip"),
                  Expanded(
                    child: MyTextButton(
                      onPress: () {
                        if (_currentQouteIndex == welcomeMessages.length - 1) {
                          _navigate();
                        } else if (_currentQouteIndex <
                            welcomeMessages.length - 1) {
                          setState(() {
                            _currentQouteIndex++;
                          });
                        }
                      },
                      text: _currentQouteIndex == welcomeMessages.length - 1
                          ? "Finish"
                          : "Next",
                      backgroundColor: Colors.grey.shade900,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCircles extends StatefulWidget {
  @override
  State<_AnimatedCircles> createState() => _AnimatedCirclesState();
}

class _AnimatedCirclesState extends State<_AnimatedCircles>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double scale(double start, double end, double t) {
    if (t < start || t > end) return 1;

    final progress = (t - start) / (end - start);

    return 1 +
        0.15 *
            Curves.easeInOut.transform(
              progress < 0.5 ? progress * 2 : (1 - progress) * 2,
            );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        final t = controller.value;

        return SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer
              Transform.scale(
                scale: scale(0.43, 1.0, t),
                child: _circle(240, Colors.blue.shade900, 0.18),
              ),

              // Middle
              Transform.scale(
                scale: scale(0.21, 0.78, t),
                child: _circle(204, Colors.blue.shade700, 0.12),
              ),

              // Inner
              Transform.scale(
                scale: scale(0.0, 0.56, t),
                child: _circle(136, Colors.blue, 0.08),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _circle(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}
