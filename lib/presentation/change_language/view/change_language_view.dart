import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/app/app_prefs.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/routes_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/values_manager.dart';

import '../../../app/di.dart';
import '../../common/text_with_border.dart';
import '../../resources/constants_manager.dart';
import '../../resources/fonts_manager.dart';
import '../../resources/languages_manager.dart';
import '../../resources/styles_manager.dart';

class ChangeLanguageView extends StatelessWidget {
  ChangeLanguageView({super.key});
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          color: ColorsManager.primary,
        ),
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: ColorsManager.lightPrimary.withOpacity(0.84),
                offset: const Offset(0.0, 0.0),
                spreadRadius: 0.0,
                blurRadius: size.width,
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _getButton(
                  context, size, 'Français', FRENSH_LOCAL, LanguageType.FRENSH),
              SizedBox(
                height: AppSize.s50 * (size.height / 926),
              ),
              _getButton(context, size, 'English', ENGLISH_LOCAL,
                  LanguageType.ENGLISH),
              SizedBox(
                height: AppSize.s50 * (size.height / 926),
              ),
              _getButton(
                  context, size, 'العربية', ARABIC_LOCAL, LanguageType.ARABIC)
            ],
          ),
        ),
      ],
    ));
  }

  Widget _getButton(BuildContext context, Size size, String title,
      Locale languageLocal, LanguageType languageType) {
    return SizedBox(
      height: 84 * (size.height / 926),
      width: 264 * (size.width / 428),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.lightPrimary,
          shape: const StadiumBorder(),
          side: BorderSide(color: ColorsManager.primary, width: 1),
        ),
        onPressed: () {
          context.setLocale(languageLocal);
          _appPreferences.changeAppLanguage(languageType);
          Navigator.pushReplacementNamed(context, Routes.homeRoute);
        },
        child: textWithBorder(
            title: title,
            textStyle: getRegularStyle(
                fontFamily: FontsConstants.mudir,
                fontSize: 30,
                color: ColorsManager.lightOrange),
            borderColor: ColorsManager.orange,
            borderWidth: ConstantsManager.borderWidth),
      ),
    );
  }
}
