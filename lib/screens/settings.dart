import 'dart:io';

import 'package:eatsmart/components/dialog.dart';
import 'package:eatsmart/components/section.dart';
import 'package:eatsmart/components/settings_item.dart';
import 'package:eatsmart/components/sliver_scaffold.dart';
import 'package:eatsmart/helpers.dart';
import 'package:eatsmart/screens/about.dart';
import 'package:eatsmart/theme/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:simple_loading_dialog/simple_loading_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _storage = GetStorage();

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
    await _storage.write("model_path", newModelPath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MySliverScaffold(
      title: "Settings",
      spacing: 16,
      children: [
        MySectionList(
          label: "APPEARANCE",
          padding: 0,
          children: [
            MySettingsItem(
              label: "Theme mode",
              description: switch (context.watch<ThemeProvider>().themeMode) {
                ThemeMode.light => "Light mode",
                ThemeMode.dark => "Dark mode",
                _ => "System",
              },
              onPress: () => showDialog(
                context: context,
                builder: (context) => MyDialogPicker<ThemeMode>(
                  items: {
                    ThemeMode.light: "Light",
                    ThemeMode.dark: "Dark",
                    ThemeMode.system: "System",
                  },
                  cb: (item) =>
                      context.read<ThemeProvider>().setThemeMode(item),
                ),
              ),
            ),
          ],
        ),
        MySectionList(
          label: "MODEL",
          padding: 0,
          children: [
            MySettingsItem(
              label: "Model path",
              description: _storage.read("model_path") ?? "Default model",
              onPress: () => _clickModelPathItem(context),
            ),
          ],
        ),
        MySectionList(
          label: "ABOUT",
          children: [
            MySettingsItem(
              label: "About EatSmart",
              description: "Learn more about the app",
              onPress: () => navigatePush(context, AboutPage()),
            ),
          ],
        ),
      ],
    );
  }
}
