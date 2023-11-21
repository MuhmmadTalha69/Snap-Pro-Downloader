import 'dart:io';

import 'package:snap_pro_downloader/App_constants/thumbnails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huawei_ads/huawei_ads.dart';
import 'package:open_file/open_file.dart';

import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

import 'package:snap_pro_downloader/StatusFunc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:flutter/cupertino.dart';

import '../widgets/full_image.dart';

class WhatsAppScreen extends StatefulWidget {
  @override
  _WhatsAppScreenState createState() => _WhatsAppScreenState();
}

class _WhatsAppScreenState extends State<WhatsAppScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 32, 32, 1),
      appBar: AppBar(
        toolbarHeight: 1,
        backgroundColor: Colors.deepOrange,
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(
                Icons.image,
                color: Colors.white,
                size: 29,
              ),
              child: Text(
                "Images",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                "Videos",
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.video_library,
                color: Colors.white,
                size: 29,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          WhatsAppImages(),
          WhatsAppVideo(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          onPressed: () {
            setState(() {});
          },
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class WhatsAppImages extends StatefulWidget {
  @override
  _WhatsAppImagesState createState() => _WhatsAppImagesState();
}

class _WhatsAppImagesState extends State<WhatsAppImages> {
  bool isFetched = false;

  int i = 0;

  InterstitialAd interstitialAd = InterstitialAd(
    adSlotId: "s4a4x5l941", // This is test slot id for interstitial ad
    adParam: AdParam(),
    // Special request options
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 32, 32, 1),
      body: Column(
        children: [
          Expanded(
            child: Consumer<StatusProvider>(builder: (context, file, child) {
              if (isFetched == false) {
                file.getStatus('.jpg');
                Future.delayed(const Duration(microseconds: 1), () {
                  isFetched = true;
                });
              }

              return file.isWhatsAppAvailable == false
                  ? Center(
                      child: Text(
                        "WhatsApp Data not Available.",
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.white),
                      ),
                    )
                  : file.getImages.isEmpty
                      ? Center(
                          child: Text("Image is not Available.",
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.white)),
                        )
                      : Container(
                          padding: EdgeInsets.all(20),
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8),
                            children:
                                List.generate(file.getImages.length, (index) {
                              final data = file.getImages[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FullImageView(imagePath: data.path),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  FileImage(File(data.path!))),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder:
                                                    (BuildContext context) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                              );

                                              await interstitialAd.loadAd();
                                              await interstitialAd.show();

                                              await ImageGallerySaver.saveFile(
                                                  data.path);

                                              await interstitialAd.destroy();

                                              Navigator.pop(
                                                  context); // Close the progress indicator dialog

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Image saved in gallery")),
                                              );
                                            },
                                            icon: Icon(Icons.download_rounded,
                                                color: Colors.deepOrange
                                                    .withOpacity(0.8))),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                          '${path.basename(data.path)}'.length >
                                                  3
                                              ? '${path.basename(data.path)}'
                                                      .substring(0, 3) +
                                                  '...'
                                              : '${path.basename(data.path)}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              await interstitialAd.loadAd();
                                              await interstitialAd.show();
                                              await Share.shareFiles(
                                                  [data.path]);
                                              await interstitialAd.destroy();
                                            },
                                            icon: Icon(
                                              Icons.share,
                                              color: Colors.deepOrange
                                                  .withOpacity(0.8),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                        );
            }),
          ),
          SizedBox(
            height: 70,
            width: double.infinity,
            child: BannerView(
              adSlotId: "o3f373bjs2",
              size: BannerAdSize.s320x50,
              refreshDuration: Duration(seconds: 60),
            ),
          ),
        ],
      ),
    );
  }
}

class WhatsAppVideo extends StatefulWidget {
  @override
  _WhatsAppVideoState createState() => _WhatsAppVideoState();
}

class _WhatsAppVideoState extends State<WhatsAppVideo> {
  bool isFetched = false;

  int i = 0;

  InterstitialAd interstitialAd = InterstitialAd(
    adSlotId: "s4a4x5l941", // This is test slot id for interstitial ad
    adParam: AdParam(),
    // Special request options
  );
  RewardAd rewardAd = RewardAd();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 32, 32, 1),
      body: Column(
        children: [
          Expanded(
            child: Consumer<StatusProvider>(builder: (context, file, child) {
              if (isFetched == false) {
                file.getStatus('.mp4');
                Future.delayed(const Duration(microseconds: 1), () {
                  isFetched = true;
                });
              }

              return file.isWhatsAppAvailable == false
                  ? Center(
                      child: Text(
                        "WhatsApp Data not Available.",
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.white),
                      ),
                    )
                  : file.getVideos.isEmpty
                      ? Center(
                          child: Text("Video is not Available.",
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 18)),
                        )
                      : Container(
                          padding: EdgeInsets.all(20),
                          child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            children:
                                List.generate(file.getVideos.length, (index) {
                              final data = file.getVideos[index];
                              return FutureBuilder<String>(
                                future: getThumbnail(data.path),
                                builder: (context, snapshot) {
                                  return snapshot.hasData
                                      ? GestureDetector(
                                          onTap: () async {
                                            await OpenFile.open(data.path);
                                          },
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: FileImage(
                                                          File(snapshot.data!)),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      // Your download logic
                                                    },
                                                    icon: Icon(
                                                      Icons.download_rounded,
                                                      color: Colors.deepOrange
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                  SizedBox(width: 1),
                                                  Text(
                                                    '${path.basename(data.path)}'
                                                                .length >
                                                            3
                                                        ? '${path.basename(data.path)}'
                                                                .substring(
                                                                    0, 3) +
                                                            '...'
                                                        : '${path.basename(data.path)}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 1),
                                                  IconButton(
                                                    onPressed: () async {
                                                      await interstitialAd
                                                          .loadAd();
                                                      await interstitialAd
                                                          .show();
                                                      await Share.shareFiles(
                                                          [data.path]);
                                                      await interstitialAd
                                                          .destroy();
                                                    },
                                                    icon: Icon(
                                                      Icons.share,
                                                      color: Colors.deepOrange
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        );
                                },
                              );
                            }),
                          ),
                        );
            }),
          ),
          SizedBox(
            height: 70,
            width: double.infinity,
            child: BannerView(
              adSlotId: "o3f373bjs2",
              size: BannerAdSize.s320x50,
              refreshDuration: Duration(seconds: 60),
            ),
          )
        ],
      ),
    );
  }
}
