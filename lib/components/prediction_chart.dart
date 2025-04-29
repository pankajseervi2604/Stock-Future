import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class PredictionChart extends StatefulWidget {
  const PredictionChart({super.key, required this.stockName});
  final String stockName;

  @override
  State<PredictionChart> createState() => _PredictionChartState();
}

class _PredictionChartState extends State<PredictionChart> {
  @override
  void initState() {
    super.initState();
    fetchPrediction();
  }

  bool isLoading = true;
  List<StockData> historicalData = [];
  List<StockData> predictedData = [];

  Future<void> fetchPrediction() async {
    try {
      // Pass stock name as a query parameter
      var url = Uri.parse('http://192.168.112.28:8000/predict_week?stock=${widget.stockName}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        List<StockData> loadedHistoricalData = [];
        List<StockData> loadedPredictedData = [];

        // Process historical data
        for (var item in data['historical']) {
          loadedHistoricalData.add(StockData(item['date'], item['price']));
        }

        // Process predicted data
        for (var item in data['prediction']) {
          loadedPredictedData.add(StockData(item['date'], item['price']));
        }

        setState(() {
          historicalData = loadedHistoricalData;
          predictedData = loadedPredictedData;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch prediction');
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              padding: EdgeInsets.symmetric(horizontal: 160, vertical: 188),
              color: Colors.deepPurple,
            ),
          )
        : Column(
            children: [
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enablePanning: true,
                  zoomMode: ZoomMode.x,
                ),
                crosshairBehavior: CrosshairBehavior(
                  enable: true,
                  lineColor: Colors.grey,
                  lineWidth: 0.5,
                  activationMode: ActivationMode.longPress,
                ),
                title: ChartTitle(text: 'Historical Stock Prices (Last Month)'),
                series: <CartesianSeries>[
                  LineSeries<StockData, String>(
                    dataSource: historicalData,
                    xValueMapper: (StockData stock, _) => stock.date,
                    yValueMapper: (StockData stock, _) => stock.price,
                    name: 'Historical Data',
                    color: Colors.deepPurple,
                  ),
                ],
              ),

              SizedBox(height: 20.h),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enablePanning: true,
                  zoomMode: ZoomMode.x,
                ),
                crosshairBehavior: CrosshairBehavior(
                  enable: true,
                  lineColor: Colors.grey,
                  lineWidth: 0.5,
                  activationMode: ActivationMode.longPress,
                ),
                title: ChartTitle(text: 'Predicted Stock Prices (Next Week)'),
                series: <CartesianSeries>[
                  LineSeries<StockData, String>(
                    dataSource: predictedData,
                    xValueMapper: (StockData stock, _) => stock.date,
                    yValueMapper: (StockData stock, _) => stock.price,
                    name: 'Predicted Data',
                    color: Colors.green,
                    dashArray: <double>[10, 5],
                  ),
                ],
              ),
            ],
          );
  }
}

class StockData {
  final String date;
  final double price;

  StockData(this.date, this.price);
}
