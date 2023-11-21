/*import 'dart:async';

import 'package:file_viewer/screens/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huawei_ads/huawei_ads.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadSplashAds();
    Timer(
      Duration(seconds: 8),
      () {
        if (_splashAd != null) {
          _splashAd?.destroy();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppScreen()),
        );
      },
    );
  }

  SplashAd? _splashAd;

  void loadSplashAds() {
    _splashAd = SplashAd(
      adType: SplashAdType.above,
      ownerText: 'Welcome Huawei',
      footerText: 'DTSE INDIA',
    );

    _splashAd?.loadAd(
      adSlotId: "testq6zq98hecj",
      orientation: SplashAdOrientation.portrait,
      topMargin: 10,
      adParam: AdParam(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 32, 32, 1),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 230,
            ),
            Lottie.asset('assets/d2.json', height: 200, width: 200),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0, right: 18),
              child: Text(
                "Snap Pro Downloader",
                style: GoogleFonts.poppins(fontSize: 23, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}*/
/*
import 'dart:async';
import 'package:snap_pro_downloader/screens/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huawei_ads/huawei_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  int appOpenCount = 0;
  bool shouldShowSplashAd = false;
  SplashAd? _splashAd;

  @override
  void initState() {
    super.initState();
    getAppOpenCount();
    Timer(
      Duration(seconds: 8),
      () {
        if (_splashAd != null) {
          _splashAd?.destroy();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppScreen()),
        );
      },
    );
  }

  void getAppOpenCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appOpenCount = prefs.getInt('appOpenCount') ?? 0;
    appOpenCount++;
    prefs.setInt('appOpenCount', appOpenCount);
    shouldShowSplashAd = appOpenCount % 1 == 0;
    if (shouldShowSplashAd) {
      loadSplashAds();
    }
  }

  void loadSplashAds() {
    _splashAd = SplashAd(
      adType: SplashAdType.above,
      ownerText: 'Welcome Huawei',
      footerText: 'DTSE INDIA',
    );

    _splashAd?.loadAd(
      adSlotId: "x720rhjgni",
      orientation: SplashAdOrientation.portrait,
      topMargin: 10,
      adParam: AdParam(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 32, 32, 1),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 230,
            ),
            Lottie.asset('assets/d2.json', height: 200, width: 200),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0, right: 18),
              child: Text(
                "Snap Pro Downloader",
                style: GoogleFonts.poppins(fontSize: 23, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:huawei_ads/huawei_ads.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'app_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  int appOpenCount = 0;
  bool shouldShowSplashAd = false;
  SplashAd? _splashAd;
  bool adLoaded = false;

  @override
  void initState() {
    super.initState();
    getAppOpenCount();
    Timer(
      Duration(seconds: 8),
      () {
        if (adLoaded) {
          _splashAd?.destroy();
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppScreen()),
        );
      },
    );
  }

  void getAppOpenCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appOpenCount = prefs.getInt('appOpenCount') ?? 0;
    appOpenCount++;
    prefs.setInt('appOpenCount', appOpenCount);
    shouldShowSplashAd = appOpenCount % 1 == 0;
    if (shouldShowSplashAd) {
      loadSplashAds();
    }
  }

  void loadSplashAds() {
    _splashAd = SplashAd(
      adType: SplashAdType.above,
    );

    _splashAd
        ?.loadAd(
      adSlotId: "y704ylm2ow",
      orientation: SplashAdOrientation.portrait,
      topMargin: 10,
      adParam: AdParam(),
    )
        .then((_) {
      // Ad loaded successfully
      setState(() {
        adLoaded = true;
      });
    }).catchError((error) {
      // Handle ad loading error
      print('Error loading ad: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 32, 32, 1),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 230,
            ),
            Lottie.asset('assets/d2.json', height: 200, width: 200),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0, right: 18),
              child: Text(
                "Snap Pro Downloader",
                style: GoogleFonts.poppins(fontSize: 23, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
