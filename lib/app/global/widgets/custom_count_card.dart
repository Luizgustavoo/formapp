import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucif/app/utils/custom_text_style.dart';

class CustomCountCard extends StatelessWidget {
  final String title;
  final RxInt counter;
  final VoidCallback onTap;

  const CustomCountCard({
    required this.title,
    required this.counter,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
            color: Color(0xFF123d68),
            width: 1,
          ),
        ),
        shadowColor: const Color(0xFF123d68),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => Text(
                    textAlign: TextAlign.center,
                    counter.value.toString(),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 30,
                      color: Color(0xfffc9805),
                    ),
                  )),
              Text(
                title,
                textAlign: TextAlign.center,
                style: CustomTextStyle.homeCount(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
