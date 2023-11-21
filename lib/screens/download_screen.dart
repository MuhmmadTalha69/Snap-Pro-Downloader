/*
import 'dart:io';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:extractor/extractor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/path_model.dart';

class DownloadScreen extends StatefulWidget {
  DownloadScreen({
    Key? key,
    */
/*this.videoData,*/ /*

    required this.Downloader,
    */
/*required this.downloads,*/ /*

    required this.onVideoDeleted,
    this.onCardTap,
  }) : super(key: key);

  */
/* final List<VideoData>? videoData;*/ /*

  */
/*final List<FileSystemEntity> downloads;*/ /*

  final VoidCallback onVideoDeleted;
  final ValueChanged<int>? onCardTap;
  final List<Box<PathModel>> Downloader;

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  _showAlertDialog(BuildContext context, int index) {
    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      child: Text(
        "Cancel",
        style: GoogleFonts.poppins(
          color: Colors.orange,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    Widget deleteButton = TextButton(
      onPressed: () async {
        try {
          setState(() async {
            final file = File(widget.Downloader[index].path!);
            await file.delete();
          });
        } catch (e) {
          debugPrint(e.toString());
        }
        Navigator.of(context, rootNavigator: true).pop('dialog');
        widget.onVideoDeleted();
      },
      child: Text(
        "Delete",
        style: GoogleFonts.poppins(
          color: Colors.orange,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.yellow,
      title: Text(
        "Deletion Confirmation",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this video?',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  _showVideoPlayer(File videoFile) {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController?.play();
        });
      });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: AspectRatio(
            aspectRatio: _videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController!),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _videoPlayerController?.pause();
                });
              },
              icon: Icon(
                _videoPlayerController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.Downloader.isEmpty
        ? Padding(
            padding: EdgeInsets.only(left: 28, right: 28),
            child: Center(
              child: Column(
                children: [
                  Lottie.asset('assets/noth.json'),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "No Data Found",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: widget.Downloader.length,
              padding: EdgeInsets.symmetric(vertical: 5),
              itemBuilder: (context, index) {
                final pathModel = widget.Downloader[index].getAt(index);
                if (pathModel == null) {
                  return Container(); // or handle null case
                }
                return InkWell(
                  onTap: () {
                    print(Text('paths :${widget.Downloader.length}'));
                    _showVideoPlayer(File(pathModel.path![index]!));
                  },
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Video ${index + 1}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                // Share video
                              },
                              icon: Icon(Icons.share),
                            ),
                            IconButton(
                              onPressed: () {
                                _showAlertDialog(context, index);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
*/

import 'dart:io';
import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:huawei_ads/huawei_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:extractor/extractor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/path_model.dart';
import 'package:path/path.dart' as path;

class DownloadScreen extends StatefulWidget {
  DownloadScreen({
    Key? key,
    /*this.videoData,*/
    required this.Downloader,
    /*required this.downloads,*/
    required this.onVideoDeleted,
    this.onCardTap,
  }) : super(key: key);

  /* final List<VideoData>? videoData;*/
  /*final List<FileSystemEntity> downloads;*/
  final VoidCallback onVideoDeleted;
  final ValueChanged<int>? onCardTap;
  Box<PathModel> Downloader;

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  VideoPlayerController? _videoPlayerController;
  int i = 0;

  @override
  void initState() {
    super.initState();
    bannerAd.loadAd();
    bannerAd.show(gravity: Gravity.center);
  }

  BannerAd bannerAd = BannerAd(
    adSlotId: "o3f373bjs2", // This is test slot id for banner ad
    size: BannerAdSize.sAdvanced, // Banner size
    adParam: AdParam(), // Special request options
    bannerRefreshTime: 60, // Refresh time in seconds
  );

