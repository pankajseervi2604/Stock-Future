import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PredictionChart extends StatelessWidget {
  const PredictionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
        zoomMode: ZoomMode.x,
      ),
      crosshairBehavior: CrosshairBehavior(
        enable: true,
        lineColor: Colors.grey,
        lineWidth: 0.1,
        activationMode: ActivationMode.longPress,
      ),
      series: [
        FastLineSeries<SalesData, String>(
          color: Colors.yellow,
          dataSource: <SalesData>[
            SalesData('Jan', 6),
            SalesData('Feb', 53),
            SalesData('Mar', 25),
            SalesData('Apr', 65),
            SalesData('May', 44),
            SalesData('Jun', 86),
            SalesData('Jul', 69),
            SalesData('Aug', 3),
            SalesData('Sep', 40),
            SalesData('Oct', 75),
            SalesData('Nov', 32),
            SalesData('Dec', 90),
          ],
          xValueMapper: (SalesData sales, context) => sales.year,
          yValueMapper: (SalesData sales, context) => sales.sales,
        ),
        LineSeries<SalesData, String>(
          color: Colors.deepPurple,
          dataSource: <SalesData>[
            SalesData('Jan', 5),
            SalesData('Feb', 15),
            SalesData('Mar', 20),
            SalesData('Apr', 28),
            SalesData('May', 2),
            SalesData('Jun', 20),
            SalesData('Jul', 10),
            SalesData('Aug', 35),
            SalesData('Sep', 12),
            SalesData('Oct', 40),
            SalesData('Nov', 30),
            SalesData('Dec', 7),
          ],
          xValueMapper: (SalesData sales, context) => sales.year,
          yValueMapper: (SalesData sales, context) => sales.sales,
        ),
      ],
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
