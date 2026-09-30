import 'package:eatsmart/components/bubble_button.dart';
import 'package:eatsmart/components/bubble_search_bar.dart';
import 'package:eatsmart/helpers.dart';
import 'package:eatsmart/main.dart';
import 'package:eatsmart/screens/about.dart';
import 'package:eatsmart/screens/fishes.dart';
import 'package:eatsmart/screens/recents.dart';
import 'package:eatsmart/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with RouteAware {
  final YOLOViewController _yoloViewController = YOLOViewController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() async {
    _yoloViewController.stop();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPushNext() {
    _yoloViewController.pause();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    _yoloViewController.resume();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YOLOView(
            controller: _yoloViewController,
            modelPath: "assets/model.tflite",
            onModelError: (error, modelPath, task) =>
                Fluttertoast.showToast(msg: "${error.toString()} | $modelPath"),
          ),
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'fishes',
                            child: BubbleSearchBar(
                              onTap: () {
                                navigatePushHero(context, FishesPage());
                              },
                              child: Text(
                                'Search fish',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        BubbleButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutPage(),
                              ),
                            );
                          },
                          padding: 12,
                          child: Icon(
                            MdiIcons.information,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BubbleButton(
                          onPressed: () {
                            // Pick image from gallery
                          },
                          padding: 20,
                          child: Icon(
                            MdiIcons.imageMultiple,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            NavButton(
                              icon: MdiIcons.clockStarFourPointsOutline,
                              label: "Recent",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecentsPage(),
                                  ),
                                );
                              },
                            ),
                            NavButton(
                              icon: MdiIcons.cogOutline,
                              label: "Settings",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const NavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 32),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
