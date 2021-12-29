import 'dart:async';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:wgs_viewer/controller/file_ctrl.dart';

class RangeValue {
  double start;
  double end;
  RangeValue({
    required this.start,
    required this.end,
  });
}

class ChartCtrl extends GetxController {
  static ChartCtrl get to => Get.find();
  /*visible mode == 0 ->left chart
  visible mode == 1 ->right chart
  visible mode == 2 ->all chart
  */
  RxInt visibleMode = 2.obs;
  RxInt seriesCnt = 3.obs;
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
      rv.add(RangeValue(start: 0.0, end: 0.0));
    }
  }

  Future<void> updateLeftData() async {
    //왼쪽 데이터 signal을 주었을 때

    // forfields.clear();
    if (leftDataMode.value == true) {
      //시리즈갯수
      var firstTime = FilePickerCtrl.to.forfields[7][0]; // 15:23:43.432
      // var dt = DateFormat('hh:nn:ss.nnn')
      //     .format(DateTime.parse(firstTime))
      //     .toString();
      // List<int> start = [];
      // List<int> end = [];

      // //1 range 선택
      // start.add(1);
      // end.add(2);

      // //2 range 선택
      // start.add(5);
      // end.add(10);
      // //3 range 선택
      // start.add(11);
      // end.add(12);

      for (var ii = 0; ii < seriesCnt.value; ii++) {
        forfields[ii].clear();
      }
      //start[0] = 1 end[0] = 2
      //start[1] = 5 end[1] =10
      //debugPrint('firstTime $firstTime $dt');
      for (var i = 7; i < 13; i++) {
        int idx = i - 7;
        var time = FilePickerCtrl.to.forfields[i][0]; // 15:23:43.532
        // DateTime asss = time - firstTime;
        // var fvf = double.parse(asss.toString());

        //Time을 Double로 parsing해야 함.
        // time.difference(other)

        //분
        //var substringMin = time.substring(3, 5);
        //초
        //var substringSec = time.substring(6).replaceAll(':', '.');
        // String aaaa = '23.32';
        // double bbbb = double.parse(aaaa);

        value.value = 0.0;
        //다른레인지에 그리는 포문
        // for (var ii = 0; ii < start.length; ii++) {

        for (var ii = 0; ii < seriesCnt.value; ii++) {
//cnt==범위 선택한 것.
          // final cnt = end[ii] - start[ii] + 1;
          final int cnt = (rv[ii].end - rv[ii].start + 1).toInt();
// 레인지 평균내는 식
          for (var iii = 0; iii < cnt; iii++) {
            // 2 - 1
            final int avgIdx = 1 + rv[ii].start.toInt() + iii;
            debugPrint('avgIdx $avgIdx');
            value.value += FilePickerCtrl.to.forfields[i][avgIdx];
            rangeList.add(value.value);
            // debugPrint('레인지 평균 : $value');
            // debugPrint('레인지리스트 : $rangeList');
          }
          value.value /= cnt;
          // 레인지 평균내는 식

          //시리즈별로 리스트에 추가.
          forfields[ii].add(FlSpot(idx.toDouble(), value.value));
          //  forfields[ii].add(FlSpot((idx).toDouble(), value));

        }
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
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: const [
                Text('Wavelength 1'),
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return ChartCtrl.to.enableApply.value == true
                ? RangeSlider(
                    min: 0.0,
                    max: 1000,
                    // divisions: ChartCtrl.to.rangeList.length != 0
                    //     ? ChartCtrl.to.rangeList.length - 1
                    //     : 1,
                    divisions: 100,
                    labels: RangeLabels(
                        RangeSliderCtrl.to.currentRangeVal.value.start
                            .toString(),
                        RangeSliderCtrl.to.currentRangeVal.value.end
                            .toString()),
                    activeColor: Colors.blue,
                    onChanged: (RangeValues val) {
                      List<int> aa = [1, 222222, 3, 4, 5]; // 2 1
                      int idx = aa.indexOf(5);
                      debugPrint('idx $idx');

                      RangeSliderCtrl.to.currentRangeVal.value = val;
                      /*
                      start end 값을 차트 컨트롤러에 보내서 
                      for문안에 하드코딩 했던거 바꾸기.
                      */
                      ChartCtrl.to.rv[0].start = 20;
                      //RangeSliderCtrl.to.currentRangeVal.value.start;
                      ChartCtrl.to.rv[0].end = 30;
                      //RangeSliderCtrl.to.currentRangeVal.value.end;
                      debugPrint(
                          'RangeValue: ${ChartCtrl.to.rv[0].start} ${ChartCtrl.to.rv[0].end}');
                      return;
                      RangeSliderCtrl.to.changedStart.value = RangeSliderCtrl
                          .to.currentRangeVal.value.start
                          .toString();
                      RangeSliderCtrl.to.changedEnd.value = RangeSliderCtrl
                          .to.currentRangeVal.value.end
                          .toString();

                      if (RangeSliderCtrl.to.currentRangeVal.value == val) {
                        ChartCtrl.to.startList.addIf(
                            RangeSliderCtrl.to.changedStart.value ==
                                    RangeSliderCtrl
                                        .to.currentRangeVal.value.start
                                        .toString() &&
                                RangeSliderCtrl.to.changedEnd.value ==
                                    RangeSliderCtrl.to.currentRangeVal.value.end
                                        .toString(),
                            double.parse(
                                RangeSliderCtrl.to.changedStart.value));
                        //end
                        ChartCtrl.to.endList.addIf(
                            RangeSliderCtrl.to.changedStart.value ==
                                    RangeSliderCtrl
                                        .to.currentRangeVal.value.start
                                        .toString() &&
                                RangeSliderCtrl.to.changedEnd.value ==
                                    RangeSliderCtrl.to.currentRangeVal.value.end
                                        .toString(),
                            double.parse(RangeSliderCtrl.to.changedEnd.value));
                        // debugPrint('StartList : ${ChartCtrl.to.startList}');
                      } else {
                        debugPrint('레인지 변화 없음.');
                      }
                    },
                    values: RangeSliderCtrl.to.currentRangeVal.value,
                    //divisions: ChartCtrl.to.rangeList.length,
                  )
                : Text('Press Apply to Select Wavelength');
          })
        ],
      ),
    );
  }
}

class RangeSliderCtrl extends GetxController {
  static RangeSliderCtrl get to => Get.find();
  RxDouble originStart = 0.0.obs;
  RxDouble originEnd = 0.0.obs;
  Rx<RangeValues> currentRangeVal = const RangeValues(10, 30).obs;
  RxBool disabledBtn = false.obs;
  RxString changedStart = ''.obs;
  RxString changedEnd = ''.obs;
  // late Rx<RangeWaveLength> rwl;
  RxDouble maxVal = 0.0.obs;
  RxDouble minVal = 0.0.obs;
  void minMaxFunc() {
    if (ChartCtrl.to.enableApply.value == true &&
        ChartCtrl.to.rangeList.isNotEmpty) {
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
