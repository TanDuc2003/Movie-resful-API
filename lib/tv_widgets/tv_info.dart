import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/http/http_request.dart';
import 'package:movieapp/model/genres_model.dart';
import 'package:movieapp/model/tv/tv_details_model.dart';

class TVsInfo extends StatefulWidget {
  const TVsInfo({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<TVsInfo> createState() => _TVsInfoState();
}

class _TVsInfoState extends State<TVsInfo> {
  @override
  Widget build(BuildContext context) {
    // xây dựng đánh giá ,overview, thể loại
    return FutureBuilder<TVDetailsModel>(
      //dung future vì đây là hàm tương lại có khi user không sử dụng
      //gắn keywword
      future: HttpRequest.getTVShowsDetails(widget.id), // nhớ nhập đúng keyword
      builder: (context, AsyncSnapshot<TVDetailsModel> snapshot) {
        if (snapshot.hasData) {
          // nếu dữ liệu bị lỗi thì trả về và hiển thị trên màn hình
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          // và ngược lại thì trả về "thể loại" trên movie
          return _buildTVInfoWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error);
        } else {
          //trả về trong khi đang truy xuất dữ liệu từ API
          return _buildLoadingWidget();
        }
      },
    );
  }

  //xây dựng các phương thức cho wigget ở trên
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

  // màn hình INfo
  Widget _buildTVInfoWidget(TVDetailsModel data) {
    TVDetails detail = data.details!;
    return Column(children: <Widget>[
      _buildRating(detail),
      const SizedBox(height: 10),
      // buil overview
      _buildOverview(detail.overview),
      const SizedBox(height: 10),
      // buil danh sách thể loại
      _buildGenreList(detail.genres),
    ]);
  }

//buil danh sách thể loại
  Widget _buildGenreList(List<Genre>? genres) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 35,
            padding: EdgeInsets.only(top: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: Text(
                      genres[index].name!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 8,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

//build số lượng đánh giá
  Widget _buildRating(TVDetails details) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 120, // để hiển thị bên phải
          ),
          Expanded(
              child: SizedBox(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        details.rating!.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      RatingBar.builder(
                        itemSize: 20,
                        initialRating: details.rating! / 2,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                        itemBuilder: (context, _) {
                          return const Icon(
                            Icons.star,
                            color: Style.secondColor,
                          );
                        },
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    child: const Text(
                                      "Độ Dài",
                                      style: TextStyle(
                                        color: Style.textColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.timelapse,
                                      color: Style.textColor,
                                      size: 15,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${details.numberOfEpiondes!}',
                            style: const TextStyle(
                              color: Style.secondColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  Container(
                                    child: const Text(
                                      "Ngày Phát",
                                      style: TextStyle(
                                        color: Style.textColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.date_range,
                                      color: Style.textColor,
                                      size: 15,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${details.firstAirDate!}',
                            style: const TextStyle(
                              color: Style.secondColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildOverview(String? overview) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chi Tiết",
            style: TextStyle(
              color: Style.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            overview!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
