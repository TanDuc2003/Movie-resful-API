import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/http/http_request.dart';
import 'package:movieapp/model/movie/movie_model.dart';
import 'package:movieapp/screens/movie_detail_screen.dart';

class GenreMovies extends StatefulWidget {
  const GenreMovies({Key? key, required this.genreId}) : super(key: key);
  final int genreId;

  @override
  State<GenreMovies> createState() => _GenreMoviesState();
}

class _GenreMoviesState extends State<GenreMovies> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieModel>(
      //dung future vì đây là hàm tương lại có khi user không sử dụng
      //gắn keywword
      future: HttpRequest.getDiscoverMovies(
          widget.genreId), // nhớ nhập đúng keyword
      builder: (context, AsyncSnapshot<MovieModel> snapshot) {
        if (snapshot.hasData) {
          // nếu dữ liệu bị lỗi thì trả về và hiển thị trên màn hình
          if (snapshot.data!.error != null &&
              snapshot.data!.error!.isNotEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          // và ngược lại thì trả về "thể loại" trên movie
          return _buildMoviesByGenresWidget(snapshot.data!);
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

  // màn hình trả về thể loại phim
  Widget _buildMoviesByGenresWidget(MovieModel data) {
    List<Movie>? movies = data.movies; // đưa về dạng list
    if (movies!.isEmpty) {
      return const SizedBox(
        child: Text(
          "Không Tìm Thấy Phim",
          style: TextStyle(fontSize: 20, color: Style.textColor),
        ),
      );
    } else {
      // nếu có thì trả về movie và xếp hạng
      return Container(
        height: 270,
        padding: const EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: GestureDetector(
                //dùng GestureDetector để gắn sự kiện tab và chuyển trang bằng navigator
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => MoviesDetailsScreen(
                            movie: movies[index],
                            request: '',
                          )));
                },
                child: Column(
                  children: <Widget>[
                    movies[index].poster == null
                        ? Container(
                            // nếu
                            width: 120,
                            height: 180,
                            decoration: const BoxDecoration(
                                color: Style.secondColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                shape: BoxShape.rectangle),
                            child: const Center(
                              child:
                                  Icon(Icons.videocam_off, color: Colors.white),
                            ),
                          )
                        : Hero(
                            tag: "${movies[index].id}",
                            child: Container(
                              width: 120,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Style.secondColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(2)),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w200/" +
                                          movies[index].poster!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        movies[index].title!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                            fontSize: 10),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // hiển thị số lượng * trên porter
                    Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          movies[index].rating.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        RatingBar.builder(
                          itemSize: 8,
                          initialRating: movies[index].rating! / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 2),
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
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
