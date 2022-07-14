import 'package:flutter/material.dart';
import 'package:movieapp/http/http_request.dart';
import 'package:movieapp/model/trailers_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailersScreen extends StatefulWidget {
  const TrailersScreen({Key? key, required this.id, required this.shows})
      : super(key: key);

  final String shows;
  final int id;

  @override
  State<TrailersScreen> createState() => _TrailersScreenState();
}

class _TrailersScreenState extends State<TrailersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TrailersModel>(
        //dung future vì đây là hàm tương lại có khi user không sử dụng
        //gắn keywword
        future: HttpRequest.getTrailers(
            widget.shows, widget.id), // nhớ nhập đúng keyword
        builder: (context, AsyncSnapshot<TrailersModel> snapshot) {
          if (snapshot.hasData) {
            // nếu dữ liệu bị lỗi thì trả về và hiển thị trên màn hình
            if (snapshot.data!.error != null &&
                snapshot.data!.error!.isNotEmpty) {
              return _buildErrorWidget(snapshot.data!.error);
            }
            // và ngược lại thì trả về "thể loại" trên movie
            return _buildTrailerWidget(snapshot.data!);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            //trả về trong khi đang truy xuất dữ liệu từ API
            return _buildLoadingWidget();
          }
        },
      ),
    );
  }

  // màn hình loads
  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          SizedBox(
            width: 25.0, height: 25.0,
            // là một hình tròn đang chạy trong trạng thái loadding
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

//màn hình lỗi
  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Vui Lòng Kết Nối Mạng:",
            style: TextStyle(fontSize: 20, color: Colors.white),
          )
        ],
      ),
    );
  }

  // màn hình trailer
  Widget _buildTrailerWidget(TrailersModel data) {
    List<Video>? videos = data.trailers;
    return Stack(
      children: <Widget>[
        Center(
          child: YoutubePlayer(
            controller: YoutubePlayerController(
                initialVideoId: videos![0].key!,
                flags: const YoutubePlayerFlags(
                  hideControls: true,
                  autoPlay: true,
                )),
          ),
        ),
        // button đóng
        Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close_sharp),
              color: Colors.white,
              onPressed: (() => Navigator.of(context).pop()),
            )),
      ],
    );
  }
}
