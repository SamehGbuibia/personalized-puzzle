import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/presentation/common/text_with_border.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/fonts_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/styles_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/values_manager.dart';

Widget getHeaderWidget(Size size, String text, String pic) {
  return Padding(
    padding: EdgeInsets.only(top: size.height / 30),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
          height: size.height / 6,
          width: size.width - (size.width / 2.5),
          child: Center(
            child: textWithBorder(
                title: text,
                textStyle: getRegularStyle(
                    fontFamily: FontsConstants.mudir,
                    fontSize: 40,
                    color: ColorsManager.primary),
                borderColor: ColorsManager.mediumBodyTextBorderColor,
                borderWidth: ConstantsManager.borderWidth),
          ),
          // SvgPicture.asset(
          //   svgPic,
          //   fit: BoxFit.contain,
          // ),
        ),
        SizedBox(
          height: size.height / 6,
          width: size.width / 2.5,
          child: Image.asset(
            pic,
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
  );
}
