import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/view/widget/error_dialog_widget.dart';
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
  RxList<String> seriesName = RxList.empty();
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

  Rx<ZoomPanBehavior> zoomPan = ZoomPanBehavior(
          enableDoubleTapZooming: false,
          enablePanning: false,
          enablePinching: false,
          enableSelectionZooming: false,
          enableMouseWheelZooming: false)
      .obs;

  void init() {
    zoomPan.value = ZoomPanBehavior(
        zoomMode: ZoomMode.xy,
        enableDoubleTapZooming: true,
        enablePanning: true,
        enablePinching: true,
        enableSelectionZooming: true,
        enableMouseWheelZooming: true);
  }

  Future<void> updateLeftData() async {
    if (FilePickerCtrl.to.oesFD.isNotEmpty) {
      int chkCnt = 0;
      for (var item in FilePickerCtrl.to.oesFD) {
        if (item.isChecked.value) chkCnt++;
      }
      debugPrint('check count $chkCnt');
      if (chkCnt > 5) {
        //메시지창 넣으세요.

        FilePickerCtrl.to.isError.value = 2;
        errorDialog();
        return;
      }

      forfields.clear();
      forfields = RxList.empty();
      //s는 파일갯수
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
        int fileFormatRowSize = FilePickerCtrl.to.oesFD[s].fileData
            .indexWhere((e) => e.contains('FileFormat : 1'));

        int headRowSize = FilePickerCtrl.to.oesFD[s].fileData
            .indexWhere((element) => element.contains('Time'));
        if (fileFormatRowSize == 0 && headRowSize == 6) {
          debugPrint('파일형식 맞음, apply 가능');
          int nnn = 0;

          for (int a = headRowSize + 1; // 6+1 a = 7
              a < FilePickerCtrl.to.oesFD[s].fileData.length;
              a++) {
            Idx.value = a - headRowSize + -1; //7 - 6 + 1
            FilePickerCtrl.to.oesFD[s].avg.clear();
//ii는 레인지 갯수
            for (var ii = 0; ii < 5; ii++) {
              forfields[s].add([]);
              int cnt = RangeSliderCtrl.to.rsModel[ii].rv.value.end.toInt() -
                  RangeSliderCtrl.to.rsModel[ii].rv.value.start.toInt() +
                  1;
              sum.value = 0.0;
              int inc = 0;
              for (int i = 0; i < cnt; i++) {
                if (FilePickerCtrl.to.oesFD[s].fileData[a].length > i) {
                  // final value = FilePickerCtrl.to.oesFD[s].fileData[a][
                  //     RangeSliderCtrl.to.rsModel[ii].rv.value.start.toInt() +
                  //         i +
                  //         1];
                  // if (value is num) {
                  // debugPrint('num : $value');
                  if (FilePickerCtrl.to.oesFD[s].fileData[a][RangeSliderCtrl
                              .to.rsModel[ii].rv.value.start
                              .toInt() +
                          i +
                          1] !=
                      "") {
                    debugPrint('여러번 도는거 같은데');
                    sum.value += FilePickerCtrl.to.oesFD[s].fileData[a][
                        RangeSliderCtrl.to.rsModel[ii].rv.value.start.toInt() +
                            i +
                            1];
                    inc++;
                  }
                  // }
                }
              }
              // FilePickerCtrl.to.oesFD[s].avg
              //     .add(inc != 0 ? sum.value / inc : 0);
              FilePickerCtrl.to.oesFD[s].avg
                  .add(inc != 0 ? sum.value / inc : 0);
              if (TimeSelectCtrl.to.timeIdxList.length > Idx.value) {
                // FilePickerCtrl.to.oesFD[s].avg.clear();
                debugPrint(
                    'chart ${TimeSelectCtrl.to.timeIdxList.length} ${Idx.value} ${nnn++}, $s, $ii, ${TimeSelectCtrl.to.timeIdxList[Idx.value]},${FilePickerCtrl.to.oesFD[s].avg[ii].toStringAsFixed(0)} ');

                //timeIdxList
                forfields[s][ii].add(WGSspot(
                    TimeSelectCtrl.to.timeIdxList[Idx.value],
                    FilePickerCtrl.to.oesFD[s].avg[ii].round()));
              }
              // FilePickerCtrl.to.oesFD[s].avg.clear();
              // for (var ii = 0; ii < FilePickerCtrl.to.oesFD.length; ii++) {
              //   for (var iii = 0;
              //       iii < FilePickerCtrl.to.oesFD[ii].avg.length;
              //       iii++) {
              //     debugPrint('apply ${FilePickerCtrl.to.oesFD[ii].avg[iii]}');
              //   }
              // }
            }
          }
        }

        // avg.value = sum.value / inc;
        // double avg = 0.0;
        // avg += sum.value / inc;

//밑에 타임인덱스가 그냥 인덱스보다 긴지 디버그 찍어보기

      }
    } else {}
    update();
    // for (var ii = 0; ii < FilePickerCtrl.to.oesFD.length; ii++) {
    //   for (var iii = 0; iii < FilePickerCtrl.to.oesFD[ii].avg.length; iii++) {
    //     debugPrint('apply ${FilePickerCtrl.to.oesFD[ii].avg[iii]}');
    //   }
    // }
  }
}
