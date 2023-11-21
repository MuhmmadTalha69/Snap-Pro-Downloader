import 'package:snap_pro_downloader/models/video_quality_model.dart';
import 'package:snap_pro_downloader/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoQualityCard extends StatefulWidget {
  const VideoQualityCard(
      {Key? key,
      required this.onTap,
      required this.model,
      required this.type,
      required this.isSelected})
      : super(key: key);

  final VideoQualityModel model;
  final VoidCallback onTap;
  final VideoType type;
  final bool isSelected;

  @override
  State<VideoQualityCard> createState() => _VideoQualityCardState();
}

class _VideoQualityCardState extends State<VideoQualityCard> {
  String? get _quality {
    switch (widget.type) {
      case VideoType.facebook:
        return widget.model.quality;
      case VideoType.twitter:
        return widget.model.quality;
      case VideoType.tiktok:
        return widget.model.quality;
      case VideoType.instagram:
        return widget.model.quality;
      case VideoType.youtube:
        return widget.model.quality;

      default:
        return null;
    }
  }

  int? get _qualityValue {
    switch (widget.type) {
      case VideoType.facebook:
        if (_quality == "High Definition") {
          return 240;
        } else {
          return 144;
        }

      case VideoType.twitter:
        if (_quality == "High Definition") {
          return 240;
        } else {
          return 144;
        }
      case VideoType.instagram:
        if (_quality == "High Definition") {
          return 240;
        } else {
          return 144;
        }
      case VideoType.youtube:
        if (_quality == "High Definition") {
          return 720;
        } else {
          // Add logic to check for YouTube video quality
          if (widget.model.quality == '720' || widget.model.quality == '1080') {
            return 720;
          } else if (widget.model.quality == '240') {
            return 240;
          } else {
            return 360;
          }
        }
      case VideoType.tiktok:
        if (_quality == "High Definition") {
          return 240;
        } else {
          return 144;
        }
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.white)),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* widget.isSelected
                ? Icon(
                    FontAwesomeIcons.checkCircle,
                    color: Colors.white,
                    size: 20,
                  )
                : _qualityValue! >= 1080
                    ? Icon(
                        Icons.hd_rounded,
                        color: Colors.white,
                      )
                    : _qualityValue! >= 720
                        ? Icon(
                            Icons.hd_rounded,
                            color: Colors.white,
                            size: 28,
                          )
                        : Icon(
                            Icons.sd_rounded,
                            color: Colors.white,
                          ),
            SizedBox(
              width: 5,
            ),*/
            widget.isSelected
                ? Icon(
                    FontAwesomeIcons.checkCircle,
                    color: Colors.white,
                    size: 20,
                  )
                : (_qualityValue ?? 0) >= 1080
                    ? Icon(
                        Icons.hd_rounded,
                        color: Colors.white,
                      )
                    : (_qualityValue ?? 0) >= 720
                        ? Icon(
                            Icons.hd_rounded,
                            color: Colors.white,
                            size: 28,
                          )
                        : Icon(
                            Icons.sd_rounded,
                            color: Colors.white,
                          ),
            SizedBox(
              width: 5,
            ),
            Text(
              (widget.type == VideoType.youtube ||
                      widget.type == VideoType.twitter ||
                      widget.type == VideoType.tiktok)
                  ? "${_qualityValue}P"
                  : _quality ?? 'Error',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }
}
