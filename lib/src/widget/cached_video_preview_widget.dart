import 'dart:async';
import 'dart:typed_data';

import 'package:cached_video_preview/src/helper/cache_helper.dart';
import 'package:cached_video_preview/src/models/source_type.dart';
import 'package:cached_video_preview/src/models/video_preview_data.dart';
import 'package:flutter/material.dart';

/// Remote Image Builder typedef
typedef RemoteImageBuilder = Widget Function(BuildContext, String);

/// File Image Builder typedef
typedef FileImageBuilder = Widget Function(BuildContext, Uint8List);

class CachedVideoPreviewWidget extends StatefulWidget {
  const CachedVideoPreviewWidget({
    Key? key,
    required this.path,
    this.type = SourceType.local,
    this.remoteImageBuilder,
    this.fileImageBuilder,
    this.placeHolder,
    this.fadeDuration = const Duration(milliseconds: 500),
    this.httpHeaders,
  }) : super(key: key);

  /// Video path can be remote url or local file path
  final String path;

  /// [SourceType] enum value
  final SourceType type;

  /// Use this callback if you want to build your own widget
  final RemoteImageBuilder? remoteImageBuilder;

  /// Use this callback if you want to build your own widget
  final FileImageBuilder? fileImageBuilder;

  /// Use this [placeHolder] if you want to build your own placeholder
  final Widget? placeHolder;

  /// Use this [fadeDuration] if you want to
  /// ovverride [FadeTransition] duration.
  /// Default = [const Duration(milliseconds: 500)]
  final Duration fadeDuration;

  /// HTTP headers for remote video request
  final Map<String, String>? httpHeaders;

  @override
  _CachedVideoPreviewWidgetState createState() =>
      _CachedVideoPreviewWidgetState();
}

class _CachedVideoPreviewWidgetState extends State<CachedVideoPreviewWidget>
    with SingleTickerProviderStateMixin {
  late final StreamController<VideoPreviewData> _previewController;
  late final AnimationController _animation;
  late final StreamSubscription<VideoPreviewData> _subs;

  @override
  void initState() {
    _previewController = StreamController<VideoPreviewData>();
    _animation = AnimationController(
      vsync: this,
      duration: widget.fadeDuration,
    );
    _subs = CachedVideoPreviewHelper.instance
        .load(
      widget.path,
      widget.type,
      widget.httpHeaders,
    )
        .listen(
      (VideoPreviewData data) {
        _previewController.add(data);
        _animation.forward();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VideoPreviewData>(
      stream: _previewController.stream,
      builder: (_, AsyncSnapshot<VideoPreviewData> snapshot) {
        if (!snapshot.hasData) {
          return widget.placeHolder ??
              const Center(
                child: CircularProgressIndicator.adaptive(),
              );
        }
        final Widget child = snapshot.requireData.file != null
            ? widget.fileImageBuilder
                    ?.call(context, snapshot.requireData.file!) ??
                Image.memory(snapshot.requireData.file!)
            : widget.remoteImageBuilder
                    ?.call(context, snapshot.requireData.url) ??
                Image.network(snapshot.requireData.url);
        return FadeTransition(
          opacity: _animation,
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {
    _previewController.close();
    _subs.cancel();
    _animation.dispose();
    super.dispose();
  }
}
