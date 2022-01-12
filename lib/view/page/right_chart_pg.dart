import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';
import 'package:wgs_viewer/view/widget/right_chart_widget.dart';

class RightChartPg extends StatelessWidget {
  const RightChartPg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //right Chat 클릭 하면, right Chart만 보이게 하기.
        Get.find<ChartCtrl>().visibleMode.value = 1;
      },
      onDoubleTap: () {
        //right Chat 더블 클릭 하면, 양쪽 차트 다 보이게 하기.
        Get.find<ChartCtrl>().visibleMode.value = 2;
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 10,
              child: RightChartWidget(),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    return SizedBox(
                        width: 30,
                        child: IgnorePointer(
                          ignoring: FilePickerCtrl.to.xTimes.isEmpty,
                          child: FloatingActionButton(
                              backgroundColor: FilePickerCtrl.to.xTimes.isEmpty
                                  ? Colors.grey
                                  : Colors.blue,
                              onPressed: () {
                                if (RightChartCtrl.to.maxX.value - 6 >
                                    RightChartCtrl.to.minX.value) {
                                  RightChartCtrl.to.minX.value += 3;
                                  RightChartCtrl.to.maxX.value -= 3;
                                }
                              },
                              child: const Text("+")),
                        ));
                  }),
                  const SizedBox(width: 30),
                  Obx(() {
                    return SizedBox(
                        width: 30,
                        child: IgnorePointer(
                          ignoring: FilePickerCtrl.to.xTimes.isEmpty,
                          child: FloatingActionButton(
                              backgroundColor: FilePickerCtrl.to.xTimes.isEmpty
                                  ? Colors.grey
                                  : Colors.blue,
                              onPressed: () {
                                if (RightChartCtrl.to.minX.value >
                                    FilePickerCtrl.to.xTimes.first) {
                                  RightChartCtrl.to.minX.value -= 3;
                                  RightChartCtrl.to.maxX.value += 3;
                                }
                                if (RightChartCtrl.to.minX.value <
                                    FilePickerCtrl.to.xTimes.first) {
                                  RightChartCtrl.to.minX.value =
                                      FilePickerCtrl.to.xTimes.first;
                                }
                              },
                              child: const Text("-")),
                        ));
                  }),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () {
                      DateTime current = DateTime.now();
                      ChartCtrl.to.fileName.value =
                          DateFormat('yyyyMMdd_HHmmss').format(current);
                      rightExportCSV("Wavelength");
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
          ],
        ),
      ),
    );
  }
}

void rightExportCSV(String name, [List<dynamic> data = const []]) async {
  final List<List<double>> list = [];
  int timeLen = 0;
  int sidx = 0;
  for (int i = 0; i < ChartCtrl.to.forfields.length; i++) {
    final series = ChartCtrl.to.forfields[i];
    if (series.isNotEmpty) {
      final int len = series[0].length;
      if (timeLen < len) {
        timeLen = len;
        sidx = i;
      }
    }
  }

  final directory = await getApplicationDocumentsDirectory();
  FilePickerCtrl.to.path.value = directory.path;
  File file = File(
      "${FilePickerCtrl.to.path.value}/${ChartCtrl.to.fileName.value}_$name.csv");
  List<dynamic> initData = ["FileFormat : 1", "Save Time : ", "Wavelength : "];

  String all = initData.join('\n') +
      '\n' +
      "Time" +
      '\n' +
      list.map((line) => line.join(",")).join('\n');
  file.writeAsString(all);
}
