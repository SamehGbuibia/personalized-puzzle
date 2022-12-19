import 'package:flutter/cupertino.dart';
import 'package:puzzle_mvvm/presentation/resources/fonts_manager.dart';

TextStyle _getTextStyle(
  String? fontFamily,
  double fontSize,
  FontWeight fontWeight,
  Color? color,
) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

//light
TextStyle getLightStyle(
    {String? fontFamily, double fontSize = FontSize.s20, Color? color}) {
  return _getTextStyle(fontFamily, fontSize, FontsWeightManager.light, color);
}

//regular
TextStyle getRegularStyle(
    {String? fontFamily, double fontSize = FontSize.s20, Color? color}) {
  return _getTextStyle(fontFamily, fontSize, FontsWeightManager.regular, color);
}

//medium
TextStyle getMediumStyle(
    {String? fontFamily, double fontSize = FontSize.s20, Color? color}) {
  return _getTextStyle(fontFamily, fontSize, FontsWeightManager.medium, color);
}

//semiBold
TextStyle getSemiBoldStyle(
    {String? fontFamily, double fontSize = FontSize.s20, Color? color}) {
  return _getTextStyle(
      fontFamily, fontSize, FontsWeightManager.semiBold, color);
}

//bold
TextStyle getBoldStyle(
    {String? fontFamily, double fontSize = FontSize.s20, Color? color}) {
  return _getTextStyle(fontFamily, fontSize, FontsWeightManager.bold, color);
}
