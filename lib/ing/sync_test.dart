import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chart Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: SfCartesianChart(
            onDataLabelTapped: (onTapArgs) {
              debugPrint('tap point idx : ${onTapArgs.pointIndex}');

              debugPrint('tap text : ${onTapArgs.text}');
            },
            onLegendItemRender: (arg) {
              debugPrint('arg series Index : ${arg.text}');

              arg.text;
            },
            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(text: 'Half yearly sales analysis'),
            // Enable legend
            legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries<_SalesData, String>>[
              LineSeries<_SalesData, String>(
                  dataSource: <_SalesData>[
                    _SalesData('Jan', 35),
                    _SalesData('Feb', 28),
                    _SalesData('Mar', 34),
                    _SalesData('Apr', 32),
                    _SalesData('May', 40)
                  ],
                  xValueMapper: (_SalesData sales, _) => sales.year,
                  yValueMapper: (_SalesData sales, _) => sales.sales,
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true)),
              LineSeries<_SalesData, String>(
                  dataSource: <_SalesData>[
                    _SalesData('Jan_1', 35),
                    _SalesData('Feb_1', 28),
                    _SalesData('Mar_1', 34),
                    _SalesData('Apr_1', 32),
                    _SalesData('May_1', 40)
                  ],
                  xValueMapper: (_SalesData sales, _) => sales.year,
                  yValueMapper: (_SalesData sales, _) => sales.sales,
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true))
            ]));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
