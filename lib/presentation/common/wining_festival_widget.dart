import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/presentation/common/text_with_border.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/strings_manager.dart';

Widget festival(BuildContext context, ConfettiController controller) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: ColorsManager.lighBlack,
      child: Center(
        child: ConfettiWidget(
          confettiController: controller,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: true,
          child: textWithBorder(
            title: StringsManager.bravo.tr(),
            textStyle: Theme.of(context).textTheme.headlineLarge,
            borderColor: ColorsManager.winingTextBorderColor,
            borderWidth: ConstantsManager.winingBorderWidth,
          ),
        ),
      ),
    ),
  );
}
