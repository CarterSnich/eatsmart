import 'package:flutter/material.dart';
import 'package:isdasmart/components/text_button.dart';

class MySliverScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double spacing;
  final double padding;
  final Widget? stickyBottom;
  final double stickyBottomHeight;

  const MySliverScaffold({
    super.key,
    required this.title,
    required this.children,
    this.spacing = 0,
    this.padding = 20,
    this.stickyBottom,
    this.stickyBottomHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: IntrinsicHeight(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MyTextButton(
                        text: "Back",
                        onPress: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
              shadowColor: Theme.of(context).scaffoldBackgroundColor,
              bottom: stickyBottom == null
                  ? null
                  : PreferredSize(
                      preferredSize: Size.fromHeight(stickyBottomHeight),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: stickyBottom!,
                      ),
                    ),
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
