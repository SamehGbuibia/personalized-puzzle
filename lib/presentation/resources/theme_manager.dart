import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/fonts_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/styles_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    //main colors
    primaryColor: ColorsManager.primary,
    primaryColorLight: ColorsManager.lightPrimary,
    disabledColor: ColorsManager.grey,
    splashColor: ColorsManager.orange,
    //cardView Theme
    cardTheme: CardTheme(
      color: ColorsManager.white,
      shadowColor: ColorsManager.grey,
      elevation: AppSize.s4,
    ),
    //app Bar Theme
    appBarTheme: AppBarTheme(
      color: ColorsManager.lightPrimary,
      elevation: AppSize.s6,
      shadowColor: ColorsManager.black,
    ),
    //button Theme
    buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        disabledColor: ColorsManager.grey,
        buttonColor: ColorsManager.buttonColor,
        splashColor: ColorsManager.lightPrimary),
    //elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
            fontFamily: FontsConstants.mudir,
            color: ColorsManager.buttonTextColor),
        primary: ColorsManager.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),
    //text theme
    textTheme: TextTheme(
      displayLarge: getRegularStyle(
          fontFamily: FontsConstants.j10d,
          fontSize: FontSize.s75,
          color: ColorsManager.black),
      headlineLarge: getRegularStyle(
          color: ColorsManager.winingTextColor, fontSize: FontSize.s50),
      headlineMedium: getRegularStyle(
          fontFamily: FontsConstants.mudir,
          color: ColorsManager.buttonTextColor),
      titleMedium: getRegularStyle(
        fontFamily: FontsConstants.htowert,
        color: ColorsManager.titleColor,
        // fontSize: FontSize.s30
      ),
      titleSmall: getMediumStyle(
          fontFamily: FontsConstants.mudir,
          color: ColorsManager.titleColor,
          fontSize: FontSize.s12),
      titleLarge: getBoldStyle(
          color: ColorsManager.titleColor,
          fontFamily: FontsConstants.htowert,
          fontSize: FontSize.s22),
      bodyLarge: getBoldStyle(
        color: ColorsManager.largeBodyTextColor,
        fontSize: FontSize.s30,
        fontFamily: FontsConstants.monotype,
      ),
      bodyMedium: getRegularStyle(
        color: ColorsManager.primary,
        fontSize: FontSize.s22,
        fontFamily: FontsConstants.mudir,
      ),
      bodySmall: getBoldStyle(
          color: ColorsManager.titleColor,
          fontSize: FontSize.s18,
          fontFamily: FontsConstants.htowert),
      labelSmall: getBoldStyle(
        color: ColorsManager.redAccent,
        fontSize: FontSize.s12,
      ),
    ),
  );
}
