// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/presentation/add_puzzle/view_model/add_puzzle_viewmodel.dart';
import 'package:puzzle_mvvm/presentation/common/text_with_border.dart';
import 'package:puzzle_mvvm/presentation/resources/assets_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/languages_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/routes_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/strings_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/values_manager.dart';
import 'package:record/record.dart';

class AddPuzzleView extends StatefulWidget {
  const AddPuzzleView({Key? key}) : super(key: key);

  @override
  State<AddPuzzleView> createState() => _AddPuzzleViewState();
}

class _AddPuzzleViewState extends State<AddPuzzleView> {
  final AddPuzzleViewModel _viewModel = instance<AddPuzzleViewModel>();
  final TextEditingController _titleController = TextEditingController();
  _bind() {
    _viewModel.start();
    _viewModel.outputSavedPuzzle.listen((event) {
      if (event == true) {
        Navigator.of(context).pushReplacementNamed(Routes.homeRoute);
      }
    });
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
      appBar: _getAppBar(),
      body: _getContentWidget(size),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  //private functions

  AppBar _getAppBar() {
    return AppBar(
      title: Text(
        StringsManager.back.tr(),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      leading: _getBackButton(),
      actions: [
        _getSaveButton(),
      ],
    );
  }

  Widget _getBackButton() {
    return StreamBuilder<bool?>(
        stream: _viewModel.outputIsTitleSet,
        builder: (context, snapshot) {
          return IconButton(
            icon: Transform.rotate(
                angle: context.locale == ARABIC_LOCAL ? pi : 0,
                child: SvgPicture.asset(ImageAssets.appBarIcon)),
            onPressed: () => (snapshot.hasData && snapshot.data == true)
                ? _viewModel.inputIsTitleSet.add(false)
                : Navigator.of(context).pushReplacementNamed(Routes.homeRoute),
          );
        });
  }

  Widget _getSaveButton() {
    return StreamBuilder<CroppedFile?>(
        stream: _viewModel.outputCroppedFile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return IconButton(
                onPressed: () async {
                  await _viewModel.save();
                  Navigator.of(context).pushReplacementNamed(Routes.homeRoute);
                },
                icon: SvgPicture.asset(ImageAssets.inputValidationButton));
          } else {
            return const SizedBox();
          }
        });
  }

