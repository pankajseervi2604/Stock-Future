import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class PredictionChart extends StatefulWidget {
  const PredictionChart({super.key});

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
      var url = Uri.parse(
        'http://192.168.112.28:8000/predict_week',
      ); // Update with your IP address
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        List<StockData> loadedHistoricalData = [];
        List<StockData> loadedPredictedData = [];

        for (var item in data) {
          loadedHistoricalData.add(StockData(item['date'], item['price']));
        }

        // Simulate predicted data for the next week
        DateTime lastDate = DateTime.parse(loadedHistoricalData.last.date);
        for (int i = 1; i <= 7; i++) {
          DateTime predictedDate = lastDate.add(Duration(days: i));
          double predictedPrice =
              loadedHistoricalData.last.price +
              (i * 0.02); // Simulate a slight increase
          loadedPredictedData.add(
            StockData(
              predictedDate.toIso8601String().split('T')[0],
              predictedPrice,
            ),
          );
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
            // Historical Data Chart
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
                  dashArray: <double>[10, 5], // Dashed line for predictions
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
