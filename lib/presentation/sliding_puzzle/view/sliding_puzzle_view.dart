import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/presentation/common/counter_widget.dart';
import 'package:puzzle_mvvm/presentation/common/modifing_buttons_widget.dart';
import 'package:puzzle_mvvm/presentation/common/puzzle_floating_action_button.dart';
import 'package:puzzle_mvvm/presentation/common/puzzle_header_decoration_widget.dart';
import 'package:puzzle_mvvm/presentation/resources/assets_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/strings_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/values_manager.dart';
import 'package:puzzle_mvvm/presentation/sliding_puzzle/view/sliding_puzzle_body.dart';
import 'package:puzzle_mvvm/presentation/sliding_puzzle/view_model/sliding_puzzle_viewmodel.dart';

import '../../resources/languages_manager.dart';

class SlidingPuzzleView extends StatefulWidget {
  const SlidingPuzzleView({Key? key, required this.fileName}) : super(key: key);
  final String fileName;

  @override
  State<SlidingPuzzleView> createState() => _SlidingPuzzleViewState();
}

class _SlidingPuzzleViewState extends State<SlidingPuzzleView> {
  final SlidingPuzzleViewModel _viewModel = instance<SlidingPuzzleViewModel>();
  // GlobalKey<_SlidePuzzleBodyState> globalKey = GlobalKey();
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
      backgroundColor: ColorsManager.lightOrange,
      floatingActionButtonLocation: context.locale == ARABIC_LOCAL
          ? FloatingActionButtonLocation.endFloat
          : FloatingActionButtonLocation.startFloat,
      floatingActionButton: getPuzzleFloatingActionButton(context),
      body: _getContentWidget(size),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Widget _getContentWidget(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getHeaderWidget(
          size,
          StringsManager.vasY.tr(),
          ImageAssets.slidingPuzzleDecoration,
        ),
        Expanded(
          child: Container(
            // margin: const EdgeInsets.only(top: AppMargin.m8),
            // padding: const EdgeInsets.only(left: AppPadding.p8),
            decoration: BoxDecoration(
                color: ColorsManager.lightWhite,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSize.s50),
                    topRight: Radius.circular(AppSize.s50))),
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: size.width - AppSize.s20,
                    width: size.width - AppSize.s20,
                    //SSSSSSSSSAAAAAAAAMMMMMEEEEEHHHHHHH : kana fama LayoutBuilder
                    child: StreamBuilder<bool>(
                        stream: _viewModel.outputBeginning,
                        builder: (context, isStarted) {
                          return StreamBuilder<int>(
                              stream: _viewModel.outputLevel,
                              builder: (context, level) {
                                return SlidePuzzleBody(
                                  name: widget.fileName,
                                  // key: globalKey,
                                  size: Size(size.width - AppSize.s20,
                                      size.width - AppSize.s20),
                                  // set size puzzle
                                  sizePuzzle: level.data,
                                  imageBckGround: Image(
                                    image: FileImage(File(
                                        "${_viewModel.directory.path}/${widget.fileName}.png")),
                                  ),
                                  start: isStarted.data ?? false,
                                );
                              });
                        }),
                  ),
                ),
                getCounterWidget(_viewModel, size),
                getButtonsWidget(_viewModel),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SlideObject {
  // setup offset for default / current position
  Offset? posDefault;
  Offset? posCurrent;
  // setup index for default / current position
  int? indexDefault;
  int? indexCurrent;
  // status box is empty
  bool empty;
  // size each box
  Size? size;
  // Image field for crop later
  Image? image;

  SlideObject({
    this.empty = false,
    this.image,
    this.indexCurrent,
    this.indexDefault,
    this.posCurrent,
    this.posDefault,
    this.size,
  });
}
