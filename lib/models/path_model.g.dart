// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PathModelAdapter extends TypeAdapter<PathModel> {
  @override
  final int typeId = 0;

  @override
  PathModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PathModel(
      download: (fields[0] as List?)?.cast<FileSystemEntity>(),
      path: (fields[1] as List?)?.cast<String>(),
      VideoData: (fields[2] as List?)?.cast<dynamic>(),
      prog: fields[3] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, PathModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.download)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.VideoData)
      ..writeByte(3)
      ..write(obj.prog);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
