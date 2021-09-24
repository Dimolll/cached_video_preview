import 'dart:typed_data';

import 'source_type.dart';

class VideoPreviewData {
  VideoPreviewData.local(this.file)
      : type = SourceType.local,
        url = '';

  VideoPreviewData.remote(this.url)
      : type = SourceType.remote,
        file = null;

  final SourceType type;
  final Uint8List? file;
  final String url;
}
