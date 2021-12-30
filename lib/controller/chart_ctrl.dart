import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:wgs_viewer/controller/file_ctrl.dart';

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
  RxBool rightMode = false.obs;
  RxList<FlSpot> simData = RxList.empty();
  List<FlSpot> leftChartData = RxList.empty();
  RxList<List<FlSpot>> rightChartData = RxList.empty();
  RxBool leftDataMode = false.obs;
  RxBool rightDataMode = false.obs;
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
      ChartCtrl.to.seriesCnt.value =
          5 * FilePickerCtrl.to.selectedFileName.length.toInt();
      var firstTime = FilePickerCtrl.to.forfields[7][0]; // 15:23:43.432

      for (var ii = 0; ii < seriesCnt.value; ii++) {
        forfields[ii].clear();
      }

      //start[0] = 1 end[0] = 2
      //start[1] = 5 end[1] =10
      //debugPrint('firstTime $firstTime $dt');
      // for (var i = 7; i < 14; i++) {

      for (var i = 7; i < 14; i++) {
        int idx = i - 7;
        //점이 7개 나와야하는데 위의 idx로하면 6개임
        // int idx = i - 6;

        debugPrint('idx : $idx');
        var time = FilePickerCtrl.to.forfields[i][0]; // 15:23:43.532

        value.value = 0.0;
        for (var ii = 0; ii < seriesCnt.value; ii++) {
//cnt==범위 선택한 것.
          // final cnt = end[ii] - start[ii] + 1;
          final int cnt = (rv[ii].end - rv[ii].start + 1).toInt();
// 레인지 평균내는 식
          for (var iii = 0; iii < cnt; iii++) {
            // 2 - 1

            // final int avgIdx = 1 + rv[ii].start.toInt() + iii;
            final int startIdx = rv.indexOf(rv[ii]);
            final int avgIdx = 1 + startIdx + iii;
            //avgIdx에 인덱스가 아니라 값이 잘못들어간듯..?(ui상 툴팁에 보이는 레인지를 선택한 값이 avgIdx에 잘못들어가는중.)
            value.value += FilePickerCtrl.to.forfields[i][avgIdx];
            // rangeList.add(value.value);
            // debugPrint('레인지 평균 : $value');
            //레인지리스트==파장값들을 리스트에 담은거

          }
          // 레인지 평균내는 식
          value.value /= cnt;

          //시리즈별로 리스트에 추가./
          forfields[ii].add(FlSpot(idx.toDouble(), value.value));
          // RangeSliderCtrl.to.minVal.value = forfields[6].length;
          // RangeSliderCtrl.to.maxVal.value = forfields[6][1].y;
        }
        timeMaxLength.value = FilePickerCtrl.to.forfields[i][0].length;
        debugPrint('cloumn length : ${timeMaxLength.value}');

        update();
      }
    } else {}

    // update();
    //데이터 업데이트 하고나서 Apply 버튼 누를 수 있게.
    ChartCtrl.to.enableApply.value = true;
  }
}

class RangeSliders extends StatefulWidget {
  @override
  State<RangeSliders> createState() => _RangeSlidersState();
}

