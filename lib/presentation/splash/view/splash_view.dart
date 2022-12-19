import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzle_mvvm/presentation/resources/assets_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/languages_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/routes_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/values_manager.dart';
import 'package:puzzle_mvvm/presentation/splash/view_model/splash_viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashViewModel _viewModel = SplashViewModel();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _viewModel.animation(size);
    return Scaffold(
        backgroundColor: ColorsManager.primary,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsManager.floatinButtonColor,
          onPressed: () {
            Navigator.pushNamed(context, Routes.languageRoute);
          },
          child: const Icon(Icons.translate),
        ),
        body: GestureDetector(
          onTap: () =>
              Navigator.of(context).pushReplacementNamed(Routes.homeRoute),
          child: _getContentWidget(size),
        ));
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  //private functions
  Widget _getContentWidget(Size size) {
    return Center(
      child: Stack(
        children: [
          _getSmilesWidget(size),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * AppSize.s0_15,
                ),
                _getSalutWidget(size),
                SizedBox(
                  height: size.height * 0.05,
                ),
                _getBoyWidget(size),
                SizedBox(
                  height: size.height * 0.05,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSmilesWidget(Size size) {
    return StreamBuilder<double>(
        stream: _viewModel.outputOpacity,
        builder: (context, snapshot) {
          double opacity = snapshot.data ?? 0;
          return AnimatedPositioned(
            duration: const Duration(
                seconds: ConstantsManager.splashTransformAnimationDelay),
            bottom: opacity * size.height,
            child: AnimatedOpacity(
              duration: const Duration(
                  milliseconds: ConstantsManager.splashOpacityAnimationDelay),
              opacity: opacity,
              child: SizedBox(
                height: size.height,
                width: size.width,
                child: Image.asset(
                  ImageAssets.smiles,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        });
  }

  Widget _getSalutWidget(Size size) {
    return StreamBuilder<double>(
        stream: _viewModel.outputOpacity,
        builder: (context, snapshot) {
          double opacity = snapshot.data ?? 0;
          return AnimatedOpacity(
            duration:
                const Duration(seconds: ConstantsManager.splashAnimationDelay),
            opacity: opacity,
            child: SizedBox(
              height: size.height / 6,
              width: size.width * 0.66,
              child: Image.asset(
                ImageAssets.salutAsser,
                fit: BoxFit.contain,
              ),
            ),
          );
        });
  }

  Widget _getBoyWidget(Size size) {
    return StreamBuilder<Size>(
        stream: _viewModel.outputBoySize,
        builder: (context, snapshot1) {
          double heightKid = 0;
          double widthKid = 0;
          if (snapshot1.data != null) {
            heightKid = snapshot1.data!.height;
            widthKid = snapshot1.data!.width;
          }
          return StreamBuilder<Size>(
              stream: _viewModel.outputBoyTransformation,
              builder: (context, snapshot2) {
                double xKid = 0;
                double yKid = 0;
                if (snapshot2.data != null) {
                  xKid = snapshot2.data!.height;
                  yKid = snapshot2.data!.width;
                }
                return AnimatedContainer(
                  duration: const Duration(
                      seconds: ConstantsManager.splashAnimationDelay),
                  height: heightKid,
                  width: widthKid,
                  alignment: Alignment(xKid, yKid),
                  child: SvgPicture.asset(ImageAssets.boy, fit: BoxFit.contain),
                );
              });
        });
  }

  LanguageType _getLangauge() {
    if (context.locale == ARABIC_LOCAL) {
      return LanguageType.ARABIC;
    } else if (context.locale == ENGLISH_LOCAL) {
      return LanguageType.ENGLISH;
    } else {
      return LanguageType.FRENSH;
    }
  }
}
