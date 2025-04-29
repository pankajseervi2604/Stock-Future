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
  final FocusNode _focusNode = FocusNode();
  bool onThemeChanged = false;
  bool _showList = false;
  String? selectedStockName;
  List<String> stockFiles = [
    'python_backend/dataset/stockData/ASIANPAINT.csv',
    'python_backend/dataset/stockData/AXISBANK.csv',
    'python_backend/dataset/stockData/BAJAJ-AUTO.csv',
    'python_backend/dataset/stockData/BAJAJFINSV.csv',
    'python_backend/dataset/stockData/BHARTIARTL.csv',
    'python_backend/dataset/stockData/BPCL.csv',
    'python_backend/dataset/stockData/BRITANNIA.csv',
    'python_backend/dataset/stockData/CIPLA.csv',
    'python_backend/dataset/stockData/COALINDIA.csv',
    'python_backend/dataset/stockData/DRREDDY.csv',
    'python_backend/dataset/stockData/EICHERMOT.csv',
    'python_backend/dataset/stockData/GAIL.csv',
    'python_backend/dataset/stockData/GRASIM.csv',
    'python_backend/dataset/stockData/HCLTECH.csv',
    'python_backend/dataset/stockData/ADANIPORTS.csv',
    'python_backend/dataset/stockData/HDFCBANK.csv',
    'python_backend/dataset/stockData/HEROMOTOCO.csv',
    'python_backend/dataset/stockData/HINDALCO.csv',
    'python_backend/dataset/stockData/HINDUNILVR.csv',
    'python_backend/dataset/stockData/ICICIBANK.csv',
    'python_backend/dataset/stockData/INDUSINDBK.csv',
    'python_backend/dataset/stockData/INFRATEL.csv',
    'python_backend/dataset/stockData/INFY.csv',
    'python_backend/dataset/stockData/IOC.csv',
    'python_backend/dataset/stockData/ITC.csv',
    'python_backend/dataset/stockData/JSWSTEEL.csv',
    'python_backend/dataset/stockData/KOTAKBANK.csv',
    'python_backend/dataset/stockData/LT.csv',
    'python_backend/dataset/stockData/MARUTI.csv',
    'python_backend/dataset/stockData/MM.csv',
    'python_backend/dataset/stockData/NESTLEIND.csv',
    'python_backend/dataset/stockData/NIFTY50_all.csv',
    'python_backend/dataset/stockData/NTPC.csv'
        'python_backend/dataset/stockData/ONGC.csv',
    'python_backend/dataset/stockData/POWERGRID.csv',
    'python_backend/dataset/stockData/RELIANCE.csv',
    'python_backend/dataset/stockData/SBIN.csv',
    'python_backend/dataset/stockData/SHREECEM.csv',
    'python_backend/dataset/stockData/SUNPHARMA.csv',
    'python_backend/dataset/stockData/TATAMOTORS.csv',
    'python_backend/dataset/stockData/TATASTEEL.csv',
    'python_backend/dataset/stockData/TCS.csv',
    'python_backend/dataset/stockData/TECHM.csv',
    'python_backend/dataset/stockData/TITAN.csv',
    'python_backend/dataset/stockData/ULTRACEMCO.csv',
    'python_backend/dataset/stockData/UPL.csv',
    'python_backend/dataset/stockData/VEDL.csv',
    'python_backend/dataset/stockData/WIPRO.csv',
    'python_backend/dataset/stockData/ZEEL.csv',
  ];
  List<String> stockNames = [];

  List<String> filteredstockNames = [];
  @override
  void initState() {
    super.initState();
    stockNames =
        stockFiles.map((file) {
          String name = file.split('/').last.split('.').first;
          return name;
        }).toList();
    filteredstockNames = stockNames;
    _focusNode.addListener(() {
      setState(() {
        _showList = _focusNode.hasFocus;
      });
    });
  }

  void _filterstockNames(String query) {
    final results =
        stockNames
            .where((stock) => stock.toLowerCase().contains(query.toLowerCase()))
            .toList();

    setState(() {
      filteredstockNames = results;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 30.r),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 20.h),
              // textfield
              TextField(
                controller: controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.r),
                      bottomRight: Radius.circular(5.r),
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r),
                    ),
                  ),
                  hintText: "Search NSE stocks",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _filterstockNames,
              ),
              if (_showList)
                Container(
                  height: 250.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.r),
                      bottomRight: Radius.circular(15.r),
                    ),
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Colors.grey,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: filteredstockNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredstockNames[index]),
                        onTap: () {
                          controller.text = filteredstockNames[index];
                          _focusNode.unfocus();
                          setState(() {
                            _showList = false;
                          });
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 30.h),
              // button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50.h),
                  elevation: 2,
                  shadowColor: Colors.white,
                ),
                onPressed: () {
                  final selected = controller.text.trim();
                  if (selected.isNotEmpty) {
                    setState(() {
                      selectedStockName = selected;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select a stock")),
                    );
                  }
                },
                child: Text("Perdict"),
              ),
              SizedBox(height: 40.h),
              // chart
              if (selectedStockName != null)
                SizedBox(
                  height: 670.h,
                  width: double.infinity,
                  child: PredictionChart(
                    key: ValueKey(selectedStockName),
                    stockName: selectedStockName!,
                  ),
                ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
