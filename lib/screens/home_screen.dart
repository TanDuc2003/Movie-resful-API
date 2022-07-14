import 'package:flutter/material.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/screens/movie_screen.dart';
import 'package:movieapp/screens/tv_screen.dart';
import 'package:movieapp/screens/watch_lists_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // tạo bộ điều khiển trang
    PageController _controller = PageController();
    void onTapIcon(int index) {
      _controller.animateToPage(index,
          duration: const Duration(microseconds: 200), curve: Curves.easeIn);
    }

    return Scaffold(
      appBar: _currentIndex != 2
          ? AppBar(
              title: _buildTitle(_currentIndex),
              centerTitle: true,
              // elevation: 0,
            )
          : null,
      // tao body hiển thi nội dung phim
      body: PageView(
        controller: _controller,
        children: const <Widget>[
          MovieScreen(),
          TVsScreen(),
          WatchLists(),
        ],
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      // thanh bottom dưới cùng màn hình
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Style.primaryColor,
        selectedItemColor: Style.secondColor,
        unselectedItemColor: Style.textColor,
        currentIndex:
            _currentIndex, // thác táo tại vị trí đang chọn(đổi màu các thuộc tính)
        onTap: onTapIcon,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Phim"),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: "Truyền Hình"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Xem Tất Cả"),
        ],
      ),
    );
  }

// hàm thao tác vi trí của bottomnavigator
  _buildTitle(int _index) {
    switch (_index) {
      case 0:
        return const Text("Xem Phim");
      case 1:
        return const Text("Truyền Hình");
      case 2:
        return null;
      default:
        return null;
    }
  }
}
