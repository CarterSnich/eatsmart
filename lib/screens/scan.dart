import 'dart:io';

import 'package:eatsmart/components/bubble_button.dart';
import 'package:eatsmart/components/bubble_search_bar.dart';
import 'package:eatsmart/components/pill.dart';
import 'package:eatsmart/components/nav_button.dart';
import 'package:eatsmart/components/text_button.dart';
import 'package:eatsmart/data/fish_data.dart';
import 'package:eatsmart/generated_assets/assets.dart';
import 'package:eatsmart/helpers.dart';
import 'package:eatsmart/main.dart';
import 'package:eatsmart/models/fish.dart';
import 'package:eatsmart/screens/about.dart';
import 'package:eatsmart/screens/fishes.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:eatsmart/screens/image.dart';
import 'package:eatsmart/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

import 'fish.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with RouteAware {
  bool _isReady = false;
  late PermissionStatus _cameraStatus;

  final YOLOViewController _yoloViewController = YOLOViewController();
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _initCameraStatus();
    _yoloViewController.setShowOverlays(false);
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

  void _initCameraStatus() async {
    _cameraStatus = await Permission.camera.status;
    setState(() {
      _isReady = true;
    });
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _cameraStatus = status;
    });
  }

  void _pushImageDetect(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageDetectPage(imageFile: image),
      ),
    );
  }

  void _onResult(List<YOLOResult> results) {
    final labels = results
        .where((r) => r.className != 'background')
        .map((r) => r.className)
        .toSet()
        .toList();

    setState(() {
      _labels = labels;
    });
  }

  void _onModelError(Object error, String modelPath, YOLOTask? task) {
    Fluttertoast.showToast(msg: "${error.toString()}: $modelPath");
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _pushImageDetect(File(image.path));
    }
  }

  void _onLabelPress(String label) {
    if (label == 'other') return;

    FishData? fish = fishes[label];

    if (fish == null) {
      Fluttertoast.showToast(msg: "Fish unknown.");
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FishPage(fish: fish)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isReady
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                _cameraStatus.isGranted
                    ? YOLOView(
                        controller: _yoloViewController,
                        modelPath: Assets.model,
                        onResult: _onResult,
                        onModelError: _onModelError,
                      )
                    : Align(
                        alignment: AlignmentGeometry.center,
                        child: Column(
                          children: [
                            Text(
                              "Please allow camera access to use the scanner.",
                            ),
                            if (_cameraStatus.isDenied)
                              MyTextButton(
                                onPress: _requestCameraPermission,
                                text: "Request camera permission",
                              ),
                          ],
                        ),
                      ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(100, 0, 0, 0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.viewPaddingOf(context).top + 20,
                            bottom: 20,
                            left: 20,
                            right: 20,
                          ),
                          child: Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: Hero(
                                  tag: 'fishes',
                                  child: MyBubbleSearchBar(
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
                              MyBubbleButton(
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
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Wrap(
                              spacing: 8,
                              children: List.generate(
                                _labels.length,
                                (index) => MyPill(
                                  backgroundColor: Colors.white70,
                                  child: Text(
                                    _labels[index].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPress: () => _onLabelPress(_labels[index]),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(100, 0, 0, 0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  MyBubbleButton(
                                    onPressed: _pickFromGallery,
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
                                      // NavButton(
                                      //   icon: MdiIcons.clockStarFourPointsOutline,
                                      //   label: "Recent",
                                      //   onPressed: () {
                                      //     Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //         builder: (context) => RecentsPage(),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                      MyNavButton(
                                        icon: MdiIcons.cogOutline,
                                        label: "Settings",
                                        onPressed: () => navigatePush(
                                          context,
                                          SettingsPage(),
                                        ),
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
              ],
            ),
    );
  }
}
