import 'package:flutter/material.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/http/http_request.dart';
import 'package:movieapp/model/genres_model.dart';
import 'package:movieapp/tv_widgets/genres_list.dart';

class GetGenres extends StatefulWidget {
  const GetGenres({Key? key}) : super(key: key);

  @override
  State<GetGenres> createState() => _GetGenresState();
}

class _GetGenresState extends State<GetGenres> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GenreModel>(
      //dung future vì đây là hàm tương lại có khi user không sử dụng
      //gắn keywword
      future: HttpRequest.getGenres("tv"), // nhớ nhập đúng keyword
      builder: (context, AsyncSnapshot<GenreModel> snapshot) {
        if (snapshot.hasData) {
          // nếu dữ liệu bị lỗi thì trả về và hiển thị trên màn hình
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          // và ngược lại thì trả về "thể loại" trên movie
          return _buildGenresWidget(snapshot.data!);
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

  // xây dung widget chứa thể loại
  Widget _buildGenresWidget(GenreModel data) {
    List<Genre>? genres = data.genres;
    if (genres!.isEmpty) {
      return const SizedBox(
        child: Text(
          "Không Tìm Thấy",
          style: TextStyle(fontSize: 20, color: Style.textColor),
        ),
      );
    } else {
      // trả về genres_list => thể loại phim
      return GenreLists(genres: genres);
    }
  }
}
