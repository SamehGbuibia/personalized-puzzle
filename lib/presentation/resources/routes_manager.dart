import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/presentation/add_puzzle/view/add_puzzle_view.dart';
import 'package:puzzle_mvvm/presentation/change_language/view/change_language_view.dart';
import 'package:puzzle_mvvm/presentation/classique_puzzle/view/classique_puzzle_view.dart';
import 'package:puzzle_mvvm/presentation/home/view/home_view.dart';
import 'package:puzzle_mvvm/presentation/resources/strings_manager.dart';
import 'package:puzzle_mvvm/presentation/setting/setting_view/setting_view.dart';
import 'package:puzzle_mvvm/presentation/sliding_puzzle/view/sliding_puzzle_view.dart';
import 'package:puzzle_mvvm/presentation/splash/view/splash_view.dart';

class Routes {
  static const String splashRoute = "/";
  static const String homeRoute = "/home";
  static const String slidingPuzzleRoute = "/slidingPuzzle";
  static const String classiquePuzzleRoute = "/classiquePuzzle";
  static const String addPuzzleRoute = "/addPuzzle";
  static const String settingRoute = "/setting";
  static const String languageRoute = "/languageRoute";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.languageRoute:
        return MaterialPageRoute(builder: (_) => ChangeLanguageView());
      case Routes.addPuzzleRoute:
        initAddPuzzleModule();
        return MaterialPageRoute(builder: (_) => const AddPuzzleView());
      case Routes.classiquePuzzleRoute:
        initClassiquePuzzleModule();
        return MaterialPageRoute(builder: (context) {
          final String fileName = routeSettings.arguments as String;
          return ClassiquePuzzleView(fileName: fileName);
        });
      case Routes.homeRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.slidingPuzzleRoute:
        initSlidingPuzzleModule();
        return MaterialPageRoute(builder: (context) {
          final String fileName = routeSettings.arguments as String;
          return SlidingPuzzleView(fileName: fileName);
        });
      case Routes.settingRoute:
        return MaterialPageRoute(builder: (_) => const SettingView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(StringsManager.noRouteFound),
              ),
              body: const Center(
                child: Text(StringsManager.noRouteFound),
              ),
            ));
  }
}
