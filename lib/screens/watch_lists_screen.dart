import 'package:flutter/material.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/movie_widgets/movie_watch_list.dart';
import 'package:movieapp/tv_widgets/tv_watch_list.dart';

class WatchLists extends StatefulWidget {
  const WatchLists({Key? key}) : super(key: key);

  @override
  State<WatchLists> createState() => _WatchListsState();
}

class _WatchListsState extends State<WatchLists> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Danh Sách Xem"),
          bottom: const TabBar(
            indicatorWeight: 5,
            indicatorColor: Style.secondColor,
            tabs: [
              Text("Phim", style: TextStyle(fontSize: 20)),
              Text("Truyền Hình", style: TextStyle(fontSize: 20))
            ],
          ),
        ),
        body: const TabBarView(children: <Widget>[
          MovieWatchList(),
          TVsWatchList(),
        ]),
      ),
    );
  }
}