  Widget _getContentWidget(Size size) {
    return SingleChildScrollView(
      child: SizedBox(
        height: size.height -
            _getAppBar().preferredSize.height -
            MediaQuery.of(context).padding.top,
        width: size.width,
        child: StreamBuilder<bool?>(
            stream: _viewModel.outputIsTitleSet,
            builder: (context, snapshot) {
              final bool isTitleSet = snapshot.data ?? false;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _getTextDecoration(size.width, isTitleSet),
                  isTitleSet
                      ? _getPuzzleBodyInputWidget(size.width)
                      : _getTextInputWidget(),
                  _getImageDecoration(size.width, isTitleSet),
                ],
              );
            }),
      ),
    );
  }

  Widget _getTextDecoration(double width, bool isTitleSet) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: width / 30, top: isTitleSet ? width / 8 : width / 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          textWithBorder(
              title: isTitleSet
                  ? StringsManager.nowPick.tr()
                  : StringsManager.timeToCreate.tr(),
              textStyle: Theme.of(context).textTheme.bodyMedium,
              borderColor: ColorsManager.mediumBodyTextBorderColor,
              borderWidth: ConstantsManager.borderWidth),
          textWithBorder(
              title: isTitleSet
                  ? StringsManager.picture.tr()
                  : StringsManager.yourPuzzle.tr(),
              textStyle: Theme.of(context).textTheme.bodyLarge,
              borderColor: ColorsManager.largeBodyTextBorderColor,
              borderWidth: ConstantsManager.borderWidth),
          if (!isTitleSet)
            textWithBorder(
                title: StringsManager.personnalised.tr(),
                textStyle: Theme.of(context).textTheme.bodyMedium,
                borderColor: ColorsManager.mediumBodyTextBorderColor,
                borderWidth: ConstantsManager.borderWidth),
        ],
      ),
    );
  }

  Widget _getImageDecoration(double width, bool isTitleSet) {
    return Expanded(
      child: SizedBox(
        width: width,
        child: Image.asset(
          isTitleSet
              ? ImageAssets.image_pick_decoration
              : ImageAssets.addPuzzleDecoration,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _getTextInputWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: AppSize.s0,
        color:
            ColorsManager.largeBodyTextBorderColor.withOpacity(AppOpacity.o53),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s40)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p8, vertical: AppPadding.p12),
          child: StreamBuilder<bool?>(
              stream: _viewModel.outputTitle,
              builder: (context, snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppPadding.p18),
                      child: Text(
                        StringsManager.startWithName.tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                          maxHeight: AppSize.s60, minHeight: AppSize.s40),
                      child: TextFormField(
                        controller: _titleController,
                        onChanged: (text) {
                          _viewModel.setTitle(text);
                        },
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(AppSize.s10),
                              ),
                            ),
                            fillColor:
                                ColorsManager.white.withOpacity(AppOpacity.o73),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppSize.s12),
                                borderSide: BorderSide.none),
                            filled: true,
                            hintText: StringsManager.tapper.tr(),
                            hintStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            errorText: (snapshot.data ?? true)
                                ? null
                                : StringsManager.titleError.tr(),
                            errorStyle: Theme.of(context).textTheme.labelSmall),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              right: AppPadding.p16, top: AppPadding.p8),
                          child: IconButton(
                              onPressed: (snapshot.data ?? false)
                                  ? () {
                                      _viewModel.inputIsTitleSet.add(true);
                                    }
                                  : null,
                              icon: SvgPicture.asset(
                                  ImageAssets.inputValidationButton)),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _getPuzzleBodyInputWidget(double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
      child: Column(
        children: [
          _getImagePicker(),
          SizedBox(height: width / 16),
          textWithBorder(
              title: StringsManager.recordVoice.tr(),
              textStyle: Theme.of(context).textTheme.bodyMedium,
              borderColor: ColorsManager.mediumBodyTextBorderColor,
              borderWidth: ConstantsManager.borderWidth),
          _getVoicePicker(),
        ],
      ),
    );
  }

  Widget _getImagePicker() {
    return GestureDetector(
      onTap: () {
        _viewModel.pickImage();
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color:
            ColorsManager.largeBodyTextBorderColor.withOpacity(AppOpacity.o53),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s40)),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p12),
            child: Center(
              child: Text(
                StringsManager.fromGallerie.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )),
      ),
    );
  }

  Widget _getVoicePicker() {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: AppSize.s0,
      color: ColorsManager.largeBodyTextBorderColor.withOpacity(AppOpacity.o53),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s33)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p20, vertical: AppPadding.p12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
                clipBehavior: Clip.antiAlias,
                elevation: AppSize.s0,
                color: ColorsManager.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.s40)),
                child: StreamBuilder<List<Amplitude>>(
                  stream: _viewModel.outputAmplitude,
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      return SizedBox(
                        height: AppSize.s35,
                        width: AppSize.s300,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (Amplitude wave in snapShot.data!)
                                Row(
                                  children: [
                                    Container(
                                      height: _getWaveWidgetHeight(wave),
                                      width: AppSize.s2,
                                      color: ColorsManager.redAccent,
                                    ),
                                    Container(
                                      width: AppSize.s0_5,
                                      color: ColorsManager.white,
                                    ),
                                  ],
                                )
                            ]),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _getVoiceButton(Icons.mic, () => _viewModel.recordAudio()),
                    _getVoiceButton(
                        Icons.stop, () => _viewModel.stopRecordAudio()),
                  ],
                ),
                StreamBuilder<bool>(
                    stream: _viewModel.outputIsAudioRecording,
                    builder: (context, snapshot) {
                      return _getVoiceButton(
                        Icons.play_arrow,
                        snapshot.data ?? true
                            ? null
                            : () => _viewModel.playAudio(),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _getWaveWidgetHeight(Amplitude wave) {
    double height = 0;
    height = 35 - (wave.max.abs() - wave.current.abs()).abs() / 60 * 35;
    if (height < 35) {
      return height;
    } else {
      return 35;
    }
  }

  Widget _getVoiceButton(IconData icon, void Function()? onPressed) {
    return IconButton(
      padding: const EdgeInsets.all(AppPadding.p2),
      onPressed: onPressed,
      icon: CircleAvatar(
        backgroundColor: ColorsManager.redAccent,
        radius: AppSize.s16,
        child: CircleAvatar(
          radius: AppSize.s15,
          backgroundColor: ColorsManager.white,
          child: Icon(
            icon,
            color: ColorsManager.redAccent,
          ),
        ),
      ),
    );
  }
}
