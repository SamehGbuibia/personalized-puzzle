import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jigsaw_puzzle/flutter_jigsaw_puzzle.dart';
import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/presentation/base/base_view_model.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';
import 'package:rxdart/rxdart.dart';

class ClassiquePuzzleViewModel extends BaseViewModel
    with ClassiquePuzzleViewModelInputs, ClassiquePuzzleViewModelOutputs {
  final StreamController _counterStreamController = BehaviorSubject<int?>();
  final StreamController _winingStreamController = BehaviorSubject<bool>();
  final StreamController _levelStreamController = BehaviorSubject<int>();
  final StreamController _beginningStreamController = BehaviorSubject<bool>();
  final StreamController _changingLevelStreamController =
      BehaviorSubject<bool>();
  final puzzleKey = GlobalKey<JigsawWidgetState>();
  final Directory directory = instance<Directory>();
  Timer? _timer;
  @override
  void start() {
    inputLevel.add(ConstantsManager.valueSlider);
    startCounter();
    inputChangingLevel.add(false);
  }

  @override
  void dispose() {
    _counterStreamController.close();
    _winingStreamController.close();
    _levelStreamController.close();
    _changingLevelStreamController.close();
    _beginningStreamController.close();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Sink get inputCounter => _counterStreamController.sink;

  @override
  Sink get inputLevel => _levelStreamController.sink;

  @override
  Sink get inputWining => _winingStreamController.sink;

  @override
  Sink get inputBeginning => _beginningStreamController.sink;

  @override
  Sink get inputChangingLevel => _changingLevelStreamController.sink;

  @override
  Stream<int?> get outputCounter =>
      _counterStreamController.stream.map((counter) => counter);

  @override
  Stream<int> get outputLevel =>
      _levelStreamController.stream.map((level) => level);

  @override
  Stream<bool> get outputWining =>
      _winingStreamController.stream.map((wining) => wining);

  @override
  Stream<bool> get outputBeginning =>
      _beginningStreamController.stream.map((beginning) {
        // _generateGame();
        return beginning;
      });

  @override
  Stream<bool> get outputChangingLevel => _changingLevelStreamController.stream
      .map((isLevelChanging) => isLevelChanging);

  @override
  setGameFinish(String fileName) async {
    try {
      final file = File('${directory.path}/$fileName.m4a');
      final list = file.readAsBytesSync();
      AudioPlayer audioPlayers = AudioPlayer();
      await audioPlayers.setSourceBytes(list);
      audioPlayers.resume();
    } catch (_) {}
    inputWining.add(true);
  }

  @override
  setLevel(int level) {
    inputLevel.add(level);
    inputBeginning.add(true);
  }

  @override
  startCounter() {
    inputBeginning.add(false);
    _timer = Timer.periodic(
        const Duration(seconds: ConstantsManager.splashAnimationDelay),
        (timer) {
      if (timer.tick == 4) {
        inputBeginning.add(true);
        timer.cancel();
        inputCounter.add(null);
      } else {
        inputCounter.add(timer.tick);
      }
    });
  }
}

abstract class ClassiquePuzzleViewModelInputs {
  Sink get inputCounter;
  Sink get inputWining;
  Sink get inputLevel;
  Sink get inputBeginning;
  Sink get inputChangingLevel;
  setLevel(int level);
  setGameFinish(String fileName);
  startCounter();
}

abstract class ClassiquePuzzleViewModelOutputs {
  Stream<int?> get outputCounter;
  Stream<bool> get outputWining;
  Stream<int> get outputLevel;
  Stream<bool> get outputBeginning;
  Stream<bool> get outputChangingLevel;
}
