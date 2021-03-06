import 'dart:io';

/// Bundles different elapsed times
class ObjectDetectionStats {
  /// Total time taken in the isolate where the inference runs
  int totalPredictTime;

  /// [totalPredictTime] + communication overhead time
  /// between main isolate and another isolate
  int totalElapsedTime;

  /// Time for which inference runs
  int inferenceTime;

  /// Time taken to pre-process the image
  int preProcessingTime;

  ObjectDetectionStats({
    required this.totalPredictTime,
    required this.totalElapsedTime,
    required this.inferenceTime,
    required this.preProcessingTime,
  });

  @override
  String toString() {
    return 'Stats{totalPredictTime: $totalPredictTime, totalElapsedTime: $totalElapsedTime, inferenceTime: $inferenceTime, preProcessingTime: $preProcessingTime}';
  }
}

class PredictionProps {
  int index;
  Directory tempPath;
  String videoPath;
  int interpreterAddress;
  List<String> labels;
  PredictionProps(this.index, this.tempPath, this.videoPath,
      this.interpreterAddress, this.labels);
}

class PredictionResult {
  final List<String> label;
  final File image;
  PredictionResult(this.label, this.image);
}
