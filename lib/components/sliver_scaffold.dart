import 'package:flutter/material.dart';

class SliverScaffold extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final SliverAppBar? customAppBar;
  final double spacing;
  final double padding;

  const SliverScaffold({
    super.key,
    this.title,
    required this.children,
    this.customAppBar,
    this.spacing = 0,
    this.padding = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF08111F),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            if (customAppBar != null)
              customAppBar!
            else if (title != null)
              SliverAppBar(
                title: Text(
                  title!,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                floating: true,
                snap: true,
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF08111F),
              ),
            SliverPadding(
              padding: EdgeInsets.all(padding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    spacing: spacing,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
