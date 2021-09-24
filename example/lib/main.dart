import 'dart:io';
import 'dart:typed_data';

import 'package:cached_video_preview/cached_video_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cached_video_preview Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: CachedVideoPreview(
                path: 'https://www.youtube.com/watch?v=b_sQ9bMltGU',
                type: SourceType.remote,
                remoteImageBuilder: (BuildContext context, url) =>
                    Image.network(url),
              ),
            ),
            Expanded(
              child: CachedVideoPreview(
                path:
                    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                type: SourceType.remote,
                remoteImageBuilder: (BuildContext context, url) =>
                    Image.network(url),
              ),
            ),
            Expanded(
              child: FutureBuilder<File>(
                future: _loadVideoFileFromAsset(),
                builder: (_, snapshot) => snapshot.hasData
                    ? CachedVideoPreview(
                        path: snapshot.requireData.path,
                        type: SourceType.local,
                        fileImageBuilder: (context, bytes) =>
                            Image.memory(bytes),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> _loadVideoFileFromAsset() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final filePath = join(directory.path, 'video.mp4');
    ByteData data = await rootBundle.load('assets/video.mp4');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return File(filePath).writeAsBytes(bytes);
  }
}