  // InterstitialAd
  InterstitialAd interstitialAd = InterstitialAd(
    adSlotId: "s4a4x5l941", // This is test slot id for interstitial ad
    adParam: AdParam(),
    // Special request options
  );
  // reward ad
  RewardAd rewardAd = RewardAd();

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  _showAlertDialog(BuildContext context, int index) {
    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      child: Text(
        "Cancel",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    Widget deleteButton = TextButton(
      onPressed: () async {
        try {
          final pathList = widget.Downloader.getAt(index)?.path;
          final path = pathList?.first; // Access the first element of the list
          if (path != null) {
            final file = File(path);
            print('File path: ${file.path}');
            if (await file.exists()) {
              await file.delete();
              print('File deleted');
              widget.Downloader.deleteAt(index);
              setState(() {
                print('State updated');
              });
            } else {
              print('File does not exist');
            }
          } else {
            widget.Downloader.getAt(index); // Remove the element from the list
            setState(() {
              print('State updated');
            });
          }
        } catch (e) {
          print('Error: $e');
        }
        Navigator.of(context, rootNavigator: true).pop('dialog');
        widget.onVideoDeleted();
      },
      child: Text(
        "Delete",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.deepOrange,
      title: Text(
        "Deletion Confirmation",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this video?',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  Future<Widget> generateThumbnail(String filePath) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: filePath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 200,
      quality: 25,
    );
    return Image.file(File(thumbnailPath!));
  }

  Widget buildThumbnail(String filePath) {
    return FutureBuilder<Widget>(
      future: generateThumbnail(filePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return snapshot.data!;
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.Downloader.isEmpty
        ? Padding(
            padding: EdgeInsets.only(top: 130, left: 28, right: 28),
            child: Center(
              child: Column(
                children: [
                  Lottie.asset('assets/noth.json'),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "No Data Found",
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 120,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: BannerView(
                        adSlotId: "o3f373bjs2",
                        size: BannerAdSize.sDynamic,
                        refreshDuration: Duration(seconds: 60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 4.0),
                    Padding(
                      padding: const EdgeInsets.only(right: 90, bottom: 11.5),
                      child: Center(
                        child: Text(
                          'Downloaded Videos',
                          style: GoogleFonts.poppins(
                              fontSize: 24.0,
                              color: Colors.grey[200],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: widget.Downloader.length,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      itemBuilder: (context, index) {
                        final pathModel = widget.Downloader.getAt(index);
                        if (pathModel == null || pathModel.path == null) {
                          return Container(); // Skip rendering if pathModel or path is null
                        } else {
                          return InkWell(
                            onTap: () async {
                              i++;
                              print('paths: ${widget.Downloader.length}');
                              /*_showVideoPlayerFromPathModel(pathModel);*/
                              if (pathModel.path != null &&
                                  pathModel.path!.isNotEmpty) {
                                final file = File(pathModel.path!
                                    .first); // Access the first element of the list
                                if (await file.exists()) {
                                  if (i % 6 == 0) {
                                    await rewardAd.loadAd(
                                      // Loading ad
                                      adSlotId:
                                          "g66iiw1hp8", // This is test slot id for reward ad
                                      adParam:
                                          AdParam(), // Special request options
                                    );
                                    await rewardAd.show();
                                    await OpenFile.open(file.path);
                                    await rewardAd.destroy();
                                  } else if (i % 3 == 0) {
                                    await interstitialAd.loadAd();
                                    await interstitialAd.show();
                                    await OpenFile.open(file.path);
                                    await interstitialAd.destroy();
                                  } else {
                                    await OpenFile.open(file.path);
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: buildThumbnail(
                                            pathModel.path!.first)),
                                    title: Text(
                                      ' ${path.basename(pathModel.path!.first)}',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white70),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            final path = pathModel.path!.first;

                                            await Share.shareXFiles(
                                                [XFile(path)]);
                                          },
                                          icon: Icon(
                                            Icons.share,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _showAlertDialog(context, index);
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Adjust width as needed
                  height: 50, // Set the height of the banner ad
                  child: BannerView(
                    adSlotId: 'o3f373bjs2',
                    size: BannerAdSize.s320x50,
                    adParam: AdParam(),
                    loadOnStart: true,
                  ),
                ),
              ],
            ),
          );
  }
}
