import 'dart:async';
import 'dart:io';

import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/domain/repositry/repositry.dart';
import 'package:puzzle_mvvm/presentation/base/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInputs, HomeViewModelOutputs {
  final StreamController _puzzleListStreamController =
      BehaviorSubject<List<String>>();
  final Repository _repository = instance<Repository>();
  final Directory directory = instance<Directory>();
  @override
  void start() async {
    getData();
  }

  @override
  void dispose() {
    _puzzleListStreamController.close();
  }

  //inputs
  @override
  getData() async {
    List<String?> responseData = _repository.getData();
    if (responseData == []) {
      await _repository.initialData();
      responseData = _repository.getData();
    }
    List<String> listPuzzle =
        responseData.where((e) => e != null).map((e) => e ?? "").toList();
    inputpuzzleList.add(listPuzzle);
  }

  @override
  Sink get inputpuzzleList => _puzzleListStreamController.sink;

  //outputs
  @override
  Stream<List<String>> get outputpuzzleList =>
      _puzzleListStreamController.stream.map((list) => list);
}

abstract class HomeViewModelInputs {
  Sink get inputpuzzleList;
  getData();
}

abstract class HomeViewModelOutputs {
  Stream<List<String>> get outputpuzzleList;
}
