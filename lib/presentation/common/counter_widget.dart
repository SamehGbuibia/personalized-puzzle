import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/presentation/classique_puzzle/view_model/classique_puzzle_viewmodel.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';

Widget getCounterWidget(ClassiquePuzzleViewModel viewModel, Size size) {
  return StreamBuilder<int?>(
    stream: viewModel.outputCounter,
    builder: (context, snapshot) {
      if (snapshot.data !=
          null /*&& snapshot.data != 0 && snapshot.data! < 4*/) {
        return Container(
          height: size.height,
          width: size.width,
          color: ColorsManager.transparent,
          child: Center(
            child: Text(
              snapshot.data!.toString(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
        );
      }
      return Container();
    },
  );
}
