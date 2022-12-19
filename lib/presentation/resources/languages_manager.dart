import 'package:flutter/material.dart';

enum LanguageType { ENGLISH, ARABIC, FRENSH }

const String ENGLISH = "en";
const String ARABIC = "ar";
const String FRENSH = "fr";

const String ASSET_PATH_LOCALISATIONS = "assets/translations";

const Locale ARABIC_LOCAL = Locale("ar", "SA");
const Locale ENGLISH_LOCAL = Locale("en", "US");
const Locale FRENSH_LOCAL = Locale("fr", "FR");

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.ARABIC:
        return ARABIC;
      case LanguageType.FRENSH:
        return FRENSH;
    }
  }
}
