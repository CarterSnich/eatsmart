import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:eatsmart/fishes.dart';
import "package:material_design_icons_flutter/material_design_icons_flutter.dart";

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _PageState();
}

class _PageState extends State<ScannerScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  File? selectedImage;

  YOLO? yolo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initCamera();
    _loadYOLO();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();

    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // Next, initialize the controller. This returns a Future.
    await _cameraController.initialize();
  }

  Future<void> _loadYOLO() async {
    setState(() => isLoading = true);

    yolo = YOLO(modelPath: 'fish', task: YOLOTask.classify);

    await yolo!.loadModel();
    setState(() => isLoading = false);
  }

  Future<void> _classify(Uint8List imageBytes) async {
    final results = await yolo!.predict(imageBytes);
    final classification = results['classification'];
    final double confidence = classification['confidence'];
    final resultLabel = classification['name'];
    final Fish? fishData = fishDatabase[resultLabel];

    Fluttertoast.showToast(
      msg: "$resultLabel ${(confidence * 100).toStringAsFixed(2)}%",
    );
    if (!context.mounted) {
      Fluttertoast.showToast(msg: "Failed to show results.");
    } else if (confidence < 0.9 || fishData == null) {
      Fluttertoast.showToast(msg: "No fish classified");
    } else {
      showResultModalSheet(resultLabel, fishData, imageBytes);
    }
  }

  void showResultModalSheet(
    String label,
    Fish fishData,
    Uint8List? imageBytes,
  ) {
    showModalBottomSheet(
      useSafeArea: true,
      elevation: 10,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: buildScanResult(context, label, fishData, imageBytes),
        ),
      ),
    );
  }

  Future<void> _captureImage(BuildContext context) async {
    await _initializeControllerFuture;
    final image = await _cameraController.takePicture();
    final imageBytes = await image.readAsBytes();
    await _classify(imageBytes);
  }

  Future<void> _pickAndDetect(BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        isLoading = true;
      });

      final imageBytes = await selectedImage!.readAsBytes();
      await _classify(imageBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return SizedBox.expand(
                        child: CameraPreview(_cameraController),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                // pick from album
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.image_rounded, size: 42),
                    onPressed: () {
                      _pickAndDetect(context);
                    },
                  ),
                ),
                // capture button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: IconButton(
                      icon: const Icon(Icons.camera, size: 76),
                      onPressed: () {
                        _captureImage(context);
                      },
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

Widget buildScanResult(
  BuildContext context,
  String label,
  Fish fishData,
  Uint8List? imageBytes,
) {
  return Column(
    children: [
      Stack(
        children: [
          imageBytes == null
              ? Image.asset("assets/$label.jpg")
              : Image.memory(imageBytes),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Theme.of(context).canvasColor],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fishData.popularName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  fishData.binomialName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              color: Colors.blue.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text("LOCAL NAMES"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: fishData.localNames
                    .map(
                      (item) => Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Theme.of(context).canvasColor,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(item),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            // DESCRIPTION
            Text(
              "Description",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              fishData.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            // MINERAL
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      color: Colors.blue.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(MdiIcons.triangleWave),
                            Text(
                              "PROTEIN",
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                            ),
                            Text(
                              fishData.nutrition.protein,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      color: Colors.purple.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(MdiIcons.lightningBoltOutline),
                            Text(
                              "MERCURY",
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple.shade800,
                                  ),
                            ),
                            Text(
                              fishData.nutrition.mercury,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      color: Colors.yellow.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(MdiIcons.omega),
                            Text(
                              "OMEGA",
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow.shade800,
                                  ),
                            ),
                            Text(
                              fishData.nutrition.omega3,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // HEALTH BENEFITS
            Row(
              spacing: 8,
              children: [
                Icon(
                  MdiIcons.informationSlabCircleOutline,
                  color: Colors.green.shade300,
                ),
                Text(
                  "Health Benefits",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: fishData.healthChecks.map((data) {
                return Card(
                  color: Theme.of(context).canvasColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xE4E1E1FF)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      spacing: 10,
                      children: [
                        Icon(MdiIcons.check, color: Colors.green.shade300),
                        Text(
                          data,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 20),

            // Consumption Risks
            Row(
              spacing: 8,
              children: [
                Icon(
                  MdiIcons.alertCircleOutline,
                  color: Colors.yellow.shade400,
                ),
                Text(
                  "Consumption Risks",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: fishData.healthRisks.map((data) {
                return Card(
                  color: Colors.yellow.shade200,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      data,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade900,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ],
  );
}
