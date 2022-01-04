import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
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
    //왼쪽 데이터 signal을 주었을 때
    if (leftDataMode.value == true) {
      //시리즈갯수

      //시리즈 갯수는 파장 선택하는 레인지 갯수(5개) * 파일선택한 갯수
      //seriesCnt==5*FilePickerCtrl.to.selectedFileName.length
      seriesCnt.value = 5 * FilePickerCtrl.to.selectedFileName.length.toInt();
      // var firstTime = FilePickerCtrl.to.forfields[7][0]; // 15:23:43.432

      for (var ii = 0; ii < seriesCnt.value; ii++) {
        forfields[ii].clear();
      }

      //start[0] = 1 end[0] = 2
      //start[1] = 5 end[1] =10
      //debugPrint('firstTime $firstTime $dt');
      // for (var i = 7; i < 14; i++) {
      String firstTime = FilePickerCtrl.to.forfields[7][0]; // 15:23:43.532
      for (var i = 7; i < 14; i++) {
        int idx = i - 7;
        //점이 7개 나와야하는데 위의 idx로하면 6개임
        // int idx = i - 6;

        debugPrint('idx : $idx');
        String time = FilePickerCtrl.to.forfields[i][0]; // 15:23:43.532
        print('time: $time');
        int min = int.parse(time.substring(0, 2));
        int sec = int.parse(time.substring(3, 5));
        // int millisec = int.parse(time.substring(6, 7));
        DateTime time1 = DateTime(0, 0, 0, 0, min, sec);
        time1.difference(time1);

        String stringT1 = DateFormat().add_Hms().format(time1);
        print('stringT1 :$stringT1');

        print('time1 :$time1');
        // FilePickerCtrl.to.timeAxis.add(FilePickerCtrl.to.forfields[i][0]);

        if (i == 7)
          FilePickerCtrl.to.timeAxis.add('00:00.0');
        else {
          //8일경우 8에서 FirstTime = 0:17.3
          //9일경우 9에서 FirstTime = 0:34.7
          //10일경우 10에서 FirstTime = 32323232

          // time1.difference(firstTime);
          // FilePickerCtrl.to.timeAxis.add(time1);
        }

        for (var i = 0; i < FilePickerCtrl.to.timeAxis.length; i++) {}

        debugPrint('time축 : ${FilePickerCtrl.to.timeAxis}');

        value.value = 0.0;
        for (var ii = 0; ii < seriesCnt.value; ii++) {
//cnt==범위 선택한 것.
          // final cnt = end[ii] - start[ii] + 1;
          final int cnt = (rv[ii].end - rv[ii].start + 1).toInt();
// 레인지 평균내는 식

          for (var iii = 0; iii < cnt; iii++) {
            // 2 - 1

            final int avgIdx = 1 + rv[ii].start.toInt() + iii;
            // final int startIdx = rv.indexOf(rv[ii]);
            // final int avgIdx = 1 + startIdx + iii;
            // final int avgIdx = 1 + rv[ii].start.toInt() + iii;
//0: 0~3;
//1: 5~8;
//2: 10~20;
//3: 500~600;
//4: 650~660;
//0: 170.34~180.32;
//1: 170.34~180.32;
//2: 170.34~180.32;
//3: 170.34~180.32;
//4: 170.34~180.32;
            // final int avgIdx = 1 +
            //     rv[ii].start.toInt() + //0 170.34
            //     rv2[ii].start.toInt() + //5 170.34
            //     rv3[ii].start.toInt() + //10 170.34
            //     rv4[ii].start.toInt() + //500 170.34
            //     rv5[ii].start.toInt() + //650 170.34
            //     iii;
            //avgIdx에 인덱스가 아니라 값이 잘못들어간듯..?(ui상 툴팁에 보이는 레인지를 선택한 값이 avgIdx에 잘못들어가는중.)
            final startValue = rv[ii].start;

            value.value += FilePickerCtrl.to.forfields[i][avgIdx];
            // rangeList.add(value.value);
            // debugPrint('레인지 평균 : $value');
            //레인지리스트==파장값들을 리스트에 담은거

          }
          // 레인지 평균내는 식
          value.value /= cnt;

          //시리즈별로 리스트에 추가./
          // forfields[ii].add(FlSpot(idx.toDouble(), value.value));

          forfields[ii].add(FlSpot(idx.toDouble(), value.value));

          debugPrint('왼쪽 차트?? : $forfields');
        }

        timeMaxLength.value = FilePickerCtrl.to.forfields[i][0].length;
        DateTime first = DateTime(0, 0, 0, 0, 0);
        String stringf = DateFormat().add_Hms().format(first);
        FilePickerCtrl.to.timeAxis.removeAt(0);
        FilePickerCtrl.to.timeAxis.insert(0, stringf);
        print('');
        update();
      }

      debugPrint('time축 after: ${FilePickerCtrl.to.timeAxis}');
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
