import 'package:flutter/material.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/model/genres_model.dart';
import 'package:movieapp/movie_widgets/genres_movies.dart';

class GenreLists extends StatefulWidget {
  const GenreLists({Key? key, required this.genres}) : super(key: key);
  final List<Genre> genres;

  @override
  State<GenreLists> createState() => _GenreListsState();
}

class _GenreListsState extends State<GenreLists>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  // khởi tạo
  @override
  void initState() {
    _tabController = TabController(length: widget.genres.length, vsync: this);
    _tabController!.addListener(() {});
    super.initState();
  }

  //bổ bộ điều khiển chức năng tab
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: DefaultTabController(
        length: widget.genres.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Style.secondColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                unselectedLabelColor: Style.textColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: widget.genres.map((Genre genre) {
                  return Container(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      top: 10,
                    ),
                    child: Text(
                      genre.name!.toUpperCase(),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.genres.map((Genre genres) {
              return GenreMovies(genreId: genres.id!);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
