## Introduction

Cached Video Preview can help you get remote or local video preview image and cache it.

## USAGE
This is example code how to implement this package.

### Get Remote Video Image Preview extracting metadata in web pages
``` Dart

CachedVideoPreview(
  path: 'https://www.youtube.com/watch?v=b_sQ9bMltGU',
  type: SourceType.remote,
  remoteImageBuilder: (BuildContext context, url) =>
      Image.network(url),
)

```

### Get Remote Video Image Preview from video url
``` Dart

CachedVideoPreview(
  path: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  type: SourceType.remote,
  httpHeaders: const <String, String>{},
  remoteImageBuilder: (BuildContext context, url) =>
      Image.network(url),
)

```
### Get Local Video Image Preview from File path
``` Dart
final File video = File('video.mp4');

CachedVideoPreview(
  path: video.path,
  type: SourceType.local,
  fileImageBuilder: (context, bytes) =>
      Image.memory(bytes),
)

```

## Acknowledgments

Thanks to the authors of these libraries [metadata_fetch][metadata_fetch_link] and [video_thumbnail][video_thumbnail_link].

[metadata_fetch_link]: https://pub.dev/packages/metadata_fetch
[video_thumbnail_link]: https://pub.dev/packages/video_thumbnail/install

## Contact and bugs
Use [Issue Tracker][issue_tracker] for any questions or bug reports.

[issue_tracker]: https://github.com/Dimolll/cached_video_preview/issues/
