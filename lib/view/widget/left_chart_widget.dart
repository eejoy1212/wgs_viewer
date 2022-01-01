import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';

class LeftChartWidget extends StatelessWidget {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    List<FlSpot> aa = [FlSpot(0, 1), FlSpot(2, 3)];
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
                      child: leftData(
                        ctrl: ctrl,
                        lineBarsData: [
                          if (ctrl.forfields[0].isNotEmpty)
                            lineChartBarData(
                              ctrl.forfields[0],
                              Colors.green,
                            ),
                          if (ctrl.forfields[0].isNotEmpty)
                            lineChartBarData(
                              ctrl.forfields[1],
                              Colors.red,
                            ),
                          if (ctrl.forfields[0].isNotEmpty)
                            lineChartBarData(
                              ctrl.forfields[2],
                              Colors.purple,
                            ),
                          if (ctrl.forfields[0].isNotEmpty)
                            lineChartBarData(
                              ctrl.forfields[3],
                              Colors.blueAccent,
                            )
                        ],
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTextStyles: (bctx, dbl) => const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          margin: 8,
                        ),
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
                      ),
                    ),
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
  }) {
    return LineChart(
      LineChartData(
          minY: -50000,
          maxY: 150000,
          minX: 0,
          maxX: 6,
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
              // getTitles: (value) {
              // switch (value.toInt()) {
              // case 0:
              // return '2300';
              // case 100:
              // return '2300';
              // case 2400:
              // return '2400';
              // case 2450:
              // return '2450';
              // case 2500:
              // return '2450';
              // case 2550:
              // return '2450';
              // }
              // return '??';
              // },
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.red,
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
