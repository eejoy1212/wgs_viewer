import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';

class LeftChartWidget extends StatelessWidget {
  bool showAvg = false;
  int seriesIdx = 0;
  List xAxis = [];

  List<LineChartBarData> lineChartBarDatas() {
    List<LineChartBarData> rt = [];
    for (var i = 0; i < ChartCtrl.to.forfields.length; i++) {
      for (var ii = 0; ii < ChartCtrl.to.forfields[i].length; ii++) {
        if (ChartCtrl.to.forfields[i][ii].isNotEmpty) {
          rt.add(
            lineChartBarData(
              ChartCtrl.to.forfields[i][ii],
              Colors.green,
            ),
          );
        }
      }
    }

    return rt;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GetBuilder<ChartCtrl>(
            builder: (ctrl) => InteractiveViewer(
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
                        child: Obx(() {
                          return leftData(
                            rangeAnnotations: RangeAnnotations(
                                verticalRangeAnnotations:
                                    RangeSliderCtrl.to.verticalRA()),
                            ctrl: ctrl,
                            lineBarsData: lineChartBarDatas(),
                            // bottomTitles: SideTitles(
                            //   // getTitles: (val) {
                            //   //   switch (val.toInt()) {
                            //   //     case 0:
                            //   //       return '0';
                            //   //     case 17000:
                            //   //       return '1.7';
                            //   //     case 34000:
                            //   //       return '3.4';
                            //   //   }
                            //   //   return '';
                            //   // },
                            //   showTitles: true,
                            //   reservedSize: 20,
                            //   getTextStyles: (bctx, dbl) => const TextStyle(
                            //     color: Colors.blueGrey,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 16,
                            //   ),
                            //   margin: 8,
                            // ),
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
                          );
                        })),
                  ),
                )),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'avg',
              style: TextStyle(
                  fontSize: 12,
                  color:
                      showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
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
          minY: ChartCtrl.to.leftDataMode.isFalse ? 0 : null,
          maxY: ChartCtrl.to.leftDataMode.isFalse ? 1000 : null,
          minX: ChartCtrl.to.leftDataMode.isFalse ? 0 : null,
          maxX: ChartCtrl.to.leftDataMode.isFalse ? 50 : null,
          // minY: 0,
          // maxY: 1300,
          // minX: -1,
          // maxX: 1,
          // ChartCtrl.to.xValLast,
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
