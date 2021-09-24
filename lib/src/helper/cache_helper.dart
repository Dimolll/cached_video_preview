import 'dart:async';
import 'dart:typed_data';

import 'package:cached_video_preview/src/database/database.dart';
import 'package:cached_video_preview/src/models/source_type.dart';
import 'package:cached_video_preview/src/models/video_preview_data.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// This is a class that helps to combine fetching a preview
/// and saving it to the database.
class CachedVideoPreviewHelper {
  CachedVideoPreviewHelper._();
  static CachedVideoPreviewHelper? _instance;

  /// [CachedVideoPreviewHelper] singleton getter
  static CachedVideoPreviewHelper get instance =>
      _instance ??= CachedVideoPreviewHelper._();

  final CachedVideoDatabase _db = CachedVideoDatabase();

  final Map<String, Stream<VideoPreviewData>> _fetchers =
      <String, Stream<VideoPreviewData>>{};

  /// return [Stream<VideoPreviewData>] from parameters [path] and [source]
  Stream<VideoPreviewData> load(String path, SourceType source) {
    if (_fetchers.containsKey(path)) {
      return _fetchers[path]!;
    }
    final Stream<VideoPreviewData> stream =
        _db.getByName(path).asStream().asyncMap<VideoPreviewData>(
      (VideoEntity? event) {
        if (event != null) {
          return event.imageUrl.isNotEmpty
              ? VideoPreviewData.remote(event.imageUrl)
              : VideoPreviewData.local(event.file);
        }
        return _loadAndSave(path, source);
      },
    ).asBroadcastStream();
    _fetchers[path] = stream;
    return stream;
  }

  Future<VideoPreviewData> _loadAndSave(String path, SourceType source) async {
    late final VideoPreviewData data;
    if (source == SourceType.local) {
      final Uint8List? bytes = await _loadByThumbnail(path);
      data = await _save(path, file: bytes).then(
        (VideoEntity value) => value.imageUrl.isNotEmpty
            ? VideoPreviewData.remote(value.imageUrl)
            : VideoPreviewData.local(value.file),
      );
    } else {
      final String imageUrl = await _loadRemoteMetadata(path);
      Uint8List? bytes;
      if (imageUrl.isEmpty) {
        bytes = await _loadByThumbnail(path);
      }
      data = await _save(path, file: bytes, url: imageUrl).then(
        (VideoEntity value) => value.imageUrl.isNotEmpty
            ? VideoPreviewData.remote(value.imageUrl)
            : VideoPreviewData.local(value.file),
      );
    }

    return data;
  }

  Future<String> _loadRemoteMetadata(String path) async {
    final Completer<String> complater = Completer<String>();
    complater.complete(MetadataFetch.extract(path)
        .then((Metadata? value) => value?.image ?? ''));
    return complater.future;
  }

  Future<Uint8List?> _loadByThumbnail(String path) {
    final Completer<Uint8List?> complater = Completer<Uint8List?>();
    complater.complete(VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      quality: 75,
    ));
    return complater.future;
  }

  Future<VideoEntity> _save(String name, {Uint8List? file, String url = ''}) {
    final VideoEntity entity = VideoEntity(
      name: name,
      imageUrl: url,
      file: file ?? Uint8List.fromList(<int>[]),
    );
    return _db.add(entity).then((_) => entity);
  }
}
