import 'dart:io';
import 'package:process_run/shell.dart' as shell;
import 'package:path_provider/path_provider.dart' as pathProvider;

class ExportVideoFrameX {
  static Future<void> getFrames(
      String filePath, String storagePath, String fileName) async {
    try {
      await shell.Shell().run(
        "ffmpeg -i $filePath -r 1/2 $storagePath/images/$fileName/%03d.jpg",
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<List<File>> getFramesFromVideoFile(String path,
      {String? storagePath, String? fileName}) async {
    String fName = fileName ?? '.';
    Directory appStorage = storagePath != null
        ? Directory(storagePath)
        : await pathProvider.getApplicationSupportDirectory();
    if (fileName != null) {
      Directory("${appStorage.path}/images/$fName").createSync(recursive: true);
    } else if (Directory("${appStorage.path}/images/$fName").existsSync()) {
      Directory("${appStorage.path}/images/$fName").deleteSync(recursive: true);
      Directory("${appStorage.path}/images/$fName").createSync(recursive: true);
    } else {
      Directory("${appStorage.path}/images/$fName").createSync(recursive: true);
    }

    await getFrames(path, appStorage.path, fName);
    List<FileSystemEntity> files =
        await Directory("${appStorage.path}/images/$fName").list().toList();
    return files.map((element) {
      return File(element.path);
    }).toList();
  }
}
