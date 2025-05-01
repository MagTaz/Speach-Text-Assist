import 'package:flutter/material.dart';

import 'TextStyle.dart';

class TextFieldStyle {
  primaryTexrField(String text, Icon icon, Color color, Color textColor) {
    return InputDecoration(
        labelText: text,
        prefixIcon: icon,
        prefixIconColor: color,
        labelStyle: Text_Style.textStyleNormal(textColor, 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(width: 1.9, color: color.withOpacity(0.6))));
  }

  DescriptionTexrField(
    String text,
    Color color,
  ) {
    return InputDecoration(
        hintText: text,
        hintStyle: Text_Style.textStyleBold(color, 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(width: 1.9, color: color.withOpacity(0.6))));
  }
}