class _RangeSlidersState extends State<RangeSliders> {
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
              ignoring: ChartCtrl.to.forfields.isNotEmpty &&
                  FilePickerCtrl.to.enableRangeSelect.value == false,
              child: RangeSlider(
                min: 0,

                max: ChartCtrl.to.forfields.isNotEmpty &&
                        FilePickerCtrl.to.enableRangeSelect.value
                    ? 5000
                    : 0,
                // max: ChartCtrl.to.forfields.isNotEmpty ? 5000 : 1,
                divisions: ChartCtrl.to.forfields.isNotEmpty
                    ? ChartCtrl.to.forfields.length
                    : 1,
                // divisions: 1,
                values: ChartCtrl.to.forfields.isNotEmpty &&
                        FilePickerCtrl.to.enableRangeSelect.value
                    ? RangeSliderCtrl.to.currentRangeVal.value
                    : RangeValues(0, 0),
                labels: RangeLabels(ChartCtrl.to.rv[0].start.toString(),
                    ChartCtrl.to.rv[0].end.toString()),
                activeColor: ChartCtrl.to.forfields.isNotEmpty &&
                        FilePickerCtrl.to.enableRangeSelect.value
                    ? Colors.blue
                    : Colors.grey,
                onChanged: (RangeValues val) {
                  /*
                      start end 값을 차트 컨트롤러에 보내서 
                      for문안에 하드코딩 했던거 바꾸기.
                      */

                  //현재(start,end)에 바뀐 값 넣기
                  RangeSliderCtrl.to.currentRangeVal.value = val;
                  //레인지 스타트 && 레인지 앤드에 바뀐 값 넣기
                  for (var i = 0; i < ChartCtrl.to.seriesCnt.value; i++) {
                    ChartCtrl.to.rv[i].start =
                        RangeSliderCtrl.to.currentRangeVal.value.start;
                    ChartCtrl.to.rv[i].end =
                        RangeSliderCtrl.to.currentRangeVal.value.end;
                    //ChartCtrl.to.rvIdx.value==(start,end)의 인덱스값
                    ChartCtrl.to.rvIdx.value =
                        ChartCtrl.to.rv.indexOf(ChartCtrl.to.rv[i]);
                  }
                  //스타트와 앤드의 인덱스값을 떼어 와서
                  //스타트와 앤드의 인덱스값을 떼어 와서 / csv 파장의 인덱스값과 일치하면 그 영역을 차트에 값으로 보여준다.
// if (ChartCtrl.to.rvIdx.value ==) {

// } else {
// }
                },
                // values: RangeSliderCtrl.to.currentRangeVal.value,
                //divisions: ChartCtrl.to.rangeList.length,
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
                ignoring: ChartCtrl.to.forfields.isNotEmpty &&
                    FilePickerCtrl.to.enableRangeSelect.value == false,
                child: RangeSlider(
                  min: 0.0,

                  max: ChartCtrl.to.forfields.isNotEmpty ? 5000 : 1,
                  divisions: ChartCtrl.to.forfields.isNotEmpty
                      ? ChartCtrl.to.forfields.length
                      : 1,
                  // divisions: 1,
                  labels: RangeLabels(ChartCtrl.to.rv[0].start.toString(),
                      ChartCtrl.to.rv[0].end.toString()),
                  activeColor: ChartCtrl.to.forfields.isNotEmpty &&
                          FilePickerCtrl.to.enableRangeSelect.value
                      ? Colors.blue
                      : Colors.grey,
                  onChanged: (RangeValues val) {
                    /*
                      start end 값을 차트 컨트롤러에 보내서 
                      for문안에 하드코딩 했던거 바꾸기.
                      */

                    //현재(start,end)에 바뀐 값 넣기
                    RangeSliderCtrl.to.currentRangeVal.value = val;
                    //레인지 스타트 && 레인지 앤드에 바뀐 값 넣기
                    for (var i = 0; i < ChartCtrl.to.seriesCnt.value; i++) {
                      ChartCtrl.to.rv[i].start =
                          RangeSliderCtrl.to.currentRangeVal.value.start;
                      ChartCtrl.to.rv[i].end =
                          RangeSliderCtrl.to.currentRangeVal.value.end;
                      //ChartCtrl.to.rvIdx.value==(start,end)의 인덱스값
                      ChartCtrl.to.rvIdx.value =
                          ChartCtrl.to.rv.indexOf(ChartCtrl.to.rv[i]);
                    }
                  },
                  values: ChartCtrl.to.forfields.isNotEmpty &&
                          FilePickerCtrl.to.enableRangeSelect.value
                      ? RangeSliderCtrl.to.currentRangeVal.value
                      : const RangeValues(0, 0),
                  //divisions: ChartCtrl.to.rangeList.length,
                ));
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
                ignoring: ChartCtrl.to.forfields.isNotEmpty &&
                    FilePickerCtrl.to.enableRangeSelect.value == false,
                child: RangeSlider(
                  min: 0.0,
                  // max: 1000,
                  max: ChartCtrl.to.forfields.isNotEmpty ? 5000 : 1,
                  divisions: ChartCtrl.to.forfields.isNotEmpty
                      ? ChartCtrl.to.forfields.length
                      : 1,
                  // divisions: 1,
                  labels: RangeLabels(ChartCtrl.to.rv[0].start.toString(),
                      ChartCtrl.to.rv[0].end.toString()),
                  activeColor: ChartCtrl.to.forfields.isNotEmpty &&
                          FilePickerCtrl.to.enableRangeSelect.value
                      ? Colors.blue
                      : Colors.grey,
                  onChanged: (RangeValues val) {
                    /*
                      start end 값을 차트 컨트롤러에 보내서 
                      for문안에 하드코딩 했던거 바꾸기.
                      */

                    //현재(start,end)에 바뀐 값 넣기
                    RangeSliderCtrl.to.currentRangeVal.value = val;
                    //레인지 스타트 && 레인지 앤드에 바뀐 값 넣기
                    for (var i = 0; i < ChartCtrl.to.seriesCnt.value; i++) {
                      ChartCtrl.to.rv[i].start =
                          RangeSliderCtrl.to.currentRangeVal.value.start;
                      ChartCtrl.to.rv[i].end =
                          RangeSliderCtrl.to.currentRangeVal.value.end;
                      //ChartCtrl.to.rvIdx.value==(start,end)의 인덱스값
                      ChartCtrl.to.rvIdx.value =
                          ChartCtrl.to.rv.indexOf(ChartCtrl.to.rv[i]);
                    }
                  },
                  values: RangeSliderCtrl.to.currentRangeVal.value,
                  //divisions: ChartCtrl.to.rangeList.length,
                ));
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
                ignoring: ChartCtrl.to.forfields.isNotEmpty &&
                    FilePickerCtrl.to.enableRangeSelect.value == false,
                child: RangeSlider(
                  min: 0.0,
                  // max: 1000,
                  max: ChartCtrl.to.forfields.isNotEmpty ? 5000 : 1,
                  divisions: ChartCtrl.to.forfields.isNotEmpty
                      ? ChartCtrl.to.forfields.length
                      : 1,
                  // divisions: 1,
                  labels: RangeLabels(ChartCtrl.to.rv[0].start.toString(),
                      ChartCtrl.to.rv[0].end.toString()),
                  activeColor: ChartCtrl.to.forfields.isNotEmpty &&
                          FilePickerCtrl.to.enableRangeSelect.value
                      ? Colors.blue
                      : Colors.grey,
                  onChanged: (RangeValues val) {
                    /*
                      start end 값을 차트 컨트롤러에 보내서 
                      for문안에 하드코딩 했던거 바꾸기.
                      */

                    //현재(start,end)에 바뀐 값 넣기
                    RangeSliderCtrl.to.currentRangeVal.value = val;
                    //레인지 스타트 && 레인지 앤드에 바뀐 값 넣기
                    for (var i = 0; i < ChartCtrl.to.seriesCnt.value; i++) {
                      ChartCtrl.to.rv[i].start =
                          RangeSliderCtrl.to.currentRangeVal.value.start;
                      ChartCtrl.to.rv[i].end =
                          RangeSliderCtrl.to.currentRangeVal.value.end;
                      //ChartCtrl.to.rvIdx.value==(start,end)의 인덱스값
                      ChartCtrl.to.rvIdx.value =
                          ChartCtrl.to.rv.indexOf(ChartCtrl.to.rv[i]);
                    }
                  },
                  values: RangeSliderCtrl.to.currentRangeVal.value,
                  //divisions: ChartCtrl.to.rangeList.length,
                ));
          }),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: const [
                Text('Wavelength 5'),
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
                ignoring: ChartCtrl.to.forfields.isNotEmpty &&
                    FilePickerCtrl.to.enableRangeSelect.value == false,
                child: RangeSlider(
                  min: 0.0,
                  // max: 1000,
                  max: ChartCtrl.to.forfields.isNotEmpty ? 5000 : 1,
                  divisions: ChartCtrl.to.forfields.isNotEmpty
                      ? ChartCtrl.to.forfields.length
                      : 1,
                  // divisions: 1,
                  labels: RangeLabels(ChartCtrl.to.rv[0].start.toString(),
                      ChartCtrl.to.rv[0].end.toString()),
                  activeColor: ChartCtrl.to.forfields.isNotEmpty &&
                          FilePickerCtrl.to.enableRangeSelect.value
                      ? Colors.blue
                      : Colors.grey,
                  onChanged: (RangeValues val) {
                    /*
                      start end 값을 차트 컨트롤러에 보내서 
                      for문안에 하드코딩 했던거 바꾸기.
                      */

                    //현재(start,end)에 바뀐 값 넣기
                    RangeSliderCtrl.to.currentRangeVal.value = val;
                    //레인지 스타트 && 레인지 앤드에 바뀐 값 넣기
                    for (var i = 0; i < ChartCtrl.to.seriesCnt.value; i++) {
                      ChartCtrl.to.rv[i].start =
                          RangeSliderCtrl.to.currentRangeVal.value.start;
                      ChartCtrl.to.rv[i].end =
                          RangeSliderCtrl.to.currentRangeVal.value.end;
                      //ChartCtrl.to.rvIdx.value==(start,end)의 인덱스값
                      ChartCtrl.to.rvIdx.value =
                          ChartCtrl.to.rv.indexOf(ChartCtrl.to.rv[i]);
                    }
                  },
                  values: RangeSliderCtrl.to.currentRangeVal.value,
                  //divisions: ChartCtrl.to.rangeList.length,
                ));
          }),
        ],
      ),
    );
  }
}

