import 'package:eatsmart/screens/scan_result.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:eatsmart/fishes.dart';

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
  List<dynamic> results = [];
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

  Future<void> _captureImage(BuildContext context) async {
    await _initializeControllerFuture;
    final image = await _cameraController.takePicture();
    final imageBytes = await image.readAsBytes();
    final results = await yolo!.predict(imageBytes);
    final resultLabel = results['classification']['name'];
    final fishData = fishDatabase[resultLabel];

    if (context.mounted && fishData != null) {
      showModalBottomSheet(
        useSafeArea: true,
        elevation: 10,
        showDragHandle: true,
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            child: buildScanResult(context, resultLabel, fishData),
          ),
        ),
      );
    }
  }

  Future<void> _loadYOLO() async {
    setState(() => isLoading = true);

    yolo = YOLO(modelPath: 'best_float32', task: YOLOTask.classify);

    await yolo!.loadModel();
    setState(() => isLoading = false);
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
      final results = await yolo!.predict(imageBytes);
      final resultLabel = results['classification']['name'];
      final fishData = fishDatabase[resultLabel];

      if (context.mounted && fishData != null) {
        showModalBottomSheet(
          useSafeArea: true,
          elevation: 10,
          showDragHandle: true,
          isScrollControlled: true,
          enableDrag: true,
          context: context,
          builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => SingleChildScrollView(
              child: buildScanResult(context, resultLabel, fishData),
            ),
          ),
        );
      }
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
