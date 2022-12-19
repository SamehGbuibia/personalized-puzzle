import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/languages_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/values_manager.dart';

Widget getPuzzleFloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    mini: true,
    backgroundColor: ColorsManager.white.withOpacity(AppOpacity.o83),
    onPressed: () => Navigator.pop(context),
    child: Transform.rotate(
      angle: context.locale == ARABIC_LOCAL ? pi : 0,
      child: Icon(
        Icons.arrow_back_ios_rounded,
        color: ColorsManager.blue,
        size: AppSize.s25,
      ),
    ),
  );
}
