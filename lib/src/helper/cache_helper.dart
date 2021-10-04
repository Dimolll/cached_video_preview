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

  static final CachedVideoDatabase _db = CachedVideoDatabase();

  final Set<String> _fetchers = <String>{};

  /// return [Stream<VideoPreviewData>] from parameters [path] and [source]
  Stream<VideoPreviewData> load(String path, SourceType source) async* {
    final fromDbValue = await _db.getByName(path);
    if (fromDbValue != null) {
      yield fromDbValue.toPreview;
    } else {
      _execute(path, source);
      yield* _db
          .getByNameStream(path)
          .where((event) => event != null)
          .map((event) => event!.toPreview);
    }
  }

  Future<void> _execute(String path, SourceType source) async {
    if (!_fetchers.contains(path)) {
      await _loadAndSave(path, source).then((value) async {
        final res = await _db.add(value);
        print(res);
        _fetchers.remove(path);
      }).catchError((e) {
        print(path);
        print(e);
      });
    }
  }

  static Future<VideoEntity> _loadAndSave(
    String path,
    SourceType source,
  ) async {
    if (source == SourceType.local) {
      try {
        final Uint8List? bytes = await _loadByThumbnail(path);
        return _getVideoEntity(path, file: bytes);
      } catch (e) {
        print(e);
        rethrow;
      }
    } else {
      final String imageUrl = await _loadRemoteMetadata(path);
      Uint8List? bytes;
      if (imageUrl.isEmpty) {
        bytes = await _loadByThumbnail(path);
      }
      return _getVideoEntity(path, file: bytes, url: imageUrl);
    }
  }

  static Future<String> _loadRemoteMetadata(String path) =>
      MetadataFetch.extract(path).then((Metadata? value) => value?.image ?? '');

  static Future<Uint8List?> _loadByThumbnail(String path) =>
      VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat.JPEG,
        quality: 75,
      );

  static VideoEntity _getVideoEntity(
    String name, {
    Uint8List? file,
    String url = '',
  }) =>
      VideoEntity(
        name: name,
        imageUrl: url,
        file: file ?? Uint8List.fromList(<int>[]),
      );
}

extension Mapper on VideoEntity {
  VideoPreviewData get toPreview => imageUrl.isNotEmpty
      ? VideoPreviewData.remote(imageUrl)
      : VideoPreviewData.local(file);
}
