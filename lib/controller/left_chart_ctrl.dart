import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/foundation.dart';
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
  RxString testTime1 = ''.obs;
  RxString testTime2 = ''.obs;
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

  Future<List<List<dynamic>>> readLeftData2(String singlaPath) async {
    List<List<dynamic>> leftData = [];
    // for (int s = 0; s < FilePickerCtrl.to.oesFD.length; s++) {
    // ChartCtrl.to.forfields.add(RxList.empty());
    // if (FilePickerCtrl.to.oesFD[s].isChecked.value == false) continue;
    //여기밑에 compute로 데이터 불러올 것.
    // var filePath = FilePickerCtrl.to.oesFD.map((el) => el.filePath).toList();
    final input = File(singlaPath).openRead();

    var d = const FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
    //여기가 왼쪽 파일데이터

    leftData = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter(csvSettingsDetector: d))
        .toList();
    // }
    return leftData;
  }

  Future<List<List<dynamic>>> readLeftData(String? singlePath) async {
    return await compute(computeLeftData, singlePath);
  }

  static Future<List<List<dynamic>>> computeLeftData(String? singlePath) async {
    //FilePickerCtrl.to.oesFD[s].fileData를 리턴하면 됨.
    List<List<dynamic>> leftData = [];
    // for (int s = 0; s < FilePickerCtrl.to.oesFD.length; s++) {
    // ChartCtrl.to.forfields.add(RxList.empty());
    // if (FilePickerCtrl.to.oesFD[s].isChecked.value == false) continue;
    //여기밑에 compute로 데이터 불러올 것.
    // var filePath = FilePickerCtrl.to.oesFD.map((el) => el.filePath).toList();
    final input = File(singlePath!).openRead();

    var d = const FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
    //여기가 왼쪽 파일데이터

    // }
    return await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter(csvSettingsDetector: d))
        .toList();
  }

//origin
//   Future<void> originupdateLeftData() async {
//     if (FilePickerCtrl.to.oesFD.isNotEmpty) {
//       int chkCnt = 0;
//       for (var item in FilePickerCtrl.to.oesFD) {
//         if (item.isChecked.value) chkCnt++;
//       }
//       debugPrint('check count $chkCnt');
//       if (chkCnt > 5) {
//         //메시지창 넣으세요.

//         FilePickerCtrl.to.isError.value = 2;
//         errorDialog();
//         return;
//       }

//       forfields.clear();
//       forfields = RxList.empty();
//       //s는 파일갯수
//       for (int s = 0; s < FilePickerCtrl.to.oesFD.length; s++) {
//         forfields.add(RxList.empty());
//         if (FilePickerCtrl.to.oesFD[s].isChecked.value == false) continue;
//         var filePath =
//             FilePickerCtrl.to.oesFD.map((el) => el.filePath).toList();
//         DateTime originStart = DateTime.now();
//         debugPrint('origin updateLeftData start : $originStart');
//         //FilePickerCtrl.to.oesFD[s].fileData = await readLeftData(filePath[s]!);
//         FilePickerCtrl.to.oesFD[s].fileData =
//             await compute(computeLeftData, filePath[s]!);
//         DateTime originEnd = DateTime.now();
//         debugPrint('origin updateLeftData end   : $originEnd');
//         var originTime1 = DateTime(
//               originEnd.year,
//               originEnd.month,
//               originEnd.day,
//               originEnd.hour,
//               originEnd.minute,
//               originEnd.second,
//               originEnd.millisecond,
//             )
//                 .difference(DateTime(
//                   originStart.year,
//                   originStart.month,
//                   originStart.day,
//                   originStart.hour,
//                   originStart.minute,
//                   originStart.second,
//                   originStart.millisecond,
//                 ))
//                 .inMilliseconds
//                 .toDouble() /
//             1000;
//         testTime1.value = originTime1.toString();
//         debugPrint('origin testTime ${testTime1.value} 초');

//         int fileFormatRowSize = FilePickerCtrl.to.oesFD[s].fileData
//             .indexWhere((e) => e.contains('FileFormat : 1'));

