import 'package:snap_pro_downloader/StatusFunc.dart';
import 'package:snap_pro_downloader/models/path_model.dart';
import 'package:snap_pro_downloader/screens/app_screen.dart';
import 'package:snap_pro_downloader/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:huawei_ads/huawei_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await HwAds.init();
    await VastSdkFactory.init(
      VastSdkConfiguration(),
    );
    await VastSdkFactory.userAcceptAdLicense(true);
  } catch (e) {
    debugPrint('EXCEPTION | $e');
  }
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(PathModelAdapter());
  await Hive.openBox<PathModel>('downloading_videos');
  await FlutterDownloader.initialize(debug: true);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  runApp(ChangeNotifierProvider(
    create: (_) => StatusProvider(),
    child: FileViewerApp(),
  ));
}

class FileViewerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
