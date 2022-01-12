import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'dart:math' as math;
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
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
  // RxList<RxList<List<FlSpot>>> forfields = RxList.empty();
  RxList<RxList<List<OESData>>> forfields = RxList.empty();

  RxBool enableApply = false.obs;
  RxDouble value = 0.0.obs;
  RxDouble sum = 0.0.obs;
  RxDouble avg = 0.0.obs;
  RxInt Idx = 0.obs;
  //레인지 슬라이더 변수
  RxList xVal = RxList.empty();
  RxString fileName = ''.obs;

  RxDouble minX = 0.0.obs;
  RxDouble maxX = 0.0.obs;

  void init() {}

  Future<void> updateLeftData() async {
    if (FilePickerCtrl.to.oesFD.isNotEmpty) {
      //seriesCnt==5(파장 레인지 갯수)*10(파일갯수)
      forfields.clear();
      // for (int s = 0; s < FilePickerCtrl.to.selectedFileUrls.length; s++) {
      for (int s = 0; s < FilePickerCtrl.to.oesFD.length; s++) {
        forfields.add(RxList.empty());
        // if (CheckboxCtrl.to.ckb[s].isChecked.value == false) continue;
        if (FilePickerCtrl.to.oesFD[s].isChecked.value == false) continue;
        //List<List<dynamic>> fileData = [];
        var filePath =
            FilePickerCtrl.to.oesFD.map((el) => el.filePath).toList();
        // final input =
        //     await File(FilePickerCtrl.to.selectedFileUrls[s]!).openRead();
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

          //처음 파일기준 인덱스 떼어올 것.

          for (var ii = 0; ii < 5; ii++) {
            forfields[s].add([]);
            int cnt = RangeSliderCtrl.to.currentRv[ii].end.toInt() -
                RangeSliderCtrl.to.currentRv[ii].start.toInt() +
                1;
            sum.value = 0.0;
            int inc = 0;
            for (int i = 0; i < cnt; i++) {
              if (FilePickerCtrl.to.oesFD[s].fileData[a].length > i) {
                sum.value += FilePickerCtrl.to.oesFD[s].fileData[a]
                    [RangeSliderCtrl.to.currentRv[ii].start.toInt() + i + 1];
                inc++;
              }
            }
            avg.value = sum.value / inc;
            if (TimeSelectCtrl.to.timeIdxList.length > Idx.value) {
              // oesModel에 avg추가
              // forfields[s][ii].add(
              //     FlSpot(TimeSelectCtrl.to.timeIdxList[Idx.value], avg.value));

              forfields[s][ii].add(
                  OESData(TimeSelectCtrl.to.timeIdxList[Idx.value], avg.value));
            }
          }
        }
      }
    } else {}
    //데이터 업데이트 하고나서 Apply 버튼 누를 수 있게.
    // ChartCtrl.to.enableApply.value = true;
    update();
  }

//////////////////////////zoom
  zoomFunction({required Widget child}) {
    return Listener(
        onPointerSignal: (signal) {
          if (signal is PointerScrollEvent) {
            //확대
            if (signal.scrollDelta.dy.isNegative) {
              if (ChartCtrl.to.maxX.value - 6 > ChartCtrl.to.minX.value) {
                ChartCtrl.to.minX.value += 3;
                ChartCtrl.to.maxX.value -= 3;
              }
            }
            //축소
            else {
              if (ChartCtrl.to.minX.value >
                  TimeSelectCtrl.to.timeIdxList.first) {
                ChartCtrl.to.minX.value -= 3;
                ChartCtrl.to.maxX.value += 3;
              }
            }
          }
        },
        child: GestureDetector(
            onHorizontalDragUpdate: (dragUpdate) {
              double primeDelta = dragUpdate.primaryDelta ?? 0.0;
              if (primeDelta != 0) {
                if (primeDelta.isNegative) {
                  if (ChartCtrl.to.maxX.value > ChartCtrl.to.minX.value &&
                      ChartCtrl.to.maxX.value <=
                          (TimeSelectCtrl.to.timeIdxList.last / 1000) - 3) {
                    ChartCtrl.to.minX.value += 3;
                    ChartCtrl.to.maxX.value += 3;
                  }
                } else {
                  if (ChartCtrl.to.maxX.value > ChartCtrl.to.minX.value &&
                      ChartCtrl.to.minX.value >
                          TimeSelectCtrl.to.timeIdxList.first &&
                      ChartCtrl.to.minX.value <
                          TimeSelectCtrl.to.timeIdxList.last / 1000 &&
                      ChartCtrl.to.maxX.value <=
                          TimeSelectCtrl.to.timeIdxList.last / 1000) {
                    ChartCtrl.to.minX.value -= 3;
                    ChartCtrl.to.maxX.value -= 3;
                  }
                }
              }
              update();
            },
            child: child));
  }
}
