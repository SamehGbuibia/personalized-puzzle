import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/presentation/classique_puzzle/view_model/classique_puzzle_viewmodel.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/strings_manager.dart';
import 'package:puzzle_mvvm/presentation/resources/values_manager.dart';

Widget getButtonsWidget(ClassiquePuzzleViewModel viewModel) {
  return Positioned(
      bottom: AppSize.s15,
      right: AppSize.s15,
      child: StreamBuilder<bool>(
          stream: viewModel.outputChangingLevel,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container();
            } else if (snapshot.data == true) {
              return Row(
                children: [
                  StreamBuilder<int>(
                      stream: viewModel.outputLevel,
                      builder: (context, snapshot) {
                        int valueSlider = snapshot.data ?? 3;
                        return Slider(
                          min: ConstantsManager.sliderMin,
                          max: ConstantsManager.sliderMax,
                          divisions: ConstantsManager.sliderDivisions,
                          label: valueSlider.toString(),
                          value: valueSlider.toDouble(),
                          onChanged: (value) {
                            viewModel.setLevel(value.toInt());
                          },
                        );
                      }),
                  IconButton(
                      onPressed: () {
                        viewModel.inputChangingLevel.add(false);
                        viewModel.startCounter();
                      },
                      icon: Icon(
                        Icons.check,
                        color: ColorsManager.blue,
                        size: AppSize.s25,
                      ))
                ],
              );
            } else {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: ColorsManager.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s20),
                      )),
                  onPressed: () {
                    viewModel.inputChangingLevel.add(true);
                  },
                  child: Text(
                    StringsManager.difficulte.tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ));
            }
          }));
}
