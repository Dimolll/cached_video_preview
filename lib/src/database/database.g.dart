// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class VideoEntity extends DataClass implements Insertable<VideoEntity> {
  final String name;
  final String imageUrl;
  final Uint8List file;
  VideoEntity({required this.name, required this.imageUrl, required this.file});
  factory VideoEntity.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return VideoEntity(
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      imageUrl: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}image_url'])!,
      file: const BlobType()
          .mapFromDatabaseResponse(data['${effectivePrefix}file'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['image_url'] = Variable<String>(imageUrl);
    map['file'] = Variable<Uint8List>(file);
    return map;
  }

  VideosCompanion toCompanion(bool nullToAbsent) {
    return VideosCompanion(
      name: Value(name),
      imageUrl: Value(imageUrl),
      file: Value(file),
    );
  }

  factory VideoEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return VideoEntity(
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      file: serializer.fromJson<Uint8List>(json['file']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'file': serializer.toJson<Uint8List>(file),
    };
  }

  VideoEntity copyWith({String? name, String? imageUrl, Uint8List? file}) =>
      VideoEntity(
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        file: file ?? this.file,
      );
  @override
  String toString() {
    return (StringBuffer('VideoEntity(')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('file: $file')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, imageUrl, file);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoEntity &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.file == this.file);
}

class VideosCompanion extends UpdateCompanion<VideoEntity> {
  final Value<String> name;
  final Value<String> imageUrl;
  final Value<Uint8List> file;
  const VideosCompanion({
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.file = const Value.absent(),
  });
  VideosCompanion.insert({
    required String name,
    required String imageUrl,
    required Uint8List file,
  })  : name = Value(name),
        imageUrl = Value(imageUrl),
        file = Value(file);
  static Insertable<VideoEntity> custom({
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<Uint8List>? file,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (file != null) 'file': file,
    });
  }

  VideosCompanion copyWith(
      {Value<String>? name, Value<String>? imageUrl, Value<Uint8List>? file}) {
    return VideosCompanion(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      file: file ?? this.file,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (file.present) {
      map['file'] = Variable<Uint8List>(file.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VideosCompanion(')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('file: $file')
          ..write(')'))
        .toString();
  }
}

class $VideosTable extends Videos with TableInfo<$VideosTable, VideoEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VideosTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _imageUrlMeta = const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String?> imageUrl = GeneratedColumn<String?>(
      'image_url', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _fileMeta = const VerificationMeta('file');
  @override
  late final GeneratedColumn<Uint8List?> file = GeneratedColumn<Uint8List?>(
      'file', aliasedName, false,
      type: const BlobType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [name, imageUrl, file];
  @override
  String get aliasedName => _alias ?? 'videos';
  @override
  String get actualTableName => 'videos';
  @override
  VerificationContext validateIntegrity(Insertable<VideoEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('file')) {
      context.handle(
          _fileMeta, file.isAcceptableOrUnknown(data['file']!, _fileMeta));
    } else if (isInserting) {
      context.missing(_fileMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name, imageUrl, file};
  @override
  VideoEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    return VideoEntity.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $VideosTable createAlias(String alias) {
    return $VideosTable(attachedDatabase, alias);
  }
}

abstract class _$CachedVideoDatabase extends GeneratedDatabase {
  _$CachedVideoDatabase(QueryExecutor e)
      : super(SqlTypeSystem.defaultInstance, e);
  late final $VideosTable videos = $VideosTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [videos];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$VideosDaoMixin on DatabaseAccessor<CachedVideoDatabase> {
  $VideosTable get videos => attachedDatabase.videos;
}
