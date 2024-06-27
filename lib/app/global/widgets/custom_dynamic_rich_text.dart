import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DynamicRichText extends StatelessWidget {
  final RxInt value;
  final String description;
  final TextStyle valueStyle;
  final TextStyle descriptionStyle;
  final Color? color;
  final String routeR;

  const DynamicRichText(
      {Key? key,
      required this.value,
      required this.description,
      required this.valueStyle,
      required this.descriptionStyle,
      required this.color,
      required this.routeR})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.offAllNamed(routeR);
      },
      child: Obx(
        () => RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '$value',
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Poppinss',
              color: color,
              height: 1,
            ),
            children: [
              TextSpan(
                text: '\n$description',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppinss',
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
