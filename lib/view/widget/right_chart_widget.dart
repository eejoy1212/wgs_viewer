import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';

class RightChartWidget extends StatelessWidget {
  RightChartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SfCartesianChart(
        enableAxisAnimation: false,
        zoomPanBehavior: RightChartCtrl.to.zoomPan.value,
        onLegendItemRender: (item) {
          int seriesNum = item.seriesIndex! + 1;
          item.text = 'Series $seriesNum';
        },
        primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(text: 'chart 2'),
        // Enable legend
        legend: Legend(isVisible: true, toggleSeriesVisibility: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          LineSeries<OESData, int>(
            dataSource: RightChartCtrl.to.rightSeriesData[0],
            color: RangeSliderCtrl.to.pbColor1.value,
            xValueMapper: (OESData oesData, _) => oesData.xVal.toInt(),
            yValueMapper: (OESData oesData, _) => oesData.yVal,
          ),
          LineSeries<OESData, int>(
            dataSource: RightChartCtrl.to.rightSeriesData[1],
            color: RangeSliderCtrl.to.pbColor2.value,
            xValueMapper: (OESData oesData, _) => oesData.xVal.toInt(),
            yValueMapper: (OESData oesData, _) => oesData.yVal,
          ),
        ],
      );
    });
  }
}

class OESData {
  OESData(this.xVal, this.yVal);

  final int xVal;
  final int yVal;
}

// LineSeries<OESData, double> rightLineSeries(List<OESData> data) {
//   return LineSeries<OESData, double>(
//     dataSource: data,
//     color: lineIdx == 2
//         ? RangeSliderCtrl.to.pbColor1.value
//         : RangeSliderCtrl.to.pbColor2.value,
//     xValueMapper: (OESData oesData, _) => oesData.xVal,
//     yValueMapper: (OESData oesData, _) => oesData.yVal,
//   );
// }
