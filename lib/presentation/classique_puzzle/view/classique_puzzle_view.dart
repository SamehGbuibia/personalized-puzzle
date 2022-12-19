import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/presentation/classique_puzzle/view/classique_puzzle_body.dart';
import 'package:puzzle_mvvm/presentation/classique_puzzle/view_model/classique_puzzle_viewmodel.dart';
import 'package:puzzle_mvvm/presentation/common/counter_widget.dart';
import 'package:puzzle_mvvm/presentation/common/modifing_buttons_widget.dart';
import 'package:puzzle_mvvm/presentation/common/puzzle_floating_action_button.dart';
import 'package:puzzle_mvvm/presentation/common/puzzle_header_decoration_widget.dart';
import 'package:puzzle_mvvm/presentation/common/wining_festival_widget.dart';
import 'package:puzzle_mvvm/presentation/resources/assets_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/languages_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/strings_manager.dart';

class ClassiquePuzzleView extends StatefulWidget {
  const ClassiquePuzzleView({Key? key, required this.fileName})
      : super(key: key);
  final String fileName;
  @override
  State<ClassiquePuzzleView> createState() => _ClassiquePuzzleViewState();
}

class _ClassiquePuzzleViewState extends State<ClassiquePuzzleView> {
  final ClassiquePuzzleViewModel _viewModel =
      instance<ClassiquePuzzleViewModel>();
  _bind() {
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  final ConfettiController controller = ConfettiController();
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

  //private functions

  Widget _getContentWidget(Size size) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getHeaderWidget(
              size,
              StringsManager.cEstParti.tr(),
              ImageAssets.classiquePuzzleDecoration,
            ),
            _getPuzzleWidget(),
          ],
        ),
        getCounterWidget(_viewModel, size),
        getButtonsWidget(_viewModel),
      ],
    );
  }

  Widget _getPuzzleWidget() {
    return Expanded(
      child: StreamBuilder<bool>(
          stream: _viewModel.outputBeginning,
          builder: (context, snapshot1) {
            return StreamBuilder<int>(
                stream: _viewModel.outputLevel,
                builder: (context, snapshot2) {
                  return ClassiquePuzzleBody(
                    path: '${_viewModel.directory.path}/${widget.fileName}.png',
                    active: snapshot1.data,
                    onFinished: () async {
                      await _viewModel.setGameFinish(widget.fileName);
                      controller.play();
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Scaffold(
                                backgroundColor: ColorsManager.lighBlack,
                                body: festival(context, controller));
                          }).then((value) => _viewModel.startCounter());
                    },
                    valueSlider: snapshot2.data ?? ConstantsManager.valueSlider,
                  );
                });
          }),
    );
  }
}
