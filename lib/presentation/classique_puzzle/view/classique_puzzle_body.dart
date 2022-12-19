import 'dart:io';

import 'package:flutter/material.dart';
import 'package:puzzle_mvvm/presentation/classique_puzzle/view/jigsaw.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';

class ClassiquePuzzleBody extends StatefulWidget {
  const ClassiquePuzzleBody(
      {Key? key,
      this.active,
      required this.onFinished,
      required this.valueSlider,
      required this.path})
      : super(key: key);
  final bool? active;
  final dynamic Function() onFinished;
  final int valueSlider;
  final String path;
  @override
  State<ClassiquePuzzleBody> createState() => _ClassiquePuzzleBodyState();
}

class _ClassiquePuzzleBodyState extends State<ClassiquePuzzleBody> {
  final puzzleKey = GlobalKey<JigsawWidgetState>();

  generate() async {
    await puzzleKey.currentState!.generate();
  }

  bool _isGenerated = false;
  @override
  void didUpdateWidget(covariant ClassiquePuzzleBody oldWidget) {
    if (widget.active == true && !_isGenerated) {
      generate();
      _isGenerated = true;
    } else if (widget.active == false) {
      puzzleKey.currentState!.reset();
      _isGenerated = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return JigsawPuzzle(
      gridSize: widget.valueSlider,
      image: FileImage(File(widget.path)),
      onFinished: widget.onFinished,
      snapSensitivity: ConstantsManager.snapSensitivity, // Between 0 and 1
      puzzleKey: puzzleKey,
      onBlockSuccess: () {},
    );
  }
}
