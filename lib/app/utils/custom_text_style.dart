import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle? title(BuildContext context) {
    return const TextStyle(
      fontSize: 20,
      color: Colors.black87,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle? date(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: Colors.orange.shade900,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle? login(BuildContext context) {
    return const TextStyle(
      fontSize: 25,
      color: Colors.black54,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle? titleSplash(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      color: Colors.orange.shade800,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle? subtitle(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontFamily: 'Poppinss',
    );
  }

  static TextStyle? subtitleNegrit(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      color: Colors.black87,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle? button(BuildContext context) {
    return const TextStyle(
      fontSize: 12,
      color: Colors.white,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle? button2(BuildContext context) {
    return const TextStyle(
      fontSize: 12,
      color: Colors.black87,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle? form(BuildContext context) {
    return const TextStyle(
      fontSize: 14,
      color: Colors.black87,
      fontFamily: 'Poppinss',
    );
  }

  static TextStyle? desc(BuildContext context) {
    return const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontFamily: 'Poppinss',
        overflow: TextOverflow.clip);
  }
}
