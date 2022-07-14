import 'package:flutter/material.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/movie_widgets/genres_list.dart';
import 'package:movieapp/movie_widgets/get_genres.dart';
import 'package:movieapp/movie_widgets/now_playing_widget.dart';
import 'package:movieapp/movie_widgets/movies_widget.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({Key? key}) : super(key: key);

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        NowPlaying(),
        GetGenres(),
        MoviesWidget(text: "SẮP RA MẮT", request: 'upcoming'),
        MoviesWidget(text: "THỊNH HÀNH", request: 'popular'),
        MoviesWidget(text: "TOP XẾP HẠNG", request: 'top_rated'),
      ],
    );
  }
}
