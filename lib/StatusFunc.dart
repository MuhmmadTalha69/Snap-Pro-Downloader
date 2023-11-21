import 'dart:developer';
import 'dart:io';

import 'package:snap_pro_downloader/App_constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class StatusProvider extends ChangeNotifier {
  List<FileSystemEntity> _getImages = [];
  List<FileSystemEntity> _getVideos = [];

  bool _isWhatsAppAvailable = false;

  List<FileSystemEntity> get getImages => _getImages;
  List<FileSystemEntity> get getVideos => _getVideos;

  bool get isWhatsAppAvailable => _isWhatsAppAvailable;
  void getStatus(String ex) async {
    final status = await Permission.storage.request();

    if (status.isDenied) {
      Permission.storage.request();
      return;
    }

    if (status.isGranted) {
      var directory = Directory(AppConstants.WhatsApp_Path);
      var fallbackDirectory = Directory(AppConstants.WhatsApp_pathT);

      if (!directory.existsSync()) {
        // Use fallback directory if the main directory does not exist
        directory = fallbackDirectory;
      }
      if (directory.existsSync()) {
        final items = directory.listSync();
        log(items.toString());
        if (ex == '.mp4') {
          _getVideos =
              items.where((element) => element.path.endsWith(".mp4")).toList();
          notifyListeners();
        } else {
          _getImages =
              items.where((element) => element.path.endsWith(".jpg")).toList();
          notifyListeners();
        }
        _isWhatsAppAvailable = true;
        notifyListeners();
      } else {
        log("No whatsApp found");
        _isWhatsAppAvailable = false;
        notifyListeners();
      }
    }
  }
}
