import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/presentation/common/text_with_border.dart';
import 'package:puzzle_mvvm/presentation/home/view_model/home_viewmodel.dart';
import 'package:puzzle_mvvm/presentation/resources/assets_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/fonts_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/languages_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/routes_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/strings_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/styles_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/values_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _viewModel = instance<HomeViewModel>();
  _bind() {
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorsManager.lightPrimary,
      body: _getContentWidget(size),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  //private functions

  Widget _getContentWidget(Size size) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  width: size.width * 0.45,
                  ImageAssets.mainDecoration,
                  fit: BoxFit.contain,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: textWithBorder(
                      title: StringsManager.choisit.tr(),
                      textStyle: getRegularStyle(
                          fontFamily: FontsConstants.mudir,
                          fontSize: 40,
                          color: ColorsManager.lightOrange),
                      borderColor: ColorsManager.orange,
                      borderWidth: ConstantsManager.borderWidth),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: AppMargin.m8),
          padding: const EdgeInsets.only(left: AppPadding.p8),
          width: size.width,
          height: size.height * 0.75,
          decoration: BoxDecoration(
              color: ColorsManager.orange,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSize.s50),
                  topRight: Radius.circular(AppSize.s50))),
          child: StreamBuilder<List<String>>(
              stream: _viewModel.outputpuzzleList,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: ColorsManager.lightPrimary,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: AppPadding.p12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: size.height * 0.3,
                          width: size.width,
                          child: _getLevelsWidget(
                            StringsManager.puzzleClassique.tr(),
                            size.width * 0.75,
                            size.height * 0.3,
                            snapshot.data ?? [],
                          )),
                      SizedBox(
                        height: size.height * 0.3,
                        width: size.width,
                        child: _getLevelsWidget(
                          StringsManager.puzzleCoulissant.tr(),
                          size.width * 0.75,
                          size.height * 0.3,
                          snapshot.data ?? [],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        )
      ],
    ));
  }

  Widget _getLevelsWidget(
      String title, double width, double height, List<String> names) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: AppPadding.p8),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (context.locale != ARABIC_LOCAL)
          const SizedBox(
            height: AppSize.s10,
          ),
        Expanded(
          child: names.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: AppPadding.p15),
                  child: _getAddLevelCard(width, height),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(right: AppPadding.p15),
                  scrollDirection: Axis.horizontal,
                  itemCount: names.length + 1,
                  itemBuilder: (context, index) {
                    return index < names.length
                        ? _getLevelCard(width, height, title, names[index])
                        : _getAddLevelCard(width, height);
                  }),
        ),
      ],
    );
  }

  Widget _getLevelCard(double width, double height, String title, String name) {
    String puzzleTitle = "";
    final int virgulIndex = name.indexOf(',');
    if (virgulIndex != -1) {
      puzzleTitle = name.substring(0, virgulIndex);
    }
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(
              context,
              title == StringsManager.puzzleCoulissant.tr()
                  ? Routes.slidingPuzzleRoute
                  : Routes.classiquePuzzleRoute,
              arguments: name);
        },
        child: _getCard(
          width,
          height,
          puzzleTitle,
          Image.file(
            File("${_viewModel.directory.path}/$name.png"),
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget _getAddLevelCard(double width, double height) {
    return GestureDetector(
        onTap: () =>
            Navigator.pushReplacementNamed(context, Routes.addPuzzleRoute),
        child: _getCard(
            width,
            height,
            StringsManager.addPuzzle.tr(),
            Center(
                child: SizedBox(
                    height: width / 3,
                    width: width / 3,
                    child: SvgPicture.asset(ImageAssets.add_icon)))));
  }

  Widget _getCard(double width, double height, String title, Widget content) {
    return Card(
      elevation: AppSize.s2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s25),
      ),
      child: Column(
        children: [
          SizedBox(
            height: height - AppSize.s67,
            width: width,
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSize.s25),
                  topRight: Radius.circular(AppSize.s25),
                ),
                child: content),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppSize.s25),
                bottomRight: Radius.circular(AppSize.s25),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p3, horizontal: AppPadding.p25),
                color: ColorsManager.white,
                alignment: Alignment.topLeft,
                child:
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
