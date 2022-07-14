import 'package:flutter/material.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/http/http_request.dart';
import 'package:movieapp/model/reviews_model.dart';

class Reviews extends StatefulWidget {
  const Reviews({Key? key, required this.id, required this.request})
      : super(key: key);
  final int id;
  final String request;
  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
              "ĐÁNH GIÁ",
              style: const TextStyle(
                color: Style.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          FutureBuilder<ReviewsModel>(
            //dung future vì đây là hàm tương lại có khi user không sử dụng
            //gắn keywword
            future: HttpRequest.getReviews(
                widget.request, widget.id), // nhớ nhập đúng keyword
            builder: (context, AsyncSnapshot<ReviewsModel> snapshot) {
              if (snapshot.hasData) {
                // nếu dữ liệu bị lỗi thì trả về và hiển thị trên màn hình
                if (snapshot.data!.error != null &&
                    snapshot.data!.error!.isNotEmpty) {
                  return _buildErrorWidget(snapshot.data!.error);
                }
                // và ngược lại thì trả về "thể loại" trên movie
                return _buildReviewsMoviesWidget(snapshot.data!);
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error);
              } else {
                //trả về trong khi đang truy xuất dữ liệu từ API
                return _buildLoadingWidget();
              }
            },
          ),
        ],
      ),
    );
  }

  // màn hình loads
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

  //màn hình review
  Widget _buildReviewsMoviesWidget(ReviewsModel data) {
    List<Review>? reviews = data.reviews;
    if (reviews!.isEmpty) {
      return const SizedBox(
        child: Center(
          child: Text(
            "Chưa có lượt đánh giá",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: List.generate(reviews.length, (index) {
          return Card(
            color: Style.textColor,
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 5,
            child: ListTile(
              title: Text(
                reviews[index].content!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }),
      );
    }
  }
}
