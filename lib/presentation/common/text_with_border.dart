import 'package:flutter/material.dart';

Widget textWithBorder(
    {required String title,
    TextStyle? textStyle = const TextStyle(),
    double borderWidth = 3,
    Color borderColor = Colors.black}) {
  textStyle ??= const TextStyle();
  return Stack(
    children: [
      Text(
        title,
        style: textStyle.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = borderWidth
            ..color = borderColor,
        ),
      ),
      Text(
        title,
        style: textStyle,
      ),
    ],
  );
}
