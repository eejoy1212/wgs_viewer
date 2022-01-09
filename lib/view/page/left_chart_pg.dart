import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:file_selector/file_selector.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';
//import 'package:path_provider_windows/path_provider_windows.dart';

import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () {
                      DateTime current = DateTime.now();
                      ChartCtrl.to.fileName.value =
                          DateFormat('yyyyMMdd_HHmmss').format(current);
                      exportCSV("TimeBased");
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
    return LineChartData(
      minY: 2300,
      maxY: 2550,
      minX: 0,
      maxX: 500,
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

void init() async {}

void exportCSV(String name, [List<dynamic> data = const []]) async {
  String? _path = '';
  _path = await FilePicker.platform.saveFile(
      //type: FileType.custom,
      fileName: '제목 없음.csv',
      allowedExtensions: ['csv'],
      dialogTitle: 'File select');
  if (_path != '') {
    print('_path $_path');
  }

  final List<List<double>> fileData = [];
  //해더는 따로돌고

  for (var i = 0; i < TimeSelectCtrl.to.timeIdxList.length; i++) {
    fileData.add([]);
    fileData[i].add(TimeSelectCtrl.to.timeIdxList[i]);
    int idx = 0;
    for (var ii = 0; ii < ChartCtrl.to.forfields.length; ii++) {
      if (CheckboxCtrl.to.ckb[i].isChecked.value == false) continue;

      for (var iii = 0; iii < ChartCtrl.to.forfields[ii].length; iii++) {
        if (ChartCtrl.to.forfields[idx][iii].isNotEmpty)
          fileData[i].add(ChartCtrl.to.forfields[idx][iii][i].y);
      }
      idx++;
    }
  }
  debugPrint('fileData $fileData');
  //시간별로 돌아
  //파일별로돌고
  //파장별로 돌아

  final List<List<double>> list = [];
  int timeLen = 0;
  int sidx = 0;
  for (int i = 0; i < ChartCtrl.to.forfields.length; i++) {
    final series = ChartCtrl.to.forfields[i];
    debugPrint('series : $series');
    if (series.isNotEmpty) {
      final int len = series[0].length;
      if (timeLen < len) {
        timeLen = len;
        sidx = i;
      }
    }
  }

  for (var t = 0; t < timeLen; t++) {
    list.add([ChartCtrl.to.forfields[sidx][0][t].x]);
    for (var i = 0; i < ChartCtrl.to.forfields.length; i++) {
      if (ChartCtrl.to.forfields[i].isNotEmpty) {
        list[t].add(ChartCtrl.to.forfields[i][0][t].y);
      }
    }
  }

  debugPrint("EXPORT LIST" + list.toString());
  File file = File("$_path");
  List<dynamic> initData = ["FileFormat : 1", "Save Time : ", "Wavelength : "];

  String all = initData.join('\n') +
      '\n' +
      "Time" +
      '\n' +
      fileData.map((line) => line.join(",")).join('\n');
  debugPrint('export');
  file.writeAsString(all);
}
