import 'dart:io';
import 'dart:isolate';
import 'package:easy_isolate/easy_isolate.dart';

// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as image_lib;

import '../ML/ObjectDetectionClassifier.dart';
import '../ExportFrame.dart';
import '../../models/models.dart';

Future<List<PredictionResult>> predictImage(PredictionProps props) async {
  List<PredictionResult> predictions = [];
  String fileName = props.videoPath.split('/').last.split('.').first;
  if(Platform.isWindows){
    fileName = props.videoPath.split("\\").last.split('.').first;
  }
  List<File> images = await ExportVideoFrameX.getFramesFromVideoFile(
      props.videoPath,
      storagePath: props.tempPath.path,
      fileName: fileName);
  if (images.isEmpty) return [];
  for (int index = 0; index < images.length; index++) {
    File image = images[index];
    image_lib.Image? imageToSend =
        image_lib.decodeImage(image.readAsBytesSync());
    if (imageToSend == null) return [];
    var prediction = await ObjectDetectionClassifier.predict(
        imageToSend, props.interpreterAddress, props.labels);
    if (prediction != null) {
      var recog = (prediction['recognitions'] as List).isNotEmpty
          ? prediction['recognitions'] as List<Recognition>
          : null;
      if (recog != null) {
        List<Recognition> filtered =
            recog.where((element) => element.label == 'person').toList();
        if (filtered.isNotEmpty) {
          predictions
              .add(PredictionResult(recog.map((e) => e.label).toList(), image));
        }
      }
    }
  }
  if (predictions.isEmpty) {
    Directory("${props.tempPath.path}/images/$fileName")
        .deleteSync(recursive: true);
  }
  return predictions;
}

void isolateHandler(
    dynamic data, SendPort mainSendPort, SendErrorFunction sendError) async {
  if (data is List<PredictionProps>) {
    List<Future<List<PredictionResult>>> tasks = [];
    for (PredictionProps props in data) {
      mainSendPort.send(props);
      tasks.add(predictImage(props));
    }
    List<List<PredictionResult>> results = await Future.wait(tasks);
    for (List<PredictionResult> result in results) {
      mainSendPort.send(result);
    }
  }
}
