import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/app/app_prefs.dart';
import 'package:puzzle_mvvm/presentation/resources/languages_manager.dart';

import '../../../app/di.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final AppPreferences _appPreferences = instance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  context.setLocale(ENGLISH_LOCAL);
                  _appPreferences.changeAppLanguage(LanguageType.ENGLISH);
                },
                child: Text("English")),
            TextButton(
                onPressed: () {
                  context.setLocale(FRENSH_LOCAL);
                  _appPreferences.changeAppLanguage(LanguageType.FRENSH);
                },
                child: Text("Frensh")),
            TextButton(
                onPressed: () {
                  context.setLocale(ARABIC_LOCAL);
                  _appPreferences.changeAppLanguage(LanguageType.ARABIC);
                },
                child: Text("Arabic")),
          ],
        ),
      ),
    );
  }
}
