import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/model/hive_movie_model.dart';
import 'package:movieapp/model/hive_tv_model.dart';

class TVsWatchList extends StatefulWidget {
  const TVsWatchList({Key? key}) : super(key: key);

  @override
  State<TVsWatchList> createState() => _TVsWatchListState();
}

class _TVsWatchListState extends State<TVsWatchList> {
  late Box<HiveTVModel> _tvWatchList;
  @override
  void initState() {
    _tvWatchList = Hive.box<HiveTVModel>('tv_list');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: _tvWatchList.isEmpty
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
                    valueListenable: _tvWatchList.listenable(),
                    builder: (context, Box<HiveTVModel> item, _) {
                      List<int> keys = item.keys.cast<int>().toList();
                      return ListView.builder(
                        itemCount: keys.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final key = keys[index];
                          final HiveTVModel? _item = item.get(key);
                          return Card(
                            elevation: 5,
                            child: ListTile(
                                title: Text(_item!.name),
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
                                      _tvWatchList.deleteAt(index);
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
