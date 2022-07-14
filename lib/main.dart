import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/constant/style.dart';
import 'package:movieapp/model/hive_movie_model.dart';
import 'package:movieapp/model/hive_tv_model.dart';
import 'package:movieapp/screens/home_screen.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  Hive.registerAdapter(HiveMovieModelAdapter());
  Hive.registerAdapter(HiveTVModelAdapter());
  await Hive.openBox<HiveMovieModel>('movie_list');
  await Hive.openBox<HiveTVModel>('tv_list');

  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Style.primaryColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Style.primaryColor,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
