// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/presentation/resources/languages_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_DATA = "PREFS_KEY_DATA";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);
  //language
  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> changeAppLanguage(LanguageType languageType) async {
    _sharedPreferences.setString(PREFS_KEY_LANG, languageType.getValue());
  }

  Future<Locale> getLocale() async {
    String language = await getAppLanguage();
    if (language == LanguageType.ARABIC.getValue()) {
      return ARABIC_LOCAL;
    } else if (language == LanguageType.FRENSH.getValue()) {
      return FRENSH_LOCAL;
    } else {
      return ENGLISH_LOCAL;
    }
  }

  //save data
  Future<void> setData(List<String> dataList) async {
    await _sharedPreferences.setStringList(PREFS_KEY_DATA, dataList);
  }

  List<String> getData() {
    List<String>? data = _sharedPreferences.getStringList(PREFS_KEY_DATA);
    return data ?? [];
  }
}
