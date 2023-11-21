import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:snap_pro_downloader/screens/WhatsAppScreen.dart';
import 'package:snap_pro_downloader/screens/download_screen.dart';
import 'package:snap_pro_downloader/screens/home_screen.dart';
import 'package:snap_pro_downloader/screens/video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hive/hive.dart';

import '../models/path_model.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final FileManagerController controller = FileManagerController();
  List<FileSystemEntity> _downlaods = [];
  int _selectedIndexes = 0;

  Box<PathModel> Downloader = Hive.box<PathModel>('downloading_videos');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDownloads();
  }

  Future<void> _getDownloads() async {
    final videoInfo = FlutterVideoInfo();
    final downloadsDirectory = await getExternalStorageDirectory();
    final downloadsPath =
        '${downloadsDirectory!.path}/MyDownloads'; // Specify the folder name here
    final downloadsDir = Directory(downloadsPath);
    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }

    List<FileSystemEntity> _folders =
        downloadsDir.listSync(recursive: true, followLinks: false);
    List<FileSystemEntity> _data = [];

    for (var items in _folders) {
      if (items.path.contains('.mp4')) {
        _data.add(items);
        var _info = await videoInfo.getVideoInfo(items.path);

        Downloader.add(
          _info as PathModel,
        );
      }
    }
    setState(() {
      _downlaods = _data;
      Downloader.add(_downlaods as PathModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(32, 32, 32, 1),
        body: IndexedStack(
          index: _selectedIndexes,
          children: [
            HomeScreen(
              onDownloadComplete: () {
                _getDownloads();
              },
            ),
            DownloadScreen(
              Downloader: Downloader,
              onVideoDeleted: () {
                _getDownloads();
              },
            ),
            WhatsAppScreen(),
            SizedBox(),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          items: <Widget>[
            Icon(CupertinoIcons.home, size: 30, color: Colors.white),
            Icon(CupertinoIcons.arrow_down_to_line,
                size: 30, color: Colors.white),
            Icon(CupertinoIcons.phone_circle, size: 30, color: Colors.white),
          ],
          color: Colors.black.withOpacity(.8),
          buttonBackgroundColor: Colors.deepOrange,
          backgroundColor: Color.fromRGBO(32, 32, 32, 1),
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
          onTap: (index) {
            setState(() {
              _selectedIndexes = index;
            });
          },
          letIndexChange: (index) => true,
        ),
      ),
    );
  }
}
