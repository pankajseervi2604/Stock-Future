import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stock_future/components/prediction_chart.dart';
import 'package:stock_future/provider/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  bool onThemeChanged = false;
  Future<void> _refreshItems() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        elevation: 2,
        title: Text(
          "Stock Price Prediction",
          textScaler: TextScaler.linear(0.8),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.r),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  onThemeChanged = !onThemeChanged;
                });
                themeProvider.themeChanged();
              },
              child:
                  onThemeChanged
                      ? Icon(Icons.dark_mode_outlined)
                      : Icon(Icons.wb_sunny_outlined),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        autofocus: true,
        tooltip: "AI bot",
        child: Icon(Icons.chat_outlined),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshItems,
        displacement: 1,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 30.r),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 40.h),
                // textfield
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    hintText: "Search Nifty Stocks",
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                SizedBox(height: 30.h),
                // button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50.h),
                  ),
                  onPressed: () {},
                  child: Text("Perdict"),
                ),
                SizedBox(height: 40.h),
                // chart
                SizedBox(
                  height: 400.h,
                  width: double.infinity,
                  child: PredictionChart(),
                ),
                SizedBox(height: 90.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
