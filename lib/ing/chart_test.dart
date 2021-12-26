import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/chart_ctrl.dart';
import 'dart:math' as math;

import 'package:wgs_viewer/main.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({Key? key}) : super(key: key);

  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

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
                          right: 18.0, left: 12.0, top: 24, bottom: 12),
                      child: leftData(
                        ctrl: ctrl,
                        lineBarsData: [
                          lineChartBarData(
                            ctrl.leftChartData[0],
                            Colors.amber,
                          ),
                          lineChartBarData(
                            ctrl.leftChartData[1],
                            Colors.red,
                          ),
                          lineChartBarData(
                            ctrl.leftChartData[2],
                            Colors.blue,
                          ),
                          lineChartBarData(
                            ctrl.leftChartData[3],
                            Colors.orange,
                          ),
                          lineChartBarData(
                            ctrl.leftChartData[4],
                            Colors.purple,
                          ),
                          lineChartBarData(
                            ctrl.leftChartData[5],
                            Colors.amberAccent,
                          ),
                          lineChartBarData(
                            ctrl.leftChartData[6],
                            Colors.blueGrey,
                          ),
                          lineChartBarData(
                            ctrl.leftChartData[7],
                            Colors.greenAccent,
                          ),
                          lineChartBarData(
                            ctrl.leftChartData[8],
                            Colors.black,
                          ),
                          lineChartBarData(
                            ctrl.leftChartData[9],
                            Colors.pinkAccent,
                          ),
                        ],
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTextStyles: (bctx, dbl) => const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          getTitles: (val) {
                            return '${val.round()}';
                          },
                          margin: 8,
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (bctx, dbl) => const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          getTitles: (val) {
                            switch (val.toInt()) {
                              case 0:
                                return '10k';
                              case 250:
                                return '30k';
                              case 500:
                                return '50k';
                            }
                            return '';
                          },
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
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
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
          minX: 180,
          maxX: 800,
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
              topTitles: SideTitles(showTitles: true),
              rightTitles: SideTitles(showTitles: true)),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.red, width: 1),
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
        show: false,
      ),
      colors: [color],
      barWidth: 1,
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
          interval: 1,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 32,
          interval: 1,
          margin: 12,
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!,
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!,
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!
                .withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1])
                .lerp(0.2)!
                .withOpacity(0.1),
          ]),
        ),
      ],
    );
  }
}
