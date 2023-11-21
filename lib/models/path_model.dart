import 'dart:io';

import 'package:hive/hive.dart';
part 'path_model.g.dart';

@HiveType(typeId: 0)
class PathModel {
  @HiveField(0)
  final List<FileSystemEntity>? download;
  @HiveField(1)
  final List<String>? path;
  @HiveField(2)
  final List<dynamic>? VideoData;
  @HiveField(3)
  final double? prog;

  PathModel({this.download, this.path, this.VideoData, this.prog});
}
