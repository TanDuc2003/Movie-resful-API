import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movieapp/model/hive_tv_model.dart';
import 'package:movieapp/model/movie/movie_model.dart';
import 'package:movieapp/model/tv/tv_model.dart';
import 'package:movieapp/movie_widgets/movie_info.dart';
import 'package:movieapp/movie_widgets/similar_movie_widget.dart';
import 'package:movieapp/screens/reviews.dart';
import 'package:movieapp/screens/trailers_screen.dart';

class TVsDetailsScreen extends StatefulWidget {
  const TVsDetailsScreen(
      {Key? key, required this.tvShows, required this.request})
      : super(key: key);
  final TVShows tvShows; // lấy bên movie_model
  final String? request;
  @override
  State<TVsDetailsScreen> createState() => _TVsDetailsScreenState();
}

class _TVsDetailsScreenState extends State<TVsDetailsScreen> {
  late Box<HiveTVModel> _tvWatchList;
  @override
  void initState() {
    _tvWatchList = Hive.box<HiveTVModel>('tv_list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tvShows.name!,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: [
                _buildBackDrop(),
                //
                Positioned(
                  top: 150,
                  left: 30,
                  child: Hero(
                      tag: widget.request == null
                          ? "${widget.tvShows.id}"
                          : "${widget.tvShows.id}" + widget.request!,
                      child: _buildPoster()),
                )
              ],
            ),
            MovieInfo(id: widget.tvShows.id!),
            SimilarMovies(id: widget.tvShows.id!),
            Reviews(
              id: widget.tvShows.id!,
              request: "tv",
            ),
          ],
        ),
      ),
      // thêm nút
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.redAccent,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            TrailersScreen(shows: "tv", id: widget.tvShows.id!),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.play_circle_filled_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Xem Trailer",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.orange,
                child: TextButton.icon(
                  onPressed: () {
                    HiveTVModel newValue = HiveTVModel(
                      id: widget.tvShows.id!,
                      rating: widget.tvShows.rating!,
                      name: widget.tvShows.name!,
                      backDrop: widget.tvShows.backDrop!,
                      poster: widget.tvShows.poster!,
                      overview: widget.tvShows.overview!,
                    );
                    _tvWatchList.add(newValue);
                    _showAlerDiglog();
                  },
                  icon: const Icon(
                    Icons.list_alt_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Thêm Vào List",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPoster() {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(
              "https://image.tmdb.org/t/p/w200/" + widget.tvShows.poster!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBackDrop() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage("https://image.tmdb.org/t/p/original/" +
              widget.tvShows.backDrop!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _showAlerDiglog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm Vào Danh Sách"),
          content: Text("${widget.tvShows.name!}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
