import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/view/widget/left_chart_widget.dart';

class ChartCtrl extends GetxController {
  static ChartCtrl get to => Get.find();
  /*visible mode == 0 ->left chart
  visible mode == 1 ->right chart
  visible mode == 2 ->all chart
  */
  RxInt visibleMode = 2.obs;
  RxBool leftDataMode = false.obs;
  RxList<RxList<List<WGSspot>>> forfields = RxList.empty();
  RxBool enableApply = false.obs;
  RxDouble value = 0.0.obs;
  RxDouble sum = 0.0.obs;
  // RxDouble avg = 0.0.obs;
  RxInt Idx = 0.obs;
  //레인지 슬라이더 변수
  RxList xVal = RxList.empty();
  RxString fileName = ''.obs;

  RxDouble minX = 0.0.obs;
  RxDouble maxX = 0.0.obs;

  void init() {}

  Future<void> updateLeftData() async {
    if (FilePickerCtrl.to.oesFD.isNotEmpty) {
      forfields.clear();
      for (int s = 0; s < FilePickerCtrl.to.oesFD.length; s++) {
        forfields.add(RxList.empty());
        if (FilePickerCtrl.to.oesFD[s].isChecked.value == false) continue;
        var filePath =
            FilePickerCtrl.to.oesFD.map((el) => el.filePath).toList();
        final input = await File(filePath[s]!).openRead();

        var d = const FirstOccurrenceSettingsDetector(
            eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
        FilePickerCtrl.to.oesFD[s].fileData = await input
            .transform(utf8.decoder)
            .transform(CsvToListConverter(csvSettingsDetector: d))
            .toList();
        int headRowSize = FilePickerCtrl.to.oesFD[s].fileData
                .indexWhere((element) => element.contains('Time')) +
            1;
        for (int a = headRowSize;
            a < FilePickerCtrl.to.oesFD[s].fileData.length;
            a++) {
          Idx.value = a - headRowSize;
          FilePickerCtrl.to.oesFD[s].avg.clear();

          for (var ii = 0; ii < 5; ii++) {
            forfields[s].add([]);
            int cnt = RangeSliderCtrl.to.rsWGS[ii].rv.value.end.toInt() -
                RangeSliderCtrl.to.rsWGS[ii].rv.value.start.toInt() +
                1;
            sum.value = 0.0;
            int inc = 0;
            for (int i = 0; i < cnt; i++) {
              if (FilePickerCtrl.to.oesFD[s].fileData[a].length > i) {
                sum.value += FilePickerCtrl.to.oesFD[s].fileData[a][
                    RangeSliderCtrl.to.rsWGS[ii].rv.value.start.toInt() +
                        i +
                        1];
                inc++;
              }
            }
            // avg.value = sum.value / inc;
            // double avg = 0.0;
            // avg += sum.value / inc;
            FilePickerCtrl.to.oesFD[s].avg.add(sum.value / inc);

            if (TimeSelectCtrl.to.timeIdxList.length > Idx.value) {
              forfields[s][ii].add(WGSspot(
                  TimeSelectCtrl.to.timeIdxList[Idx.value],
                  FilePickerCtrl.to.oesFD[s].avg[ii]));
            }
          }
        }
      }
    } else {}
    update();
    for (var ii = 0; ii < FilePickerCtrl.to.oesFD.length; ii++) {
      for (var iii = 0; iii < FilePickerCtrl.to.oesFD[ii].avg.length; iii++) {
        debugPrint('apply ${FilePickerCtrl.to.oesFD[ii].avg[iii]}');
      }
    }
  }
}
