import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';

class SyncfusionChartWidget extends StatelessWidget {
  SyncfusionChartWidget({Key? key}) : super(key: key);

  List<LineSeries> lineChart() {
    List<LineSeries> rt = [];
    for (var i = 0; i < ChartCtrl.to.forfields.length; i++) {
      for (var ii = 0; ii < ChartCtrl.to.forfields[i].length; ii++) {
        if (ChartCtrl.to.forfields[i][ii].isNotEmpty) {
          rt.add(lineSeries(ChartCtrl.to.forfields[i][ii]));
        }
      }
    }

    return rt;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(text: 'left chart'),
        // Enable legend
        legend: Legend(isVisible: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: lineChart(),
      );
    });
  }
}

class OESData {
  OESData(this.xVal, this.yVal);

  final dynamic xVal;
  final double yVal;
}

LineSeries<OESData, double> lineSeries(List<OESData> data) {
  return LineSeries<OESData, double>(
    dataSource: data,
    xValueMapper: (OESData oesData, _) => oesData.xVal,
    yValueMapper: (OESData oesData, _) => oesData.yVal,
  );
}
