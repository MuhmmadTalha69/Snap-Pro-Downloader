import 'package:extractor/extractor.dart';
import 'package:snap_pro_downloader/models/Video_download_model.dart';
import 'package:snap_pro_downloader/models/video_quality_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoDownloaderRepository {
  Future<VideoDownloadModel?> getAvailableVideos(String url) async {
    try {
      var response = await Extractor.getDirectLink(
        link: url,
      );

      if (response != null) {
        if (url.contains('youtube.com') || url.contains('youtu.be')) {
          final youtube = YoutubeExplode();
          final video = await youtube.videos.get(url);
          return VideoDownloadModel.fromJson({
            'title': video.title,
            'source': response.links?.first.href,
            'thumbnail': video.thumbnails.highResUrl,
            'videos': [
              VideoQualityModel(
                url: response.links?.first.href,
                quality: '720',
              ),
              VideoQualityModel(
                url: response.links?.last.href,
                quality: '360',
              ),
            ]
          });
        } else {
          return VideoDownloadModel.fromJson({
            'title': response!.title,
            'source': response.links?.first.href,
            'videos': [
              VideoQualityModel(
                url: response.links?.first.href,
                quality: '360',
              ),
            ]
          });
        }
      } else {
        return null;
      }
    } catch (e) {}
    return null;
  }

  /*Future<VideoDownloadModel?> getAvailableVideos(String url) async {
    try {
      var response = await DirectLink.check(url);
      final youtube = YoutubeExplode();
      final video = await youtube.videos.get(url);
      print("link:${video.url}");

      final videoInfo = VideoDownloadModel.fromJson({
        'title': video.title,
        'source': response?.first.link,
        'thumbnail': video.thumbnails.highResUrl,
        'videos': [
          VideoQualityModel(
            url: response?.first.link,
            quality: '720',
          ),
          VideoQualityModel(
            url: video.url,
            quality: '360',
          ),
        ],
      });

      return videoInfo;
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }*/
}
