import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';

class RightChartWidget extends StatelessWidget {
  RightChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      RxList<LineSeries> rightLineChart() {
        RxList<LineSeries> rt = RxList.empty();
        for (var i = 0; i < 2; i++) {
          rt.add(rightLineSeries(RightChartCtrl.to.rightSeriesData[i]));
        }
        return rt;
      }

      return SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(
          enableDoubleTapZooming: true,
          enableMouseWheelZooming: true,
          enablePanning: true,
          enablePinching: true,
          enableSelectionZooming: true,
        ),
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(text: 'right chart'),
        // Enable legend
        legend: Legend(isVisible: true, toggleSeriesVisibility: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: rightLineChart(),
      );
    });
  }
}

class OESData {
  OESData(this.xVal, this.yVal);

  final dynamic xVal;
  final double yVal;
}

LineSeries<OESData, double> rightLineSeries(List<OESData> data) {
  return LineSeries<OESData, double>(
    dataSource: data,
    xValueMapper: (OESData oesData, _) => oesData.xVal,
    yValueMapper: (OESData oesData, _) => oesData.yVal,
  );
}