class RangeSliderCtrl extends GetxController {
  static RangeSliderCtrl get to => Get.find();
  RxDouble originStart = 0.0.obs;
  RxDouble originEnd = 0.0.obs;
  Rx<RangeValues> currentRangeVal = const RangeValues(0, 0).obs;
  RxBool disabledBtn = false.obs;
  RxString changedStart = ''.obs;
  RxString changedEnd = ''.obs;
  // late Rx<RangeWaveLength> rwl;
  RxDouble maxVal = 867.901527512498.obs;
  RxDouble minVal = 0.0.obs;
  List<dynamic> minMaxList = RxList.empty();
  // List<Range> rm = RxList.empty();
  void minMaxFunc() {
    if (ChartCtrl.to.enableApply.value == true &&
        ChartCtrl.to.rangeList.isNotEmpty) {
      //minMax

      maxVal.value = ChartCtrl.to.rangeList[0];
      minVal.value = ChartCtrl.to.rangeList[0];

      for (var i = 0; i < ChartCtrl.to.rangeList.length; i++) {
        if (ChartCtrl.to.rangeList[i] > maxVal.value) {
          maxVal.value = ChartCtrl.to.rangeList[i];
        }

        if (ChartCtrl.to.rangeList[i] < minVal.value) {
          minVal.value = ChartCtrl.to.rangeList[i];
        }
      }
    }
  }

  void setRangeVal(start, end) {
    if (start < 0) return;
    if (start > end) return;
  }

  //레인지 선택
  rangeSelectFunc() {}
}