//         int headRowSize = FilePickerCtrl.to.oesFD[s].fileData
//             .indexWhere((element) => element.contains('Time'));
//         if (fileFormatRowSize == 0 && headRowSize == 6) {
//           debugPrint('파일형식 맞음, apply 가능');
//           int nnn = 0;

//           for (int a = headRowSize + 1; // 6+1 a = 7
//               a < FilePickerCtrl.to.oesFD[s].fileData.length;
//               a++) {
//             Idx.value = a - headRowSize + -1; //7 - 6 + 1
//             FilePickerCtrl.to.oesFD[s].avg.clear();
// //ii는 레인지 갯수
//             for (var ii = 0; ii < 5; ii++) {
//               forfields[s].add([]);
//               int cnt = RangeSliderCtrl.to.rsModel[ii].rv.value.end.toInt() -
//                   RangeSliderCtrl.to.rsModel[ii].rv.value.start.toInt() +
//                   1;
//               sum.value = 0.0;
//               int inc = 0;
//               for (int i = 0; i < cnt; i++) {
//                 if (FilePickerCtrl.to.oesFD[s].fileData[a].length > i) {
//                   // final value = FilePickerCtrl.to.oesFD[s].fileData[a][
//                   //     RangeSliderCtrl.to.rsModel[ii].rv.value.start.toInt() +
//                   //         i +
//                   //         1];
//                   // if (value is num) {
//                   // debugPrint('num : $value');
//                   if (FilePickerCtrl.to.oesFD[s].fileData[a][RangeSliderCtrl
//                               .to.rsModel[ii].rv.value.start
//                               .toInt() +
//                           i +
//                           1] !=
//                       "") {
//                     debugPrint('여러번 도는거 같은데');
//                     sum.value += FilePickerCtrl.to.oesFD[s].fileData[a][
//                         RangeSliderCtrl.to.rsModel[ii].rv.value.start.toInt() +
//                             i +
//                             1];
//                     inc++;
//                   }
//                   // }
//                 }
//               }
//               // FilePickerCtrl.to.oesFD[s].avg
//               //     .add(inc != 0 ? sum.value / inc : 0);
//               FilePickerCtrl.to.oesFD[s].avg
//                   .add(inc != 0 ? sum.value / inc : 0);
//               if (TimeSelectCtrl.to.timeIdxList.length > Idx.value) {
//                 // FilePickerCtrl.to.oesFD[s].avg.clear();
//                 debugPrint(
//                     'chart ${TimeSelectCtrl.to.timeIdxList.length} ${Idx.value} ${nnn++}, $s, $ii, ${TimeSelectCtrl.to.timeIdxList[Idx.value]},${FilePickerCtrl.to.oesFD[s].avg[ii].toStringAsFixed(0)} ');

//                 //timeIdxList
//                 forfields[s][ii].add(WGSspot(
//                     TimeSelectCtrl.to.timeIdxList[Idx.value],
//                     FilePickerCtrl.to.oesFD[s].avg[ii].round()));
//               }
//               // FilePickerCtrl.to.oesFD[s].avg.clear();
//               // for (var ii = 0; ii < FilePickerCtrl.to.oesFD.length; ii++) {
//               //   for (var iii = 0;
//               //       iii < FilePickerCtrl.to.oesFD[ii].avg.length;
//               //       iii++) {
//               //     debugPrint('apply ${FilePickerCtrl.to.oesFD[ii].avg[iii]}');
//               //   }
//               // }
//             }
//           }
//         }

//         // avg.value = sum.value / inc;
//         // double avg = 0.0;
//         // avg += sum.value / inc;

// //밑에 타임인덱스가 그냥 인덱스보다 긴지 디버그 찍어보기

//       }
//     } else {}
//     update();
//     // for (var ii = 0; ii < FilePickerCtrl.to.oesFD.length; ii++) {
//     //   for (var iii = 0; iii < FilePickerCtrl.to.oesFD[ii].avg.length; iii++) {
//     //     debugPrint('apply ${FilePickerCtrl.to.oesFD[ii].avg[iii]}');
//     //   }
//     // }
//   }

