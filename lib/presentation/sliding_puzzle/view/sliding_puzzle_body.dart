// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages, must_be_immutable

import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/presentation/common/wining_festival_widget.dart';
import 'package:puzzle_mvvm/presentation/resources/colors_manager.dart';
import 'package:puzzle_mvvm/presentation/sliding_puzzle/view/sliding_puzzle_view.dart';
import 'package:puzzle_mvvm/presentation/sliding_puzzle/view_model/sliding_puzzle_viewmodel.dart';
import 'package:image/image.dart' as image;

class SlidePuzzleBody extends StatefulWidget {
  bool start = true;
  Size? size;
  // set inner padding
  double innerPadding;
  // set image use for background
  Image? imageBckGround;
  int? sizePuzzle;
  final String name;
  SlidePuzzleBody({
    Key? key,
    this.size,
    this.innerPadding = 5,
    this.imageBckGround,
    this.sizePuzzle,
    this.start = true,
    required this.name,
  }) : super(key: key);

  @override
  _SlidePuzzleBodyState createState() => _SlidePuzzleBodyState();
}

class _SlidePuzzleBodyState extends State<SlidePuzzleBody> {
  final GlobalKey _globalKey = GlobalKey();
  final SlidingPuzzleViewModel _viewModel = instance<SlidingPuzzleViewModel>();
  Size? size;
  // list array slide objects
  List<SlideObject>? slideObjects;
  // image load with renderer
  image.Image? fullImage;
  // success flag
  bool success = false;
  // flag already start slide
  bool startSlide = false;
  // save current swap process for reverse checking
  List<int>? process;
  // flag finish swap
  bool finishSwap = false;

  @override
  void initState() {
    // generatePuzzle();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SlidePuzzleBody oldWidget) {
    if (widget.start == true) {
      generatePuzzle();
    } else {
      // puzzleKey.currentState!.reset();
    }
    super.didUpdateWidget(oldWidget);
  }

