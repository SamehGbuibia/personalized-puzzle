import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/app/my_app.dart';
import 'package:puzzle_mvvm/presentation/resources/languages_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  runApp(EasyLocalization(
    supportedLocales: const [ENGLISH_LOCAL, FRENSH_LOCAL, ARABIC_LOCAL],
    path: ASSET_PATH_LOCALISATIONS,
    child: Phoenix(child: MyApp()),
  ));
}
