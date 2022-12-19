import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/app/app_prefs.dart';
import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/presentation/resources/routes_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void didChangeDependencies() {
    _appPreferences.getLocale().then((local) => context.setLocale(local));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashRoute,
      onGenerateRoute: RouteGenerator.getRoute,
      theme: getApplicationTheme(),
    );
  }
}
