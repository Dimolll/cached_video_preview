import 'package:flutter/foundation.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:drift/drift.dart';

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

@DriftAccessor(tables: <Type>[Videos])
class VideosDao extends DatabaseAccessor<CachedVideoDatabase>
    with _$VideosDaoMixin {
  VideosDao(CachedVideoDatabase db) : super(db);
}

@DriftDatabase(tables: <Type>[Videos])
class CachedVideoDatabase extends _$CachedVideoDatabase {
  CachedVideoDatabase()
      : super(
          SqfliteQueryExecutor.inDatabaseFolder(
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
