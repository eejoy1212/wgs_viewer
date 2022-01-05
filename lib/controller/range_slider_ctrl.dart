import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';

class RangeSliderCtrl extends GetxController {
  static RangeSliderCtrl get to => Get.find();
  RxDouble originStart = 0.0.obs;
  RxDouble originEnd = 0.0.obs;

  // Rx<RangeValues> currentRv = const RangeValues(0, 0).obs;

  RxList<RangeValues> currentRv = RxList.empty();
  // double vStart = 0.0;
  // double vEnd = 0.0;
  RxList<double> vStart = RxList.empty();
  RxList<double> vEnd = RxList.empty();
  Rx<RangeValues> currentRv2 = const RangeValues(0, 0).obs;
  double vStart2 = 0.0;
  double vEnd2 = 0.0;
  Rx<RangeValues> currentRv3 = const RangeValues(0, 0).obs;
  double vStart3 = 0.0;
  double vEnd3 = 0.0;
  Rx<RangeValues> currentRv4 = const RangeValues(0, 0).obs;
  double vStart4 = 0.0;
  double vEnd4 = 0.0;
  Rx<RangeValues> currentRv5 = const RangeValues(0, 0).obs;
  double vStart5 = 0.0;
  double vEnd5 = 0.0;

  Rx<RangeValues> currentRangeVal2 = const RangeValues(0, 0).obs;

  Rx<RangeValues> currentRangeVal3 = const RangeValues(0, 0).obs;

  Rx<RangeValues> currentRangeVal4 = const RangeValues(0, 0).obs;

  Rx<RangeValues> currentRangeVal5 = const RangeValues(0, 0).obs;
  RxBool disabledBtn = false.obs;
  RxString changedStart = ''.obs;
  RxString changedEnd = ''.obs;
  // late Rx<RangeWaveLength> rwl;
  RxDouble maxVal = 867.901527512498.obs;
  RxDouble minVal = 0.0.obs;
  List<dynamic> minMaxList = RxList.empty();
  // List<Range> rm = RxList.empty();

  void init() {
    for (var i = 0; i < 5; i++) {
      RangeSliderCtrl.to.currentRv.add(RangeValues(0, 0));
      RangeSliderCtrl.to.vStart.add(0.0);
      RangeSliderCtrl.to.vEnd.add(0.0);
    }
  }

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

  List<VerticalRangeAnnotation> verticalRA() {
    List<VerticalRangeAnnotation> ra = [];
//시간축을 x1 x2에 넣는거
    ra.add(VerticalRangeAnnotation(
      x1: ChartCtrl.to.xVal.isNotEmpty
          ? ChartCtrl.to.xVal[TimeSelectCtrl.to.firstTimeIdx.value]
          : 0.0,
      x2: ChartCtrl.to.xVal.isNotEmpty
          ? ChartCtrl.to.xVal[TimeSelectCtrl.to.firstTimeIdx.value] +
              (ChartCtrl.to.xVal.last / 1000)
          : 0.28,
      color: Colors.lightBlue,
    ));
    ra.add(VerticalRangeAnnotation(
      x1: ChartCtrl.to.xVal.isNotEmpty
          ? ChartCtrl.to.xVal[TimeSelectCtrl.to.secondTimeIdx.value]
          : 0.0,
      x2: ChartCtrl.to.xVal.isNotEmpty
          ? ChartCtrl.to.xVal[TimeSelectCtrl.to.secondTimeIdx.value] +
              (ChartCtrl.to.xVal.last / 1000)
          : 0.0,
      color: Colors.deepOrange,
    ));

//////
    debugPrint('annotation : $ra');
    return ra;
  }

  //레인지 선택
  rangeSelectFunc() {}
}
