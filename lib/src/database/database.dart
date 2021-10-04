import 'package:flutter/foundation.dart';
import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

// ignore_for_file: always_specify_types
@DataClassName('VideoEntity')
class Videos extends Table {
  TextColumn get name => text()();
  TextColumn get imageUrl => text()();
  BlobColumn get file => blob()();

  @override
  Set<Column>? get primaryKey => {
        name,
        imageUrl,
        file,
      };
}

@UseDao(tables: <Type>[Videos])
class VideosDao extends DatabaseAccessor<CachedVideoDatabase>
    with _$VideosDaoMixin {
  VideosDao(CachedVideoDatabase db) : super(db);
}

@UseMoor(tables: <Type>[Videos])
class CachedVideoDatabase extends _$CachedVideoDatabase {
  CachedVideoDatabase()
      : super(
          FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite',
            logStatements: kDebugMode,
          ),
        );

  @override
  int get schemaVersion => 1;

  Future<int> add(VideoEntity video) => into(videos).insert(video);

  Future<VideoEntity?> getByName(String path) =>
      (select(videos)..where(($VideosTable tbl) => tbl.name.equals(path)))
          .getSingleOrNull();

  Stream<VideoEntity?> getByNameStream(String path) =>
      (select(videos)..where(($VideosTable tbl) => tbl.name.equals(path)))
          .watchSingleOrNull();
}