//

  Future<void> originupdateLeftDataTest() async {
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
        DateTime originStart = DateTime.now();
        debugPrint('origin updateLeftData start : $originStart');
        final input = await File(filePath[s]!).openRead();

        var d = const FirstOccurrenceSettingsDetector(
            eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);

        FilePickerCtrl.to.oesFD[s].fileData = await input
            .transform(utf8.decoder)
            .transform(CsvToListConverter(csvSettingsDetector: d))
            .toList();
        DateTime originEnd = DateTime.now();
        debugPrint('origin updateLeftData end   : $originEnd');
        var originTime1 = DateTime(
              originEnd.year,
              originEnd.month,
              originEnd.day,
              originEnd.hour,
              originEnd.minute,
              originEnd.second,
              originEnd.millisecond,
            )
                .difference(DateTime(
                  originStart.year,
                  originStart.month,
                  originStart.day,
                  originStart.hour,
                  originStart.minute,
                  originStart.second,
                  originStart.millisecond,
                ))
                .inMilliseconds
                .toDouble() /
            1000;
        testTime1.value = originTime1.toString();
        debugPrint('origin testTime ${testTime1.value} 초');
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
  }

  Future<void> updateLeftData() async {
    // debugPrint('compute updateLeftData start : ${DateTime.now()}');
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
        //여기밑에 compute로 데이터 불러올 것.
        var filePath =
            FilePickerCtrl.to.oesFD.map((el) => el.filePath).toList();
        // final input = await File(filePath[s]!).openRead();

        // var d = const FirstOccurrenceSettingsDetector(
        //     eols: ['\r\n', '\n'], textDelimiters: ['"', "'"]);
        // //여기가 왼쪽 파일데이터
        // FilePickerCtrl.to.oesFD[s].fileData = await input
        //     .transform(utf8.decoder)
        //     .transform(CsvToListConverter(csvSettingsDetector: d))
        //     .toList();
        //FilePickerCtrl.to.oesFD[s].fileData를 compute로 리턴시키면 됨.
        String? singlePath = filePath[s];
        debugPrint('singlePath : $singlePath');
        DateTime computeStart = DateTime.now();
        debugPrint('compute updateLeftData start : $computeStart');
        FilePickerCtrl.to.oesFD[s].fileData = await readLeftData2(singlePath!);
        DateTime computeEnd = DateTime.now();
        debugPrint('compute updateLeftData end   : $computeEnd');
        var computeTime1 = DateTime(
              computeEnd.year,
              computeEnd.month,
              computeEnd.day,
              computeEnd.hour,
              computeEnd.minute,
              computeEnd.second,
              computeEnd.millisecond,
            )
                .difference(DateTime(
                  computeStart.year,
                  computeStart.month,
                  computeStart.day,
                  computeStart.hour,
                  computeStart.minute,
                  computeStart.second,
                  computeStart.millisecond,
                ))
                .inMilliseconds
                .toDouble() /
            1000;
        testTime2.value = computeTime1.toString();
        debugPrint('compute testTime ${testTime2.value} 초');
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
                }
              }
              FilePickerCtrl.to.oesFD[s].avg
                  .add(inc != 0 ? sum.value / inc : 0);
              if (TimeSelectCtrl.to.timeIdxList.length > Idx.value) {
                forfields[s][ii].add(WGSspot(
                    TimeSelectCtrl.to.timeIdxList[Idx.value],
                    FilePickerCtrl.to.oesFD[s].avg[ii].round()));
              }
            }
          }
        } //

        // avg.value = sum.value / inc;
        // double avg = 0.0;
        // avg += sum.value / inc;

//밑에 타임인덱스가 그냥 인덱스보다 긴지 디버그 찍어보기

      }
    } else {}
    // debugPrint('compute updateLeftData end : ${DateTime.now()}');
    update();
    // for (var ii = 0; ii < FilePickerCtrl.to.oesFD.length; ii++) {
    //   for (var iii = 0; iii < FilePickerCtrl.to.oesFD[ii].avg.length; iii++) {
    //     debugPrint('apply ${FilePickerCtrl.to.oesFD[ii].avg[iii]}');
    //   }
    // }
  }
}
