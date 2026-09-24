import 'package:eatsmart/components/card.dart';
import 'package:eatsmart/components/pill.dart';
import 'package:eatsmart/components/text_button.dart';
import 'package:eatsmart/tabs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final List<Map<String, String>> quotes = [
    {
      'headline': 'Eat Smart',
      'body':
          'Making informed choices about the food you eat can help you build healthier meals, understand what your body needs, and enjoy every bite with greater confidence.',
    },
    {
      'headline': 'Fresh Choices',
      'body':
          'Every ingredient has a story. Take a moment to learn where your food comes from, what it contains, and how it can contribute to a balanced and nutritious meal.',
    },
    {
      'headline': 'Know Your Fish',
      'body':
          'Not sure what fish you brought home from the market? Identify your catch and discover useful information about its nutritional value, common names, and characteristics.',
    },
    {
      'headline': 'Choose Wisely',
      'body':
          'Understanding the food on your plate gives you the information you need to make choices that suit your preferences, dietary needs, and the people you are preparing meals for.',
    },
    {
      'headline': 'From Catch to Plate',
      'body':
          'From the moment you find your fish at the market to the moment it becomes part of your meal, knowing what you are buying can help you prepare food with greater confidence.',
    },
  ];

  int _currentQouteIndex = 0;

  void _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("is_first_launch", false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabbedPage()),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 12.0,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: AnimatedCircles(),
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
                        Text(
                          quotes[_currentQouteIndex]['headline']!,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          quotes[_currentQouteIndex]['body']!,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentQouteIndex,
                  count: quotes.length,
                  effect: WormEffect(
                    dotWidth: 12,
                    dotHeight: 12,
                    activeDotColor: Colors.grey.shade900,
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
                        if (_currentQouteIndex == quotes.length - 1) {
                          _navigate();
                        } else if (_currentQouteIndex < quotes.length - 1) {
                          setState(() {
                            _currentQouteIndex++;
                          });
                        }
                      },
                      text: _currentQouteIndex == quotes.length - 1
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

class AnimatedCircles extends StatefulWidget {
  const AnimatedCircles({super.key});

  @override
  State<AnimatedCircles> createState() => _AnimatedCirclesState();
}

class _AnimatedCirclesState extends State<AnimatedCircles>
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
                child: _circle(240, const Color(0xFF0791C3), 0.18),
              ),

              // Middle
              Transform.scale(
                scale: scale(0.21, 0.78, t),
                child: _circle(204, const Color(0xFF92C8DB), 0.12),
              ),

              // Inner
              Transform.scale(
                scale: scale(0.0, 0.56, t),
                child: _circle(136, const Color(0xFF003AB8), 0.08),
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
