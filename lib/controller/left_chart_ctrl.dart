import 'dart:async';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

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
  RxList<dynamic> yVal = RxList.empty();
  RxDouble sum = 0.0.obs;
  RxDouble avg = 0.0.obs;
  RxList<dynamic> tempTime = RxList.empty();
  RxInt Idx = 0.obs;
  RxList<int> IdxList = RxList.empty();
  List<FlSpot> flList = RxList.empty();

  List xVal = [];
  double xValLast = 0.0;
  List<DateTime> dateTime = [];
  List csvData = [];
  RxString fileName = ''.obs;
  RxBool exportCsv = false.obs;

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
      for (var ii = 0; ii < seriesCnt.value; ii++) {
        forfields[ii].clear();
      }
      for (var a = 7; a < 14; a++) {
        Idx.value = a - 7;
        String time = FilePickerCtrl.to.forfields[a][0]; // 15:23:43.532
        csvData.add(time);
        String toConvert = '2022-01-01 12:' + time;
        final dateParse = DateTime.parse(toConvert);
        dateTime.add(dateParse);
        xVal.add(DateTime(
                dateTime[Idx.value].year,
                dateTime[Idx.value].month,
                dateTime[Idx.value].day,
                dateTime[Idx.value].hour,
                dateTime[Idx.value].minute,
                dateTime[Idx.value].second,
                dateTime[Idx.value].millisecond)
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
        for (var ii = 0; ii < 5; ii++) {
          int cnt = RangeSliderCtrl.to.currentRv[ii].end.toInt() -
              RangeSliderCtrl.to.currentRv[ii].start.toInt() +
              1;
          sum.value = 0.0;

          for (int i = 0; i < cnt; i++) {
            sum.value += FilePickerCtrl.to.forfields[a]
                [RangeSliderCtrl.to.currentRv[ii].start.toInt() + i + 1];
          }
          avg.value = sum.value / cnt;
          debugPrint('${Idx.value}의x && y : ${avg.value}');
          debugPrint('xVal[0] // xVal[1]에 0?? : $xVal');
          forfields[ii].add(FlSpot(xVal[Idx.value], avg.value));
          debugPrint('$ii/${Idx.value} forfileds: ${forfields[ii]}');
        }
      }
    } else {}
    //데이터 업데이트 하고나서 Apply 버튼 누를 수 있게.
    ChartCtrl.to.enableApply.value = true;
    update();
  }
}
