import 'package:eatsmart/components/section.dart';
import 'package:eatsmart/components/sliver_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<String?> _pickAndCopyFile() async {
    PlatformFile? result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ["tflite"],
    );
    if (result == null) return null;

    if (!result.name.endsWith('.tflite')) {
      Fluttertoast.showToast(msg: 'Please select a .tflite file');
      return null;
    }

    final file = File(result.path!);
    final appDir = await getApplicationDocumentsDirectory();
    final destination = '${appDir.path}/${result.name}';
    file.copySync(destination);

    return result.name;
  }

  void _clickModelPathItem(BuildContext context) async {
    final newModelPath = await showSimpleLoadingDialog<String?>(
      context: context,
      future: _pickAndCopyFile,
    );

    if (newModelPath == null) return;
    await GetStorage().write("model_path", newModelPath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      title: "Settings",
      children: [
        SectionList(
          label: "MODEL",
          padding: 0,
          children: [
            SettingsItem(
              label: "Model path",
              description: GetStorage().read("model_path") ?? "Default model",
              onPress: () => _clickModelPathItem(context),
            ),
          ],
        ),
      ],
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String label;
  final String? description;
  final VoidCallback onPress;

  const SettingsItem({
    super.key,
    required this.label,
    required this.onPress,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SectionListItem(
      onPress: onPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          Text("$description", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
