import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movieapp/model/hive_movie_model.dart';
import 'package:movieapp/model/movie/movie_model.dart';
import 'package:movieapp/movie_widgets/movie_info.dart';
import 'package:movieapp/movie_widgets/similar_movie_widget.dart';
import 'package:movieapp/screens/reviews.dart';
import 'package:movieapp/screens/trailers_screen.dart';

class MoviesDetailsScreen extends StatefulWidget {
  const MoviesDetailsScreen(
      {Key? key, required this.movie, required this.request})
      : super(key: key);
  final Movie movie; // lấy bên movie_model
  final String? request;
  @override
  State<MoviesDetailsScreen> createState() => _MoviesDetailsScreenState();
}

class _MoviesDetailsScreenState extends State<MoviesDetailsScreen> {
  late Box<HiveMovieModel> _movieWatchList;
  @override
  void initState() {
    _movieWatchList = Hive.box<HiveMovieModel>('movie_list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title!,
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
                          ? "${widget.movie.id}"
                          : "${widget.movie.id}" + widget.request!,
                      child: _buildPoster()),
                )
              ],
            ),
            MovieInfo(id: widget.movie.id!),
            SimilarMovies(id: widget.movie.id!),
            Reviews(
              id: widget.movie.id!,
              request: "movie",
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
                        builder: (_) => TrailersScreen(
                            shows: "movie", id: widget.movie.id!),
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
                    HiveMovieModel newValue = HiveMovieModel(
                      id: widget.movie.id!,
                      rating: widget.movie.rating!,
                      title: widget.movie.title!,
                      backDrop: widget.movie.backDrop!,
                      poster: widget.movie.poster!,
                      overview: widget.movie.overview!,
                    );
                    _movieWatchList.add(newValue);
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
              "https://image.tmdb.org/t/p/w200/" + widget.movie.poster!),
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
          image: NetworkImage(
              "https://image.tmdb.org/t/p/original/" + widget.movie.backDrop!),
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
          content: Text("${widget.movie.title!}"),
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
