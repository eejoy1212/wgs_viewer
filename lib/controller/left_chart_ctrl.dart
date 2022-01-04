import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:date_time_format/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';

class RangeValue {
  double start;
  double end;
  List<double> tableX;
  RangeValue({
    required this.start,
    required this.end,
    required this.tableX,
  });

  RangeValue copyWith({
    double? start,
    double? end,
    List<double>? tableX,
  }) {
    return RangeValue(
      start: start ?? this.start,
      end: end ?? this.end,
      tableX: tableX ?? this.tableX,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start,
      'end': end,
      'tableX': tableX,
    };
  }

  factory RangeValue.fromMap(Map<String, dynamic> map) {
    return RangeValue(
      start: map['start']?.toDouble() ?? 0.0,
      end: map['end']?.toDouble() ?? 0.0,
      tableX: List<double>.from(map['tableX']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RangeValue.fromJson(String source) =>
      RangeValue.fromMap(json.decode(source));

  @override
  String toString() => 'RangeValue(start: $start, end: $end, tableX: $tableX)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RangeValue &&
        other.start == start &&
        other.end == end &&
        listEquals(other.tableX, tableX);
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ tableX.hashCode;
}

class ChartCtrl extends GetxController {
  static ChartCtrl get to => Get.find();
  /*visible mode == 0 ->left chart
  visible mode == 1 ->right chart
  visible mode == 2 ->all chart
  */
  RxInt visibleMode = 2.obs;
  // RxInt seriesCnt = 150.obs;
  // RxInt seriesCnt = 150.obs;

  RxInt seriesCnt = 150.obs;
  RxDouble rangeEnd = 0.0.obs;
  RxBool leftMode = false.obs;

  RxList<FlSpot> simData = RxList.empty();
  List<FlSpot> leftChartData = RxList.empty();
  RxList<List<FlSpot>> rightChartData = RxList.empty();
  RxBool leftDataMode = false.obs;
  RxInt tempFileNum = 50.obs;
  RxInt tempWaveNum = 10.obs;
  RxList xAxisData = RxList.empty();
  RxList<List<FlSpot>> forfields = RxList.empty();
  List<List<FlSpot>> newList = RxList.empty();
  List<List<FlSpot>> seriesList = RxList.empty();
  RxBool enableApply = false.obs;
  List timeList = RxList.empty();
  RxDouble value = 0.0.obs;
  List<double> rangeList = RxList.empty();
  // Set<double> startSet = RxSet();
  // Set<double> endSet = RxSet();
  List<double> startList = RxList.empty();
  List<double> endList = RxList.empty();
  List<RangeValue> rv = [];
  List<RangeValue> rv2 = [];
  List<RangeValue> rv3 = [];
  List<RangeValue> rv4 = [];
  List<RangeValue> rv5 = [];
  RxInt timeMaxLength = 0.obs;
  RxInt rvIdx = 0.obs;
  List<Duration> diffList = RxList.empty();
  List xVal = [];
  double xValLast = 0.0;
  List<DateTime> dateTime = [];

/*
1. 만약에 leftChartSignal==true면,
2. count(==(아래 메뉴에서 파일 선택한 갯수)*(왼쪽 메뉴에서 파장 선택한 갯수))대로 시리즈가 들어오고,
3.  leftChartData의 FlSpot에서 x축 , y축 값을 .add한다.
*/
  void init() {
    for (var i = 0; i < ChartCtrl.to.seriesCnt.value; i++) {
      forfields.add([]);
    }
    for (var i = 0; i < ChartCtrl.to.seriesCnt.value; i++) {
      rv.add(RangeValue(start: 0.0, end: 0.0, tableX: []));
      rv2.add(RangeValue(start: 0.0, end: 0.0, tableX: []));
      rv3.add(RangeValue(start: 0.0, end: 0.0, tableX: []));
      rv4.add(RangeValue(start: 0.0, end: 0.0, tableX: []));
      rv5.add(RangeValue(start: 0.0, end: 0.0, tableX: []));
    }
    for (var i = 1; i < 2048; i++) {
      RangeSliderCtrl.to.minMaxList.add([]);
    }
  }

  Future<void> updateLeftData() async {
    if (leftDataMode.value == true) {
      seriesCnt.value = 5 * FilePickerCtrl.to.selectedFileName.length.toInt();

      for (var ii = 0; ii < seriesCnt.value; ii++) {
        forfields[ii].clear();
      }
      // print('이거 길이 뭐야${FilePickerCtrl.to.forfields.length}');

      for (var i = 7; i < 14; i++) {
        String time = FilePickerCtrl.to.forfields[i][0]; // 15:23:43.532
        // print('time: $time'); // 46:34.2
        String toConvert = '2022-01-01 12:' + time;
        final dateParse = DateTime.parse(toConvert);
        print('어떻게 들어가나 $dateParse');
        dateTime.add(dateParse);
        print('새로운 리스트 $dateTime');

        //수진
        // final dataStr = DateFormat('mm:ss').parse(time);
        // print('이건 뭘까 ? $dataStr');
        // aaa.add(dataStr);
        // print('리스트가 $aaa');

        value.value = 0.0;
        for (var ii = 0; ii < seriesCnt.value; ii++) {
          //이건 뭐지
          final int cnt = (rv[ii].end - rv[ii].start + 1).toInt();

          for (var iii = 0; iii < cnt; iii++) {
            // 2 - 1

            final int avgIdx = 1 + rv[ii].start.toInt() + iii;

            value.value += FilePickerCtrl.to.forfields[i][avgIdx];
          }
          value.value /= cnt;

          //여기가 x,y 넣는거구만
          // forfields[ii].add(FlSpot(idx.toDouble(), value.value));

          debugPrint('왼쪽 차트?? : $forfields');
        }
        timeMaxLength.value = FilePickerCtrl.to.forfields[i][0].length;
        DateTime first = DateTime(0, 0, 0, 0, 0);
        String stringf = DateFormat().add_Hms().format(first);
        FilePickerCtrl.to.timeAxis.insert(0, stringf);
        update();
      }

      //수진
      xVal.add(0.0);
      for (var i = 1; i < dateTime.length; i++) {
        xVal.add(DateTime(
                dateTime[i].year,
                dateTime[i].month,
                dateTime[i].day,
                dateTime[i].hour,
                dateTime[i].minute,
                dateTime[i].second,
                dateTime[i].millisecond)
            .difference(
              DateTime(
                  dateTime[0].year,
                  dateTime[0].month,
                  dateTime[0].day,
                  dateTime[0].hour,
                  dateTime[0].minute,
                  dateTime[0].second,
                  dateTime[0].millisecond),
            )
            .inMilliseconds
            .toDouble());
        print('날짜 뺄셈 $i : ${xVal[i - 1]}');
        print('왜안돼 ${dateTime[i - 1]}');
      }
      print('마지막 ${xVal.last}');
      xValLast = double.parse(xVal.last.toString()) / 1000;
      for (int ii = 0; ii < 7; ii++) {
        for (var i = 0; i < 5; i++) {
          forfields[i].add(
              FlSpot(double.parse(xVal[ii].toString()) / 1000, value.value));
        }
      }
    } else {}

    // update();
    //데이터 업데이트 하고나서 Apply 버튼 누를 수 있게.
    ChartCtrl.to.enableApply.value = true;
  }
}

class RangeSliders extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 500,
      child: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Wavelength 1'),
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
              ignoring: ChartCtrl.to.forfields.isEmpty,
              child: RangeSlider(
                onChanged: (v) {
                  RangeSliderCtrl.to.currentRv.value = v;
                  //v.start는 값이 아니라 인덱스임
                  RangeSliderCtrl.to.vStart =
                      FilePickerCtrl.to.firstLine[v.start.round()];
                  RangeSliderCtrl.to.vEnd =
                      FilePickerCtrl.to.firstLine[v.end.round()];
                  debugPrint(
                      'firstLine length && onChanged : ${FilePickerCtrl.to.firstLine.length} $v');
                },
                values: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? RangeSliderCtrl.to.currentRv.value
                    : const RangeValues(0, 0),
                min: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.first)
                        .toDouble()
                    : 0,
                max: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                        .toDouble()
                    : 1,
                divisions: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                    : 1,
                labels: RangeLabels(
                    RangeSliderCtrl.to.vStart.toStringAsFixed(3),
                    RangeSliderCtrl.to.vEnd.toStringAsFixed(3)),
              ),
            );
          }),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Wavelength 2'),
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
              ignoring: ChartCtrl.to.forfields.isEmpty,
              child: RangeSlider(
                onChanged: (v) {
                  RangeSliderCtrl.to.currentRv2.value = v;
                  //v.start는 값이 아니라 인덱스임
                  RangeSliderCtrl.to.vStart2 =
                      FilePickerCtrl.to.firstLine[v.start.round()];
                  RangeSliderCtrl.to.vEnd2 =
                      FilePickerCtrl.to.firstLine[v.end.round()];
                  debugPrint(
                      'firstLine length && onChanged : ${FilePickerCtrl.to.firstLine.length} $v');
                },
                values: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? RangeSliderCtrl.to.currentRv2.value
                    : const RangeValues(0, 0),
                min: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.first)
                        .toDouble()
                    : 0,
                max: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                        .toDouble()
                    : 1,
                divisions: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                    : 1,
                labels: RangeLabels(
                    RangeSliderCtrl.to.vStart2.toStringAsFixed(3),
                    RangeSliderCtrl.to.vEnd2.toStringAsFixed(3)),
              ),
            );
          }),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Wavelength 3'),
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
              ignoring: ChartCtrl.to.forfields.isEmpty,
              child: RangeSlider(
                onChanged: (v) {
                  RangeSliderCtrl.to.currentRv3.value = v;
                  //v.start는 값이 아니라 인덱스임
                  RangeSliderCtrl.to.vStart3 =
                      FilePickerCtrl.to.firstLine[v.start.round()];
                  RangeSliderCtrl.to.vEnd3 =
                      FilePickerCtrl.to.firstLine[v.end.round()];
                  debugPrint(
                      'firstLine length && onChanged : ${FilePickerCtrl.to.firstLine.length} $v');
                },
                values: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? RangeSliderCtrl.to.currentRv3.value
                    : const RangeValues(0, 0),
                min: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.first)
                        .toDouble()
                    : 0,
                max: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                        .toDouble()
                    : 1,
                divisions: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                    : 1,
                labels: RangeLabels(
                    RangeSliderCtrl.to.vStart3.toStringAsFixed(3),
                    RangeSliderCtrl.to.vEnd3.toStringAsFixed(3)),
              ),
            );
          }),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Wavelength 4'),
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
              ignoring: ChartCtrl.to.forfields.isEmpty,
              child: RangeSlider(
                onChanged: (v) {
                  RangeSliderCtrl.to.currentRv4.value = v;
                  //v.start는 값이 아니라 인덱스임
                  RangeSliderCtrl.to.vStart4 =
                      FilePickerCtrl.to.firstLine[v.start.round()];
                  RangeSliderCtrl.to.vEnd4 =
                      FilePickerCtrl.to.firstLine[v.end.round()];
                  debugPrint(
                      'firstLine length && onChanged : ${FilePickerCtrl.to.firstLine.length} $v');
                },
                values: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? RangeSliderCtrl.to.currentRv4.value
                    : const RangeValues(0, 0),
                min: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.first)
                        .toDouble()
                    : 0,
                max: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                        .toDouble()
                    : 1,
                divisions: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                    : 1,
                labels: RangeLabels(
                    RangeSliderCtrl.to.vStart4.toStringAsFixed(3),
                    RangeSliderCtrl.to.vEnd4.toStringAsFixed(3)),
              ),
            );
          }),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Wavelength 5'),
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
              ignoring: ChartCtrl.to.forfields.isEmpty,
              child: RangeSlider(
                onChanged: (v) {
                  RangeSliderCtrl.to.currentRv5.value = v;
                  //v.start는 값이 아니라 인덱스임
                  RangeSliderCtrl.to.vStart5 =
                      FilePickerCtrl.to.firstLine[v.start.round()];
                  RangeSliderCtrl.to.vEnd5 =
                      FilePickerCtrl.to.firstLine[v.end.round()];
                  debugPrint(
                      'firstLine length && onChanged : ${FilePickerCtrl.to.firstLine.length} $v');
                },
                values: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? RangeSliderCtrl.to.currentRv5.value
                    : const RangeValues(0, 0),
                min: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.first)
                        .toDouble()
                    : 0,
                max: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                        .toDouble()
                    : 1,
                divisions: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                    : 1,
                labels: RangeLabels(
                    RangeSliderCtrl.to.vStart5.toStringAsFixed(3),
                    RangeSliderCtrl.to.vEnd.toStringAsFixed(3)),
              ),
            );
          }),
        ],
      ),
    );
  }
}
