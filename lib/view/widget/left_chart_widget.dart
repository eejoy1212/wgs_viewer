import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'dart:math' as math;

class LeftChartWidget extends StatelessWidget {
  bool showAvg = false;
  int seriesIdx = 0;
  List xAxis = [];

  // List<LineChartBarData> lineChartBarDatas() {
  //   List<LineChartBarData> rt = [];
  //   for (var i = 0; i < ChartCtrl.to.forfields.length; i++) {
  //     for (var ii = 0; ii < ChartCtrl.to.forfields[i].length; ii++) {
  //       if (ChartCtrl.to.forfields[i][ii].isNotEmpty) {
  //         rt.add(
  //           lineChartBarData(
  //               ChartCtrl.to.forfields[i][ii],
  //               // Colors.green,
  //               Colors.cyan[700]),
  //         );
  //       }
  //     }
  //   }

  //   return rt;
  // }

  @override
  Widget build(BuildContext context) {
    ChartCtrl.to.minX.value = TimeSelectCtrl.to.timeIdxList.isNotEmpty
        ? TimeSelectCtrl.to.timeIdxList.first
        : 1;
    ChartCtrl.to.maxX.value = TimeSelectCtrl.to.timeIdxList.isNotEmpty
        ? TimeSelectCtrl.to.timeIdxList.last
        : 90;
    return Stack(children: [
      GetBuilder<ChartCtrl>(
          builder: (ctrl) => Obx(() => ChartCtrl.to.zoomFunction(
              child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18),
                      ),
                      color: Colors.transparent),
                  child: Padding(
                      padding: const EdgeInsets.only(
                        right: 18.0,
                        left: 12.0,
                        top: 24,
                        bottom: 12,
                      ),
                      child: leftData(
                        rangeAnnotations: RangeAnnotations(
                            verticalRangeAnnotations:
                                RangeSliderCtrl.to.verticalRA()),
                        ctrl: ctrl,
                        lineBarsData: [
                          lineChartBarData(
                              [const FlSpot(0, 0)], Colors.transparent)
                        ]

                        // lineChartBarDatas(),
                        ,
                        leftTitles: SideTitles(
                          showTitles: false,
                          getTextStyles: (bctx, dbl) => const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          reservedSize: 10,
                          margin: 12,
                        ),
                      ))))))
    ]);
  }

  LineChart leftData({
    required ChartCtrl ctrl,
    required List<LineChartBarData> lineBarsData,
    SideTitles? leftTitles,
    SideTitles? bottomTitles,
    RangeAnnotations? rangeAnnotations,
  }) {
    return LineChart(
      LineChartData(
          minY: FilePickerCtrl.to.oesFD.isEmpty ? 0 : null,
          maxY: FilePickerCtrl.to.oesFD.isEmpty ? 1000 : null,
          minX: ChartCtrl.to.minX.value,
          maxX: ChartCtrl.to.maxX.value,
          // minX: ChartCtrl.to.leftDataMode.isFalse ? 0 : null,
          // maxX: ChartCtrl.to.leftDataMode.isFalse ? 50 : null,
          rangeAnnotations: RangeAnnotations(
              verticalRangeAnnotations: RangeSliderCtrl.to.verticalRA()),
          lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
          )),
          clipData: FlClipData.all(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: bottomTitles,
            leftTitles: leftTitles,
            topTitles: SideTitles(
              showTitles: false,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.blueGrey,
              width: 1,
            ),
          ),
          lineBarsData: lineBarsData),
      swapAnimationDuration: Duration.zero,
      //데이터 all side로 만듦 x축 y축 둘다 만든다는 소리..?
    );
  }

  LineChartBarData lineChartBarData(List<FlSpot> points, color) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: true,
      ),
      colors: [color],
      barWidth: 1,
    );
  }
}
