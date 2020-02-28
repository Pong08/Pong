import 'package:flutter/material.dart';

class BackgroundAppTheme {
  static const Color startColor = Colors.white;
  static const Color endColor = Color(0xFF82B1FF);

  static const LinearGradient backgroundPrimary = LinearGradient(
      colors: [startColor, endColor],
      //   colors: [endColor, startColor],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 1]);
}
