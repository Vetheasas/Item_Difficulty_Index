import 'package:flutter/material.dart';
import 'package:item_performance/Screen/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:item_performance/Data/list_data.dart';
import 'package:item_performance/Data/load_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListData>(create: (context) => ListData()),
        ChangeNotifierProvider<LoadData>(create: (context) => LoadData())
      ],
      child: MaterialApp(
        title: 'Item Difficulty Index',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF9792bd),
          secondary: Color(0xFF9792bd),
        )),
        home: SplashPage(),
      ),
    );
  }
}
