import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  const ShowCaseView(
      {super.key,
      required this.globalKey,
      required this.title,
      required this.description,
      required this.child,
      required this.border});

  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder border;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      titlePadding: const EdgeInsets.all(5),
      descriptionPadding: const EdgeInsets.all(5),
      showArrow: true,
      descriptionAlignment: TextAlign.justify,
      titleAlignment: TextAlign.center,
      blurValue: 2,
      titleTextStyle: TextStyle(
        color: Colors.orange.shade700,
        fontSize: 17,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
      ),
      descTextStyle: const TextStyle(
        color: Colors.black87,
        fontSize: 15,
        fontFamily: 'Poppinss',
        overflow: TextOverflow.clip,
      ),
      title: title,
      key: globalKey,
      description: description,
      child: child,
    );
  }
}
