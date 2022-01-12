import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';
import 'package:wgs_viewer/view/widget/left_chart_widget.dart';

class RightChartWidget extends StatelessWidget {
  bool showAvg = false;
  double? minY = FilePickerCtrl.to.xTimes.isNotEmpty ? 0 : 0;
  double? maxY = FilePickerCtrl.to.xTimes.isNotEmpty ? 10000 : 0;
  // double maxY = ;

  @override
  Widget build(BuildContext context) {
    RightChartCtrl.to.minX.value = FilePickerCtrl.to.xTimes.isNotEmpty
        ? FilePickerCtrl.to.xTimes.first
        : 180;
    RightChartCtrl.to.maxX.value = FilePickerCtrl.to.xTimes.isNotEmpty
        ? FilePickerCtrl.to.xTimes.last
        : 870;
    return Stack(
      children: [
        GetBuilder<FileSelectDropDownCtrl>(
            builder: (ctrl) => Obx(() {
                  return RightChartCtrl.to.zoomFunction(
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
                          child: rightData(
                            ctrl: ctrl,
                            lineBarsData: [
                              // lineChartBarData(
                              //   RightChartCtrl.to.rightSeriesData[0],
                              //   Color.fromARGB(255, 106, 141, 137),
                              // ),
                              // lineChartBarData(
                              //   RightChartCtrl.to.rightSeriesData[1],
                              //   Colors.indigo,
                              // )

                              // rightLineSeries(RightChartCtrl.to.rightSeriesData[0])
                            ],
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
                          )),
                    ),
                  );
                }))
      ],
    );
  }

  LineChart rightData({
    required FileSelectDropDownCtrl ctrl,
    required List<LineChartBarData> lineBarsData,
    SideTitles? leftTitles,
    SideTitles? bottomTitles,
  }) {
    return LineChart(
      LineChartData(
          minY: 0,
          maxY: 10000,
          minX: RightChartCtrl.to.minX.value,
          maxX: RightChartCtrl.to.maxX.value,
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
            rightTitles: SideTitles(
              showTitles: true,
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

  LineSeries rightLineSeries(List<OESData> data) {
    return LineSeries<OESData, double>(
      dataSource: data,
      xValueMapper: (OESData oesData, _) => oesData.xVal,
      yValueMapper: (OESData oesData, _) => oesData.yVal,
    );
  }
}
