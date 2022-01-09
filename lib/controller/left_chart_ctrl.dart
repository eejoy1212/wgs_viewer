import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/check_box_ctrl.dart';

import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';

class ChartCtrl extends GetxController {
  static ChartCtrl get to => Get.find();
  /*visible mode == 0 ->left chart
  visible mode == 1 ->right chart
  visible mode == 2 ->all chart
  */
  RxInt visibleMode = 2.obs;
  // RxInt seriesCnt = 150.obs;
  RxBool leftDataMode = false.obs;
  RxList<RxList<List<FlSpot>>> forfields = RxList.empty();
  RxBool enableApply = false.obs;
  RxDouble value = 0.0.obs;
  // List<double> rangeList = RxList.empty();
  // List<RangeValue> rv = [];
  RxDouble sum = 0.0.obs;
  RxDouble avg = 0.0.obs;
  RxInt Idx = 0.obs;
  //레인지 슬라이더 변수
  RxList xVal = RxList.empty();
  RxString fileName = ''.obs;

  void init() {
    // for (var i = 0; i < ChartCtrl.to.seriesCnt.value; i++) {
    //   rv.add(RangeValue(start: 0.0, end: 0.0, tableX: []));
    // }
    for (var i = 1; i < 2048; i++) {
      // RangeSliderCtrl.to.minMaxList.add([]);
    }
  }

  Future<void> updateLeftData() async {
    //레인지에 쓸거
    //firstLine.assignAll(fields[6].sublist(1, fields[6].length));
    //시간축 떼어오기
    //timeLine.assignAll(fields[0].sublist(7, fields[7].length)[0]);

    if (leftDataMode.value == true) {
      //seriesCnt==5(파장 레인지 갯수)*10(파일갯수)
      forfields.clear();
      for (int s = 0; s < FilePickerCtrl.to.selectedFileUrls.length; s++) {
        forfields.add(RxList.empty());
        if (CheckboxCtrl.to.ckb[s].isChecked.value == false) continue;
        List<List<dynamic>> fileData = [];
        final input2 =
            await File(FilePickerCtrl.to.selectedFileUrls[s]!).openRead();
        var d = const FirstOccurrenceSettingsDetector(
            eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
        fileData = await input2
            .transform(utf8.decoder)
            .transform(CsvToListConverter(csvSettingsDetector: d))
            .toList();

        const int headRowSize = 7;
        for (int a = headRowSize; a < fileData.length; a++) {
          Idx.value = a - headRowSize;

          //처음 파일기준 인덱스 떼어올 것.

          for (var ii = 0; ii < 5; ii++) {
            forfields[s].add([]);
            int cnt = RangeSliderCtrl.to.currentRv[ii].end.toInt() -
                RangeSliderCtrl.to.currentRv[ii].start.toInt() +
                1;
            sum.value = 0.0;
            int inc = 0;
            for (int i = 0; i < cnt; i++) {
              if (fileData[a].length > i) {
                sum.value += fileData[a]
                    [RangeSliderCtrl.to.currentRv[ii].start.toInt() + i + 1];
                inc++;
              }
            }
            avg.value = sum.value / inc;
            if (TimeSelectCtrl.to.timeIdxList.length > Idx.value) {
              forfields[s][ii].add(
                  FlSpot(TimeSelectCtrl.to.timeIdxList[Idx.value], avg.value));
              debugPrint('nnn forfields :  $forfields');
            }
            debugPrint('forfields ${forfields[s][ii]}');
          }

          // forfields.clear();

        }
      }
    } else {}
    //데이터 업데이트 하고나서 Apply 버튼 누를 수 있게.
    ChartCtrl.to.enableApply.value = true;
    update();
  }
}
