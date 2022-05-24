import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:easy_isolate/easy_isolate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as imageLib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:user_onboarding/helpers/ExportFrame.dart';
import 'package:user_onboarding/helpers/Logger/logger.dart';
import 'package:user_onboarding/helpers/ML/ObjectDetectionClassifier.dart';

class Home extends StatefulWidget {
  static const String route = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

bool isLoading = false;

Interpreter? interpreter;

class PredictionProps {
  int index;
  Directory tempPath;
  String videoPath;
  int interpreterAddress;
  List<String> labels;
  PredictionProps(this.index, this.tempPath, this.videoPath,
      this.interpreterAddress, this.labels);
}

Future<List<PredictionResult>> predictImage(PredictionProps props) async {
  List<PredictionResult> predictions = [];
  String fileName = props.videoPath.split('/').last.split('.').first;
  List<File> images = await ExportVideoFrameX.getFramesFromVideoFile(
      props.videoPath,
      storagePath: props.tempPath.path,
      fileName: fileName);
  if (images.isEmpty) return [];
  for (int index = 0; index < images.length; index++) {
    File image = images[index];
    imageLib.Image? imageToSend = imageLib.decodeImage(image.readAsBytesSync());
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

class PredictionResult {
  final List<String> label;
  final File image;
  PredictionResult(this.label, this.image);
}

class _HomeState extends State<Home> {
  Directory? rootPath;
  String? currentlyScanning;
  final worker = Worker();
  List<PredictionResult> predictions = [];
  int totalImages = 0;
  int scanning = -1;
  int batchSize = 1;
  void init() async {
    interpreter = await Interpreter.fromAsset(
      "${ObjectDetectionClassifier.ASSETS_PATH}${ObjectDetectionClassifier.MODEL_FILE_NAME}",
      options: InterpreterOptions()..threads = 4,
    );
    await worker.init(mainMessageHandler, isolateHandler,
        errorHandler: logger.e, queueMode: true);
    if (!Platform.isAndroid) {
      if (Platform.isLinux) {
        setState(() {
          rootPath = Directory('/usb');
        });
      } else {
        Directory? downloads = await getDownloadsDirectory();
        if (downloads != null) {
          setState(() {
            rootPath = Directory(downloads.parent.path);
          });
        }
      }
    }
  }

  void mainMessageHandler(dynamic data, SendPort isolateSendPort) {
    if (data is PredictionProps) {
      setState(() {
        currentlyScanning = data.videoPath;
        scanning = data.index;
      });
    } else if (data is List<PredictionResult>) {
      if (currentlyScanning != null) {
        String _file = currentlyScanning!;
        if (data.isEmpty) {
          File(_file).deleteSync(recursive: true);
        } else if (savePath.isNotEmpty) {
          //move file to new location
          File(_file)
              .copy("$savePath/${_file.split('/').last}")
              .then((value) => File(_file).deleteSync());
        }
      }
      setState(() {
        predictions.addAll(data);
        if (scanning == totalImages - 1) {
          currentlyScanning = null;
          isLoading = false;
        }
      });
    }
  }

  void predictAllImagesInDir(List<String> videos) async {
    if (videos.isEmpty) return;
    if (interpreter == null) return;
    setState(() {
      isLoading = true;
      predictions = [];
    });
    Directory tempPath = await getApplicationSupportDirectory();
    if (Directory("${tempPath.path}/images").existsSync()) {
      Directory("${tempPath.path}/images").deleteSync(recursive: true);
    }
    final List<List<PredictionProps>> tasks = [];
    List<String> labels = await FileUtil.loadLabels(
        "assets/${ObjectDetectionClassifier.ASSETS_PATH}${ObjectDetectionClassifier.LABEL_FILE_NAME}");

    setState(() {
      totalImages = videos.length;
    });
    for (int index = 0; index < videos.length; index = index + batchSize) {
      List<PredictionProps> task = [];
      for (int internalIndex = 0; internalIndex < batchSize; internalIndex++) {
        if (index + internalIndex < videos.length) {
          task.add(PredictionProps(index + internalIndex, tempPath,
              videos[index + internalIndex], interpreter!.address, labels));
        }
      }
      tasks.add(task);
    }
    try {
      for (List<PredictionProps> task in tasks) {
        worker.sendMessage(task);
      }
    } catch (e) {
      logger.e(e);
    } finally {}
  }

  final TextEditingController _pathController = TextEditingController();
  String savePath = '';
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> deleteIfEmpty(String path, bool recursion) async {
    List items = await Directory(path).list(recursive: false).toList();
    if (items
        .whereType<File>()
        .where((item) => item.path.endsWith('.mp4'))
        .isNotEmpty) return;
    if (items.whereType<Directory>().isEmpty) {
      await Directory(path).delete(recursive: true);
    } else {
      if (recursion) {
        for (Directory item in items.whereType<Directory>()) {
          await deleteIfEmpty(item.path, recursion);
        }
      }
    }
  }

  Future<void> deleteEmptyFolders(BuildContext context) async {
    String? path = await FilesystemPicker.open(
      title: 'Pick Media',
      context: context,
      rootDirectory: rootPath!,
      fsType: FilesystemType.all,
      pickText: 'Pick the video directory',
      folderIconColor: Colors.teal,
    );
    setState(() {
      isLoading = true;
    });
    if (path != null) {
      await deleteIfEmpty(path, true);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> resetWorker() async {
    if (worker.isInitialized == true) {
      worker.dispose(immediate: true);
      await worker.init(mainMessageHandler, isolateHandler,
          errorHandler: logger.e, queueMode: true);
    }
    setState(() {
      isLoading = false;
      currentlyScanning = null;
    });
  }

  //title Widget for the appbar
  Widget _title(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Tesla',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.headline1,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          children: const [
            TextSpan(
              text: 'Cam',
              style: TextStyle(color: Colors.black54, fontSize: 18),
            ),
            TextSpan(
              text: 'Cleaner',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(context),
      ),
      body: rootPath == null && !Platform.isAndroid
          ? const Text('loading')
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  if (currentlyScanning != null)
                    Text(
                        'Scanning $currentlyScanning (${scanning + 1}/$totalImages)',
                        style: const TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: _pathController,
                    decoration: const InputDecoration(
                      labelText: 'Path',
                      enabled: false,
                    ),
                    onChanged: null,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () => deleteEmptyFolders(context),
                    child: const Text(
                      'Delete Empty Folders',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(savePath),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String? path = await FilesystemPicker.open(
                        title: 'Pick Media',
                        context: context,
                        rootDirectory: rootPath!,
                        fsType: FilesystemType.all,
                        pickText: 'Pick the save directory',
                        folderIconColor: Colors.teal,
                      );
                      if (path != null) {
                        setState(() {
                          savePath = path;
                        });
                      }
                    },
                    child: const Text(
                      'Select Save Directory',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String? path = await FilesystemPicker.open(
                        title: 'Pick Media',
                        context: context,
                        rootDirectory: rootPath!,
                        fsType: FilesystemType.all,
                        pickText: 'Pick the video directory',
                        folderIconColor: Colors.teal,
                      );
                      if (path != null) {
                        setState(() {
                          _pathController.text = path;
                        });
                        List<FileSystemEntity> items =
                            Directory(path).listSync(recursive: true);
                        List<String> videos = [];
                        for (var element in items) {
                          if (element is File) {
                            if (element.path.endsWith('.mp4')) {
                              videos.add(element.path);
                            }
                          }
                        }
                        predictAllImagesInDir(videos);
                      }
                    },
                    child: const Text(
                      'Select Video Directory',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (predictions.isNotEmpty)
                    SizedBox(
                      height: 600,
                      child: SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.builder(
                                reverse: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: predictions.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    child: Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 250,
                                            child: Image.file(
                                              predictions[index].image,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          Text(predictions[index]
                                              .label
                                              .join(', ')),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (!isLoading && predictions.isEmpty)
                    const Text('No predictions'),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isLoading)
                    const CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.black,
                    ),
                ],
              ),
            ),
    );
  }
}
