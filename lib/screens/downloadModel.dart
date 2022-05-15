import 'dart:io';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DownloadModel extends ChangeNotifier {
  double _progress = 0;
  get downloadProgress => _progress;

  Future<void> startDownloading() async {
    _progress = null;
    notifyListeners();

    final url =
        'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_5MG.mp3';
    final request = Request('GET', Uri.parse(url));
    final StreamedResponse response = await Client().send(request);

    final contentLength = response.contentLength;
    // final contentLength = double.parse(response.headers['x-decompressed-content-length']);

    _progress = 0;
    notifyListeners();

    List<int> bytes = [];

    final file = await _getFile('timevictor.mp3');
    print(response.stream.length);
    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        _progress = downloadedLength / contentLength;
        notifyListeners();
      },
      onDone: () async {
        _progress = 0;
        notifyListeners();
        await file.writeAsBytes(bytes);
      },
      onError: (e) {
        print(e);
      },
      cancelOnError: true,
    );
  }

  Future<File> _getFile(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/$filename");
  }
}