  final controller = ConfettiController();
  @override
  Widget build(BuildContext context) {
    size = Size(widget.size!.width - widget.innerPadding * 2,
        widget.size!.width - widget.innerPadding);
    if (success) {
      //TODO kifkif
      _viewModel.setGameFinish(widget.name);
      // var s = audioPlay('${_viewModel.directory.path}/${widget.name}', true);
      // s.first;
      success = false;
      controller.play();
      WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
          context: context,
          builder: (context) {
            return festival(context, controller);
          }));
    }
    return Container(
      decoration: BoxDecoration(
          color: ColorsManager.lightWhite,
          border: Border.all(width: 1, color: ColorsManager.primary)),
      width: widget.size!.width,
      height: widget.size!.width,
      padding: EdgeInsets.all(widget.innerPadding),
      child: Stack(
        children: [
          // we use stack stack our background & puzzle box
          // 1st show image use

          if (widget.imageBckGround != null && slideObjects == null) ...[
            RepaintBoundary(
              key: _globalKey,
              child: SizedBox(
                height: double.maxFinite,
                child: widget.imageBckGround,
              ),
            )
          ],
          // 2nd show puzzle with empty
          if (slideObjects != null)
            ...slideObjects!.where((slideObject) => slideObject.empty).map(
              (slideObject) {
                return Positioned(
                  left: slideObject.posCurrent!.dx,
                  top: slideObject.posCurrent!.dy,
                  child: SizedBox(
                    width: slideObject.size!.width,
                    height: slideObject.size!.height,
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(2),
                      color: Colors.white24,
                      child: Stack(
                        children: [
                          if (slideObject.image != null) ...[
                            Opacity(
                              opacity: success ? 1 : 0.3,
                              child: slideObject.image,
                            )
                          ]
                        ],
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          // this for box with not empty flag
          if (slideObjects != null)
            ...slideObjects!.where((slideObject) => !slideObject.empty).map(
              (slideObject) {
                // change to animated position
                // disabled checking success on swap process
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.ease,
                  left: slideObject.posCurrent!.dx,
                  top: slideObject.posCurrent!.dy,
                  child: GestureDetector(
                    onTap: () => changePos(slideObject.indexCurrent!),
                    child: SizedBox(
                      width: slideObject.size!.width,
                      height: slideObject.size!.height,
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(2),
                        color: Colors.blue,
                        child: Stack(
                          children: [
                            if (slideObject.image != null) ...[
                              slideObject.image!
                            ],
                            Center(
                              //TODO bch nsal7 TextWidget
                              child: Text("${slideObject.indexDefault}"),
                              // child: TextWidget(
                              //   "${slideObject.indexDefault}",
                              //   color: Color(0xff225f87),
                              //   strokeColor: Colors.white,
                              //   strokeWidth: 8,
                              //   fontFamily: "KidZone",
                              //   fontSize: 40,
                              //   overrideSizeStroke: false,
                              // ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
        ],
      ),
    );
  }

  _getImageFromWidget() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    size = boundary.size;
    var img = await boundary.toImage();
    var byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();

    return image.decodeImage(pngBytes);
  }

  generatePuzzle() async {
    finishSwap = false;
    setState(() {});
    if (widget.imageBckGround != null && fullImage == null) {
      fullImage = await _getImageFromWidget();
    }

    Size sizeBox = Size(
        size!.width / widget.sizePuzzle!, size!.width / widget.sizePuzzle!);
    slideObjects =
        List.generate(widget.sizePuzzle! * widget.sizePuzzle!, (index) {
      Offset offsetTemp = Offset(
        index % widget.sizePuzzle! * sizeBox.width,
        index ~/ widget.sizePuzzle! * sizeBox.height,
      );
      image.Image? tempCrop;
      if (widget.imageBckGround != null && fullImage != null) {
        tempCrop = image.copyCrop(
          fullImage!,
          offsetTemp.dx.round(),
          offsetTemp.dy.round(),
          sizeBox.width.round(),
          sizeBox.height.round(),
        );
      }

      return SlideObject(
        posCurrent: offsetTemp,
        posDefault: offsetTemp,
        indexCurrent: index,
        indexDefault: index + 1,
        size: sizeBox,
        image: tempCrop == null
            ? null
            : Image.memory(
                Uint8List.fromList(image.encodePng(tempCrop)),
                fit: BoxFit.contain,
              ),
      );
    });

    slideObjects!.last.empty = true;
    bool swap = true;
    process = [];

    // 20 * size puzzle shuffle
    for (var i = 0; i < widget.sizePuzzle! * 20; i++) {
      for (var j = 0; j < widget.sizePuzzle! / 2; j++) {
        SlideObject slideObjectEmpty = getEmptyObject();

        // get index of empty slide object
        int emptyIndex = slideObjectEmpty.indexCurrent!;
        process!.add(emptyIndex);
        int randKey;

        if (swap) {
          // horizontal swap
          int row = emptyIndex ~/ widget.sizePuzzle!;
          randKey =
              row * widget.sizePuzzle! + Random().nextInt(widget.sizePuzzle!);
        } else {
          int col = emptyIndex % widget.sizePuzzle!;
          randKey =
              widget.sizePuzzle! * Random().nextInt(widget.sizePuzzle!) + col;
        }

        // call change pos method we create before to swap place

        changePos(randKey);
        // ops forgot to swap
        // hmm bug.. :).. let move 1st with click..check whther bug on swap or change pos
        swap = !swap;
      }
    }

    startSlide = false;
    finishSwap = true;
    setState(() {});
  }
  // eyay.. end

  // get empty slide object from list
  SlideObject getEmptyObject() {
    return slideObjects!.firstWhere((element) => element.empty);
  }

  changePos(int indexCurrent) {
    // problem here i think..
    SlideObject slideObjectEmpty = getEmptyObject();

    // get index of empty slide object
    int emptyIndex = slideObjectEmpty.indexCurrent!;

    // min & max index based on vertical or horizontal

    int minIndex = min(indexCurrent, emptyIndex);
    int maxIndex = max(indexCurrent, emptyIndex);

    // temp list moves involves
    List<SlideObject> rangeMoves = [];

    // check if index current from vertical / horizontal line
    if (indexCurrent % widget.sizePuzzle! == emptyIndex % widget.sizePuzzle!) {
      // same vertical line
      rangeMoves = slideObjects!
          .where((element) =>
              element.indexCurrent! % widget.sizePuzzle! ==
              indexCurrent % widget.sizePuzzle!)
          .toList();
    } else if (indexCurrent ~/ widget.sizePuzzle! ==
        emptyIndex ~/ widget.sizePuzzle!) {
      rangeMoves = slideObjects!;
    } else {
      rangeMoves = [];
    }

    rangeMoves = rangeMoves
        .where((puzzle) =>
            puzzle.indexCurrent! >= minIndex &&
            puzzle.indexCurrent! <= maxIndex &&
            puzzle.indexCurrent! != emptyIndex)
        .toList();

    // check empty index under or above current touch
    if (emptyIndex < indexCurrent) {
      rangeMoves.sort((a, b) => a.indexCurrent! < b.indexCurrent! ? 1 : 0);
    } else {
      rangeMoves.sort((a, b) => a.indexCurrent! < b.indexCurrent! ? 0 : 1);
    }

    // check if rangeMOves is exist,, then proceed switch position
    if (rangeMoves.isNotEmpty) {
      int tempIndex = rangeMoves[0].indexCurrent!;

      Offset tempPos = rangeMoves[0].posCurrent!;

      // yeayy.. sorry my mistake.. :)
      for (var i = 0; i < rangeMoves.length - 1; i++) {
        rangeMoves[i].indexCurrent = rangeMoves[i + 1].indexCurrent;
        rangeMoves[i].posCurrent = rangeMoves[i + 1].posCurrent;
      }

      rangeMoves.last.indexCurrent = slideObjectEmpty.indexCurrent;
      rangeMoves.last.posCurrent = slideObjectEmpty.posCurrent;

      // haha ..i forget to setup pos for empty puzzle box.. :p
      slideObjectEmpty.indexCurrent = tempIndex;
      slideObjectEmpty.posCurrent = tempPos;
    }

    // this to check if all puzzle box already in default place.. can set callback for success later
    if (slideObjects!
                .where((slideObject) =>
                    slideObject.indexCurrent == slideObject.indexDefault! - 1)
                .length ==
            slideObjects!.length &&
        finishSwap) {
      //audioPlay(path)
      success = true;
    } else {
      success = false;
    }

    startSlide = true;
    setState(() {});
  }

  clearPuzzle() {
    setState(() {
      // checking already slide for reverse purpose
      startSlide = true;
      slideObjects = null;
      finishSwap = true;
    });
  }

  reversePuzzle() async {
    startSlide = true;
    finishSwap = true;
    setState(() {});

    await Stream.fromIterable(process!.reversed)
        .asyncMap((event) async =>
            await Future.delayed(const Duration(milliseconds: 50))
                .then((value) => changePos(event)))
        .toList();

    // yeayy
    process = [];
    setState(() {});
  }
}
