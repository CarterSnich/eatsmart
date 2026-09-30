import 'package:eatsmart/about_data.dart';
import 'package:eatsmart/components/section.dart';
import 'package:eatsmart/components/sliver_scaffold.dart';
import 'package:flutter/material.dart';

import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _appName = "";
  String _appVersion = "";

  void _loadInfo() async {
    final info = await PackageInfo.fromPlatform();
    _appName = info.appName;
    _appVersion = info.version;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScaffold(
      title: "About",
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: Image.asset("assets/icon.png"),
        ),
        Text(
          _appName,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        Text(
          _appVersion,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: Colors.white),
        ),
        SizedBox(height: 20),
        Text.rich(
          TextSpan(
            text: 'EatSmart is a mobile application developed at ',
            children: [
              TextSpan(
                text: 'Leyte Normal University',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' as the result of the capstone research project titled ',
              ),
              TextSpan(
                text:
                    '“Deep Learning Fish Identification using YOLO26 with Feature Fusion Technique”',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              TextSpan(
                text:
                    ', created to support fish identification and educate users about the health benefits and potential health risks associated with different fish species.',
              ),
            ],
          ),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        SizedBox(height: 20),
        SectionList(
          label: "RESEARCH TEAM",
          children: [
            for (final item in researchers)
              ResearcherTile(
                initials: item['initials']!,
                name: item['name'],
                email: item['email'],
                bgColor: item['bgColor'],
                fgColor: item['fgColor'],
              ),
          ],
        ),
        SizedBox(height: 20),
        SectionList(
          label: "REFERENCES AND ACKNOWLEDGEMENTS",
          children: [
            for (final item in references)
              ReferenceTile(
                icon: item['icon']!,
                name: item['name']!,
                description: item['description']!,
              ),
          ],
        ),
      ],
    );
  }
}

class ResearcherTile extends StatelessWidget {
  final String initials;
  final String name;
  final String email;
  final Color bgColor;
  final Color fgColor;

  const ResearcherTile({
    super.key,
    required this.bgColor,
    required this.fgColor,
    required this.initials,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return SectionListItem(
      onPress: () {},
      child: Row(
        spacing: 8,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
            child: Text(
              initials,
              style: TextStyle(
                color: fgColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: Colors.white)),
                Text(email, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReferenceTile extends StatelessWidget {
  final String icon;
  final String name;
  final String description;

  const ReferenceTile({
    super.key,
    required this.icon,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SectionListItem(
      onPress: () {},
      child: Row(
        spacing: 8,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Image.asset(icon),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: Colors.white)),
                Text(description, style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
