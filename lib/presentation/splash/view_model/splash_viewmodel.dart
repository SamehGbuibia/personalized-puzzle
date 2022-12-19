import 'dart:async';

import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/presentation/base/base_view_model.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/values_manager.dart';
import 'package:rxdart/rxdart.dart';

class SplashViewModel extends BaseViewModel
    with SplashViewModelInputs, SplashViewModelOutputs {
  final StreamController _opacityStreamController = BehaviorSubject<double>();
  final StreamController _boyTransformationController = BehaviorSubject<Size>();
  final StreamController _boySizeStreamController = BehaviorSubject<Size>();

  @override
  void start() {}

  @override
  void dispose() {
    _boySizeStreamController.close();
    _boyTransformationController.close();
    _opacityStreamController.close();
  }

  //inputs
  @override
  Sink get inputBoySize => _boySizeStreamController.sink;

  @override
  Sink get inputBoyTransformation => _boyTransformationController.sink;

  @override
  Sink get inputOpacity => _opacityStreamController.sink;

  @override
  animation(Size size) async {
    double heightKid = AppSize.s0;
    double widthKid = AppSize.s0;
    double xKid = AppSize.s0;
    double yKid = AppSize.s0;
    double opacity = AppSize.s0;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      opacity = AppSize.s1;
      heightKid = size.height * AppSize.s0_5;
      widthKid = size.width * AppSize.s0_8;
      inputBoySize.add(Size(widthKid, heightKid));
      await Future.delayed(
          const Duration(seconds: ConstantsManager.splashAnimationDelay));
      inputOpacity.add(opacity);
      xKid = AppSize.s0_2;
      yKid = -AppSize.s0_1;
      inputBoyTransformation.add(Size(xKid, yKid));
      await Future.delayed(
          const Duration(seconds: ConstantsManager.splashAnimationDelay));
      xKid = AppSize.s0;
      yKid = AppSize.s0;
      inputBoyTransformation.add(Size(xKid, yKid));
    } catch (_) {}
  }

  //outputs
  @override
  Stream<Size> get outputBoySize =>
      _boySizeStreamController.stream.map((size) => size);

  @override
  Stream<Size> get outputBoyTransformation =>
      _boyTransformationController.stream
          .map((transformation) => transformation);

  @override
  Stream<double> get outputOpacity =>
      _opacityStreamController.stream.map((opacity) => opacity);
}

abstract class SplashViewModelInputs {
  Sink get inputBoyTransformation;
  Sink get inputBoySize;
  Sink get inputOpacity;
  animation(Size size);
}

abstract class SplashViewModelOutputs {
  Stream<Size> get outputBoyTransformation;
  Stream<Size> get outputBoySize;
  Stream<double> get outputOpacity;
}
