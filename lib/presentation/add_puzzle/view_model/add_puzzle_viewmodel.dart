// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puzzle_mvvm/app/di.dart';
import 'package:puzzle_mvvm/domain/repositry/repositry.dart';
import 'package:puzzle_mvvm/presentation/base/base_view_model.dart';
import 'package:puzzle_mvvm/presentation/resources/constants_manager.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';

class AddPuzzleViewModel extends BaseViewModel
    with AddPuzzleViewModelInputs, AddPuzzleViewModelOutputs {
  final StreamController _titleStreamController = BehaviorSubject<String>();
  final StreamController _isTitleSetStreamController = BehaviorSubject<bool>();
  final _pickedFileStreamController = BehaviorSubject<XFile?>();
  final _croppedFileStreamController = BehaviorSubject<CroppedFile?>();
  final StreamController _savedPuzzleStreamController =
      BehaviorSubject<bool?>();
  final StreamController _isAudioRecordingStreamController =
      BehaviorSubject<bool>();
  final StreamController _amplitudeStreamController =
      BehaviorSubject<List<Amplitude>>();

  final Repository _repository = instance<Repository>();
  final Directory directory = instance<Directory>();
  final record = Record();
  String filePath = '';
  String fileName = '';
  AudioPlayer audioPlayers = AudioPlayer();
  List<Amplitude> _waves = [];
  bool isAudioReady = false;
  //base functions
  @override
  void start() {
    inputIsAudioRecording.add(true);
    record.onAmplitudeChanged(const Duration(milliseconds: 300)).listen((amp) {
      if (_waves.length > ConstantsManager.wavesMaxLength) {
        _waves.removeAt(0);
      }
      if (amp.current != -double.infinity) {
        _waves.add(amp);
      }
      inputAmplitude.add(_waves);
    });
  }

  @override
  void dispose() {
    _titleStreamController.close();
    _isTitleSetStreamController.close();
    _pickedFileStreamController.close();
    _croppedFileStreamController.close();
    _savedPuzzleStreamController.close();
    _isAudioRecordingStreamController.close();
    _amplitudeStreamController.close();
    record.dispose();
    filePath = '';
    audioPlayers.dispose();
  }

  //inputs
  @override
  Sink get inputCroppedFile => _croppedFileStreamController.sink;

  @override
  Sink get inputPickedFile => _pickedFileStreamController.sink;

  @override
  Sink get inputSavedPuzzle => _savedPuzzleStreamController.sink;

  @override
  Sink get inputTitle => _titleStreamController.sink;

  @override
  Sink get inputIsAudioRecording => _isAudioRecordingStreamController.sink;

  @override
  Sink get inputIsTitleSet => _isTitleSetStreamController.sink;

  @override
  Sink get inputAmplitude => _amplitudeStreamController.sink;

  @override
  setTitle(String title) {
    inputTitle.add(title);
    if (_isTitleValid(title)) {
      final date = DateTime.now();
      fileName =
          '$title,${date.year}:${date.month}:${date.day}:${date.hour}:${date.minute}:${date.second}:${date.millisecond.toInt()}';
      filePath = '${directory.path}/$fileName';
    }
  }

  @override
  clearImage() {
    inputPickedFile.add(null);
    inputCroppedFile.add(null);
  }

  @override
  clearAudio() async {
    await record.dispose();
  }

  @override
  cropImage() async {
    XFile? pickedFile = _pickedFileStreamController.value;
    if (pickedFile != null) {
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          compressFormat: ImageCompressFormat.png,
          compressQuality: 100,
          aspectRatioPresets: [CropAspectRatioPreset.square]);
      if (croppedFile?.path != null) {
        inputCroppedFile.add(croppedFile!);
      }
    }
  }

  @override
  pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      inputPickedFile.add(pickedFile);
      cropImage();
    }
  }

  @override
  recordAudio() async {
    audioPlayers.pause();
    _waves = [];
    inputAmplitude.add(_waves);
    if (await record.hasPermission()) {
      // Start recording
      inputIsAudioRecording.add(true);
      await record.start(
        path: '$filePath.m4a',
        // encoder: AudioEncoder.aacLc, // by default
        // bitRate: 128000, // by default
        // samplingRate: 44100, // by default
      );
    }
  }

  @override
  stopRecordAudio() async {
    inputIsAudioRecording.add(false);
    record.stop();
  }

  @override
  save() async {
    inputSavedPuzzle.add(false);
    try {
      CroppedFile? croppedFile = _croppedFileStreamController.value;
      final File image = File(croppedFile!.path);
      await image.copy('$filePath.png');
      await _repository.addPuzzle(fileName);
      inputSavedPuzzle.add(true);
    } catch (_) {
      inputSavedPuzzle.add(null);
    }
  }

  @override
  playAudio() async {
    final file = File('$filePath.m4a');
    final list = file.readAsBytesSync();
    await audioPlayers.setSourceBytes(list);
    audioPlayers.resume();
  }

  //outputs
  @override
  Stream<CroppedFile?> get outputCroppedFile =>
      _croppedFileStreamController.stream.map((croppedImage) => croppedImage);

  @override
  Stream<XFile?> get outputPickedFile =>
      _pickedFileStreamController.stream.map((pickedFile) => pickedFile);

  @override
  Stream<bool?> get outputSavedPuzzle =>
      _savedPuzzleStreamController.stream.map((saved) => saved);

  @override
  Stream<bool?> get outputTitle =>
      _titleStreamController.stream.map((title) => _isTitleValid(title));

  @override
  Stream<bool?> get outputIsTitleSet =>
      _isTitleSetStreamController.stream.map((isTitleSet) => isTitleSet);

  @override
  Stream<bool> get outputIsAudioRecording =>
      _isAudioRecordingStreamController.stream
          .map((isAudioRecording) => isAudioRecording);

  @override
  Stream<List<Amplitude>> get outputAmplitude =>
      _amplitudeStreamController.stream.map((amplitude) => amplitude);

  //private functions
  bool _isTitleValid(String title) {
    for (int index = 0; index < title.length; index++) {
      if (title.substring(index, index + 1) != " ") {
        if (title.contains(',')) {
          return false;
        } else {
          return true;
        }
      }
    }
    return false;
  }
}

abstract class AddPuzzleViewModelInputs {
  Sink get inputTitle;
  Sink get inputIsTitleSet;
  Sink get inputPickedFile;
  Sink get inputCroppedFile;
  Sink get inputSavedPuzzle;
  Sink get inputIsAudioRecording;
  Sink get inputAmplitude;
  setTitle(String title);
  recordAudio();
  stopRecordAudio();
  pickImage();
  cropImage();
  clearImage();
  save();
  clearAudio();
  playAudio();
}

abstract class AddPuzzleViewModelOutputs {
  Stream<bool?> get outputTitle;
  Stream<bool?> get outputIsTitleSet;
  Stream<XFile?> get outputPickedFile;
  Stream<CroppedFile?> get outputCroppedFile;
  Stream<bool?> get outputSavedPuzzle;
  Stream<bool> get outputIsAudioRecording;
  Stream<List<Amplitude>> get outputAmplitude;
}
