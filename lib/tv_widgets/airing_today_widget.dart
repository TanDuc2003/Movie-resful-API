import 'package:flutter/material.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/http/http_request.dart';
import 'package:movieapp/model/tv/tv_model.dart';
import 'package:page_indicator/page_indicator.dart';

class AiringToday extends StatefulWidget {
  const AiringToday({Key? key}) : super(key: key);

  @override
  State<AiringToday> createState() => AiringTodayState();
}

// tạo 1 widget chưa các bộ phim đang phát sóng
class AiringTodayState extends State<AiringToday> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TVModel>(
      //dung future vì đây là hàm tương lại có khi user không sử dụng
      //gắn keywword
      future: HttpRequest.getTVShows("airing_today"), // nhớ nhập đúng keyword
      builder: (context, AsyncSnapshot<TVModel> snapshot) {
        if (snapshot.hasData) {
          // nếu dữ liệu bị lỗi thì trả về và hiển thị trên màn hình
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          // và ngược lại thì trả về "now_playing" trên movie
          return _builAiringTodayWidget(snapshot.data!);
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

  //màn hình hiển thi nội dung phim khi không bị lỗi
  Widget _builAiringTodayWidget(TVModel data) {
    List<TVShows>? tvShows = data.tvShows;
    // trả về dữ liệu trống nếu không có phim được liệt kê trong API
    if (tvShows!.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: const Center(
            child: Text(
          "Không Tìm Thấy Truyền Hình",
          style: TextStyle(fontSize: 20, color: Style.textColor),
        )),
      );
      //trả về bộ phim đang được thao tác
    } else {
      return SizedBox(
        height: 220,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          indicatorSpace: 8,
          padding: const EdgeInsets.all(5),
          indicatorColor: Style.textColor,
          indicatorSelectorColor: Style.secondColor,
          length:
              tvShows.take(5).length, // chỉ được hiển thi 5 bộ phim trên 1 list
          shape: IndicatorShape.circle(size: 10),
          child: PageView.builder(
            scrollDirection: Axis.horizontal, //cuộn theo chiều dọc
            itemCount: tvShows.take(5).length,
            itemBuilder: (context, index) {
              return Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/original" +
                                tvShows[index].backDrop!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    // đổ mờ màu của banner
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Style.primaryColor.withOpacity(1),
                          Style.primaryColor.withOpacity(0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.9],
                      ),
                    ),
                  ),
                  // hiển thi tên và tiêu đề phim
                  Positioned(
                    bottom: 30.0,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            tvShows[index].name!,
                            style: const TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    }
  }
}
