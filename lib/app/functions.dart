import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:puzzle_mvvm/presentation/resources/languages_manager.dart';

bool isRtl(BuildContext context) {
  return context.locale == ARABIC_LOCAL;
}
