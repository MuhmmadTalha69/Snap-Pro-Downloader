import 'dart:io';

import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:snap_pro_downloader/models/Video_download_model.dart';
import 'package:snap_pro_downloader/models/video_quality_model.dart';
import 'package:snap_pro_downloader/repository/video_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:huawei_ads/huawei_ads.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/path_model.dart';
import '../widgets/video_quality_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.onDownloadComplete})
      : super(key: key);

  final Function onDownloadComplete;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();

  var _progressValue = 0.0;

  var _isDownloading = false;

  List<VideoQualityModel>? _qualities = [];

  VideoDownloadModel? _video;

  bool? _isLoading = false;

  int _SelectedQuailtyIndexes = 0;

  String? _fileName = '';

  bool? _isSearching = false;

  int i = 0;

  int buttonPressCount = 0;

  bool shouldShowRewardAd = false;

  double progress = 0.0;

  VideoType _videoType = VideoType.none;

  String? get _getProfilePrefix {
    switch (_videoType) {
      case VideoType.facebook:
        return 'Facebook';
      case VideoType.twitter:
        return 'Twitter';
      case VideoType.instagram:
        return 'Instagram';
      case VideoType.youtube:
        return 'Youtube';
      case VideoType.tiktok:
        return 'TikTok';
      default:
        return null;
    }
  }

  final savedPath = Hive.box<PathModel>('downloading_videos');

  void _SetVideoType(String url) {
    if (url.isEmpty) {
      setState(() {
        _videoType = VideoType.none;
      });
    } else if (url.contains('facebook.com') || url.contains('fb.watch')) {
      setState(() {
        _videoType = VideoType.facebook;
      });
    } else if (url.contains('youtube.com') || url.contains('youtu.be')) {
      setState(() {
        _videoType = VideoType.youtube;
      });
    } else if (url.contains('twitter.com')) {
      setState(() {
        _videoType = VideoType.twitter;
      });
    } else if (url.contains('instagram.com')) {
      setState(() {
        _videoType = VideoType.instagram;
      });
    } else if (url.contains('tiktok.com')) {
      setState(() {
        _videoType = VideoType.tiktok;
      });
    } else {
      setState(() {
        _videoType = VideoType.none;
      });
    }
  }

  RewardAd rewardAd = RewardAd();

  _showSnackBar(String title, int duration) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.all(16),
        backgroundColor: Colors.deepOrange,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 30,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        )));
  }

  Future<void> _performDownloading(String url) async {
    Dio dio = Dio();

    var re = await Permission.storage.request();
    if (await re.isGranted) {
      var downloadsDirectory = await getExternalStorageDirectory();
      var downloadsPath =
          '${downloadsDirectory!.path}/MyDownloads'; // Specify the folder name here
      var dir = Directory(downloadsPath);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      setState(() {
        _fileName =
            "/$_getProfilePrefix-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.mp4";
      });
      var path = dir.path + _fileName!;
      var pathModel = PathModel(path: [path]);
      savedPath.add(PathModel(path: [path]));
      print('pathmodel:${pathModel.path![0]}');
      try {
        if (!mounted) return;
        setState(() {
          _isDownloading = true;
        });

        await dio.download(
          url,
          pathModel.path![0]!,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              if (!mounted) return;
              setState(() {
                _progressValue = (received / total * 100);
                savedPath.put('prog', PathModel(prog: _progressValue));
                progress = savedPath.get('prog')?.prog ?? 0.0;
              });
            }
          },
          deleteOnError: true,
        ).then((_) async {
          widget.onDownloadComplete();
          if (!mounted) return;
          setState(() {
            _isDownloading = false;
            progress = 0.0;
            _videoType = VideoType.none;
            _isLoading = false;
            _qualities = [];
            _video = null;
          });
          _controller.text = "";
          _showSnackBar("Video Downloaded Successfully 😊 !", 2);
        });
      } on DioError catch (e) {
        if (!mounted) return;
        setState(() {
          _videoType = VideoType.none;
          _isDownloading = false;
          _qualities = [];
          _video = null;
        });
        _showSnackBar("Oops! ${e.message}", 2);
      }
    } else {
      _showSnackBar('No permission Granted From User!', 2);
    }
  }

  /* Future<void> _performDownloading(String url) async {
    Dio dio = Dio();

    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      var downloadsDirectory = await getExternalStorageDirectory();
      var downloadsPath =
          '${downloadsDirectory!.path}/MyDownloads'; // Specify the folder name here
      var dir = Directory(downloadsPath);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      setState(() {
        _fileName =
            "/$_getProfilePrefix-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.mp4";
      });
      var path = dir.path + _fileName!;
      var pathModel = PathModel(path: [path]);
      savedPath.add(PathModel(path: [path]));
      print('pathmodel:${pathModel.path![0]}');
      try {
        if (!mounted) return;
        setState(() {
          _isDownloading = true;
        });
        await dio.download(
          url,
          pathModel.path![0]!,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              if (!mounted) return;
              setState(() {
                _progressValue = (received / total * 100);
                savedPath.put('prog', PathModel(prog: _progressValue));
                progress = savedPath.get('prog')?.prog ?? 0.0;
              });
            }
          },
          deleteOnError: true,
        ).then((_) async {
          widget.onDownloadComplete();
          if (!mounted) return;
          setState(() {
            _isDownloading = false;
            progress = 0.0;
            _videoType = VideoType.none;
            _isLoading = false;
            _qualities = [];
            _video = null;
          });
          _controller.text = "";
          _showSnackBar("Video Downloaded Successfully!", 2);
        });
      } on DioError catch (e) {
        if (!mounted) return;
        setState(() {
          _videoType = VideoType.none;
          _isDownloading = false;
          _qualities = [];
          _video = null;
        });
        _showSnackBar("Oops! ${e.message}", 2);
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }*/

  Future<void> _onLinkPasted(String url) async {
    var response = await VideoDownloaderRepository().getAvailableVideos(url);
    setState(() {
      _video = response;
    });
    if (_video != null) {
      for (var _quality in _video!.videos!) {
        _qualities!.add(_quality);
      }
      _showBottomModal();
    } else {
      _qualities = null;
    }

    setState(() {
      _isSearching = false;
    });
  }

  _showBottomModal() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.deepOrange,
        isDismissible: false,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        )),
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _qualities == null
                                ? "Oops Sorry Bro!!!"
                                : "Download Video ",
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                print(
                                  'path:${savedPath.path}',
                                );
                              },
                              icon: Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 26,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.90,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: _video?.thumbnail == null
                                ? _qualities == null
                                    ? Lottie.asset('assets/oops.json')
                                    : Lottie.asset('assets/vidprog.json')
                                : Image.network(
                                    _video!.thumbnail!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.download_outlined,
                            color: Colors.white,
                            size: 26,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Downloading From ${_getProfilePrefix}",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.video,
                            color: Colors.white,
                            size: 26,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: _video?.title == null
                                  ? Text(
                                      "Social Media Site",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    )
                                  : Text(
                                      _video!.title!,
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      /* Wrap(
                        children: List.generate(
                          _qualities!.length,
                          (index) => VideoQualityCard(
                            isSelected: _SelectedQuailtyIndexes == index,
                            model: _qualities![index],
                            onTap: () async {
                              setState(() {
                                _SelectedQuailtyIndexes =
                                    index; // Update the selected index
                              });
                            },
                            type: _videoType,
                          ),
                        ),
                      )*/
                      Wrap(
                        children: _qualities == null
                            ? [
                                GestureDetector(
                                  onTap: () {
                                    // Retry fetching qualities
                                    setState(() {
                                      _qualities == null;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.deepOrange,
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 22),
                                    child: Center(
                                      child: Text(
                                        'Some error occurred. Clear Link Try again.',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            : List.generate(
                                _qualities!.length,
                                (index) => VideoQualityCard(
                                  isSelected: _SelectedQuailtyIndexes == index,
                                  model: _qualities![index],
                                  onTap: () async {
                                    setState(() {
                                      _SelectedQuailtyIndexes = index;
                                    });
                                  },
                                  type: _videoType,
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_isDownloading) {
                            _showSnackBar(
                                'Try again later! Downloading in Progress !',
                                2);
                          } else {
                            Navigator.pop(context);
                            if (await _qualities![_SelectedQuailtyIndexes]
                                    .url ==
                                null) {
                              _showSnackBar(
                                  'Try agin I cant Pick Url Sorry 🥺 !', 3);
                            } else {
                              await _performDownloading(
                                  _qualities![_SelectedQuailtyIndexes].url!);
                            }
                          }
                        },
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "Download This Video",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8.0,
                      left: 8,
                    ),
                    child: CircleAvatar(
                      child: Image.asset(
                        'assets/img.png',
                        height: 90,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Center(
                      child: Text(
                        'Snap Pro Downloader',
                        style: GoogleFonts.poppins(
                            fontSize: 23.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  "Enter URL Here",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _controller,
                style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
                enabled: false,
                cursorWidth: 1,
                cursorColor: Colors.white,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: Colors.deepOrange,
                    suffixIcon: Icon(
                      Icons.download_outlined,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () async {
                      i++;

                      if (i >= 3) {
                        i = 0;
                        await rewardAd.loadAd(
                          adSlotId:
                              "g66iiw1hp8", // This is test slot id for reward ad
                          adParam: AdParam(),
                        );
                        await rewardAd.show();
                        await rewardAd.destroy();
                      }
                      if (_isSearching!) {
                        _showSnackBar(
                            "Try again ! later searching in progress 😊 !", 2);
                      } else if (_isDownloading) {
                        _showSnackBar(
                            "Try again ! later Downloading in progress 😊 !",
                            2);
                      } else {
                        Clipboard.getData(Clipboard.kTextPlain)
                            .then((value) async {
                          bool _hasString = await Clipboard.hasStrings();
                          if (_hasString) {
                            if (_controller.text == value!.text) {
                              setState(() {
                                _showBottomModal();
                              });
                            } else {
                              setState(() {
                                _SelectedQuailtyIndexes = 0;
                                _videoType = VideoType.none;
                                _isLoading = false;
                                _qualities = [];
                                _video = null;
                                _isLoading = true;
                              });
                              _controller.text = '';
                              _controller.text = value.text!;
                              if (value.text!.isEmpty ||
                                  _controller.text.isEmpty) {
                                _showSnackBar('Enter Video Url', 2);
                              } else {
                                _SetVideoType(value.text!);
                                setState(() {
                                  _isSearching = true;
                                });
                                await _onLinkPasted(value.text!);
                              }
                            }
                          } else {
                            _showSnackBar(
                                "Empty content pasted try again 😊 !", 2);
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        });
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Paste Link",
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepOrange),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)))),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () async {
                      if (_isDownloading) {
                        _showSnackBar("Try agin Downloading in Progress 😊", 2);
                      } else {
                        setState(() {
                          _SelectedQuailtyIndexes = 0;
                          _videoType = VideoType.none;
                          _isLoading = false;
                          _qualities = [];
                          _video = null;
                        });
                        _controller.text = "";
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Clear Link",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.deepOrange),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)))),
                  ))
                ],
              ),
              SizedBox(
                height: 35,
              ),
              _isLoading!
                  ? Container(
                      child: Center(
                        child: Lottie.asset(
                          'assets/pr.json',
                        ),
                      ),
                    )
                  : !_isDownloading
                      ? (_qualities != null && _qualities!.isNotEmpty)
                          ? Container()
                          : _qualities == null
                              ? Text(
                                  "Link is to complicated or either i don't have access !..try Again 🥺",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20, color: Colors.white),
                                )
                              : Container()
                      : Container(),
              _isDownloading
                  ? SizedBox(
                      height: 20,
                    )
                  : SizedBox(
                      height: 10,
                    ),
              _isDownloading
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.downloading,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Downloading",
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      _fileName!.substring(1),
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              ),
                              Text(
                                "${progress.toStringAsFixed(0)}%",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          LinearProgressIndicator(
                            color: Colors.deepOrange.withOpacity(0.8),
                            backgroundColor: Colors.white,
                            value: progress / 100,
                            minHeight: 6,
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.deepOrange,
                      ),
                    )
                  : Container(),
              _isDownloading
                  ? SizedBox(
                      height: 20,
                    )
                  : Container(),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum VideoType { facebook, twitter, instagram, tiktok, youtube, none }
