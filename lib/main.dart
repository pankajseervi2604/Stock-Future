import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stock_future/pages/home_page.dart';
import 'package:stock_future/provider/theme_provider.dart';

void main(List<String> args) {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: Size(screenWidth, screenHeight),
      minTextAdapt: true,
      builder:
          (context, child) => Consumer<ThemeProvider>(
            builder:
                (context, value, child) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  themeAnimationStyle: AnimationStyle(
                    curve: Curves.linear,
                    reverseCurve: Curves.ease,
                    duration: Duration(milliseconds: 350),
                  ),
                  theme: ThemeData.light(),
                  darkTheme: ThemeData.dark(),
                  themeMode: value.themeMode,
                  home: HomePage(),
                ),
          ),
    );
  }
}
