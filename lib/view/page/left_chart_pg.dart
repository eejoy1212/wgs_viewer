import 'dart:io';

import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/view/widget/left_chart_widget.dart';

class LeftChartPg extends StatelessWidget {
  const LeftChartPg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //left Chat 클릭 하면, left Chart만 보이게 하기.
        Get.find<ChartCtrl>().visibleMode.value = 0;
      },
      onDoubleTap: () {
        //left Chat 더블 클릭 하면, 양쪽 차트 다 보이게 하기.
        Get.find<ChartCtrl>().visibleMode.value = 2;
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 10,
              child: LeftChartWidget(),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (ChartCtrl.to.maxX.value - 6 >
                                ChartCtrl.to.minX.value) {
                              ChartCtrl.to.minX.value += 3;
                              ChartCtrl.to.maxX.value -= 3;
                              print(
                                  '확대minxxxxxxxxxx : ${ChartCtrl.to.minX} max: ${ChartCtrl.to.maxX}');
                            }
                          },
                          child: const Text("+")),
                      const SizedBox(width: 30),
                      ElevatedButton(
                          onPressed: () {
                            if (ChartCtrl.to.minX.value > 0 &&
                                ChartCtrl.to.maxX.value <
                                    ChartCtrl.to.xVal.last / 1000) {
                              ChartCtrl.to.minX.value -= 3;
                              ChartCtrl.to.maxX.value += 3;
                            }
                            if (ChartCtrl.to.maxX.value + 3 ==
                                    ChartCtrl.to.xVal.last / 1000 &&
                                ChartCtrl.to.minX.value > 0) {
                              ChartCtrl.to.minX.value -= 3;
                            }
                            if (ChartCtrl.to.minX.value == 0 &&
                                ChartCtrl.to.maxX.value <
                                    ChartCtrl.to.xVal.last / 1000) {
                              ChartCtrl.to.maxX.value += 3;
                            }
                            if (ChartCtrl.to.maxX.value ==
                                    ChartCtrl.to.xVal.last / 1000 &&
                                ChartCtrl.to.minX.value > 0) {
                              ChartCtrl.to.minX.value -= 3;
                            }
                            print(
                                '축소 minxxxxxxxx : ${ChartCtrl.to.minX} max: ${ChartCtrl.to.maxX}');
                          },
                          child: const Text("-")),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () {
                      DateTime current = DateTime.now();
                      ChartCtrl.to.fileName.value =
                          DateFormat('yyyyMMdd_HHmmss').format(current);
                      exportCSV(name: "TimeBased", data: []);
                    },
                    icon: const Icon(
                      Icons.file_copy_outlined,
                      size: 20,
                    ),
                    label: const Text('Export'),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  LineChartData mainData() {
    final leftMode = ChartCtrl.to.leftMode.value;

    return LineChartData(
      minY: 2300,
      maxY: 2550,
      minX: 0,
      // maxX: 500,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueAccent,
// getTooltipItems: (List<LineBarSpot> touchedBarSpots){

// }
        ),
      ),
      gridData: FlGridData(
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.black12,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.black12,
            strokeWidth: 1,
          );
        },
      ),
      // lineBarsData: [sinLine(),]
    );
  }
}

void exportCSV({required String name, required List<dynamic> data}) async {
  // FilePickerCross myFile = await FilePickerCross.importFromStorage(
  //     type: FileTypeCross.any, fileExtension: 'csv');

  // String? pathForExports = await myFile
  //     .exportToStorage(); // <- will return the file's path on desktops
  Directory('exportfiles').create(recursive: true);
  File file = File("./exportfiles/${ChartCtrl.to.fileName.value}_$name.csv");
  List<dynamic> initData = ["FileFormat : 1", "Save Time : ", "Wavelength : "];
  String all = initData.join('\n') + '\n' + "Time" + '\n' + data.join('\n');

  await file.writeAsString(all);
}
