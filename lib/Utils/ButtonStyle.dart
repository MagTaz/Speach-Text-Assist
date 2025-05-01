import 'package:flutter/material.dart';

class Button_Style {
  static ButtonStyle buttonStyle(
      BuildContext context, Color color, double shadow) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      fixedSize: Size(MediaQuery.of(context).size.width, 50),
    );
  }
}
