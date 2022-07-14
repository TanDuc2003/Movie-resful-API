import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/model/hive_movie_model.dart';

class MovieWatchList extends StatefulWidget {
  const MovieWatchList({Key? key}) : super(key: key);

  @override
  State<MovieWatchList> createState() => _MovieWatchListState();
}

class _MovieWatchListState extends State<MovieWatchList> {
  late Box<HiveMovieModel> _movieWatchList;
  @override
  void initState() {
    _movieWatchList = Hive.box<HiveMovieModel>('movie_list');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: _movieWatchList.isEmpty
          ? const Center(
              child: Text(
                "Chưa Thêm Vào Danh Sách !",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Style.textColor,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ValueListenableBuilder(
                    valueListenable: _movieWatchList.listenable(),
                    builder: (context, Box<HiveMovieModel> item, _) {
                      List<int> keys = item.keys.cast<int>().toList();
                      return ListView.builder(
                        itemCount: keys.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final key = keys[index];
                          final HiveMovieModel? _item = item.get(key);
                          return Card(
                            elevation: 5,
                            child: ListTile(
                                title: Text(_item!.title),
                                subtitle: Text(
                                  _item.overview,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: Image.network(
                                  "https://image.tmdb.org/t/p/w200/" +
                                      _item.poster,
                                  fit: BoxFit.cover,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _movieWatchList.deleteAt(index);
                                    });
                                  },
                                )),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
