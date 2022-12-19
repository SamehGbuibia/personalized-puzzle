import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puzzle_mvvm/app/app_prefs.dart';
import 'package:puzzle_mvvm/data/repository_implementer/repository_imp.dart';
import 'package:puzzle_mvvm/domain/repositry/repositry.dart';
import 'package:puzzle_mvvm/presentation/add_puzzle/view_model/add_puzzle_viewmodel.dart';
import 'package:puzzle_mvvm/presentation/classique_puzzle/view_model/classique_puzzle_viewmodel.dart';
import 'package:puzzle_mvvm/presentation/home/view_model/home_viewmodel.dart';
import 'package:puzzle_mvvm/presentation/sliding_puzzle/view_model/sliding_puzzle_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final Directory directory = await getApplicationDocumentsDirectory();

  //SharedPreferences instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  //AppPreferences instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  instance.registerSingleton<Repository>(RepositoryImplementer());

  //Directory
  instance.registerLazySingleton<Directory>(() => directory);

  instance<Repository>().initialData();
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeViewModel>()) {
    instance.registerFactory<HomeViewModel>(() => HomeViewModel());
  }
}

initClassiquePuzzleModule() {
  if (!GetIt.I.isRegistered<ClassiquePuzzleViewModel>()) {
    instance.registerFactory<ClassiquePuzzleViewModel>(
        () => ClassiquePuzzleViewModel());
  }
}

initSlidingPuzzleModule() {
  if (!GetIt.I.isRegistered<SlidingPuzzleViewModel>()) {
    instance.registerFactory<SlidingPuzzleViewModel>(
        () => SlidingPuzzleViewModel());
  }
}

initAddPuzzleModule() {
  if (!GetIt.I.isRegistered<AddPuzzleViewModel>()) {
    instance.registerFactory<AddPuzzleViewModel>(() => AddPuzzleViewModel());
  }
}
