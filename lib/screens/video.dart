import 'dart:developer';
import 'dart:io';

import 'package:snap_pro_downloader/App_constants/thumbnails.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:snap_pro_downloader/StatusFunc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class WhatsAppVideo extends StatefulWidget {
  @override
  _WhatsAppVideoState createState() => _WhatsAppVideoState();
}

class _WhatsAppVideoState extends State<WhatsAppVideo> {
  bool isFetched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StatusProvider>(builder: (context, file, child) {
        if (isFetched == false) {
          file.getStatus('.mp4');
          Future.delayed(const Duration(microseconds: 1), () {
            isFetched = true;
          });
        }

        return file.isWhatsAppAvailable == false
            ? Center(
                child: Text("WhatsApp Data not Available."),
              )
            : file.getVideos.isEmpty
                ? Center(
                    child: Text("Video is not Available."),
                  )
                : Container(
                    padding: EdgeInsets.all(20),
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8),
                      children: List.generate(file.getVideos.length, (index) {
                        final data = file.getVideos[index];
                        return FutureBuilder<String>(
                            future: getThumbnail(data.path),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? GestureDetector(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: FileImage(
                                                        File(snapshot.data!))),
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
                                                      builder: (BuildContext
                                                          context) {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      },
                                                    );

                                                    Map<dynamic, dynamic>
                                                        result =
                                                        await ImageGallerySaver
                                                            .saveFile(
                                                                data.path);
                                                    String path = result[
                                                            "filePath"] ??
                                                        ""; // Access the path value from the map

                                                    Navigator.pop(
                                                        context); // Close the progress indicator dialog

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              "Video saved in gallery")),
                                                    );
                                                  },
                                                  icon: Icon(
                                                      Icons.download_rounded,
                                                      color: Colors.yellow)),
                                              SizedBox(
                                                width: 1,
                                              ),
                                              Text(
                                                '${path.basename(data.path)}'
                                                            .length >
                                                        3
                                                    ? '${path.basename(data.path)}'
                                                            .substring(0, 3) +
                                                        '...'
                                                    : '${path.basename(data.path)}',
                                                style: TextStyle(
                                                  color: Colors.black26,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 1,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Share.shareFiles(
                                                        [data.path]);
                                                  },
                                                  icon: Icon(
                                                    Icons.share,
                                                    color: Colors.yellow,
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    );
                            });
                      }),
                    ),
                  );
      }),
    );
  }
}
