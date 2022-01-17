import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/view/widget/right_chart_widget.dart';

class RightChartCtrl extends GetxController {
  static RightChartCtrl get to => Get.find();

  RxBool rightDataMode = false.obs;
  RxInt seriesCnt = 0.obs;
  // RxList<List<FlSpot>> rightSeriesData = RxList.empty();
  RxList<List<OESData>> rightSeriesData = RxList.empty();
  RxDouble yVal = 0.0.obs;
  RxDouble yVal2 = 0.0.obs;
  RxList<double> yValList = RxList.empty();
  RxInt idx = 0.obs;
  Rx<double?> maxXLength = 0.0.obs;
  Rx<Color> selectedColor = Colors.blueGrey.obs;
  Rx<Color> selectedColor2 = Colors.indigo.obs;
  RxDouble minX = 0.0.obs;
  RxDouble maxX = 0.0.obs;
//리스트에 담긴 차트에 그려줄 내용 초기화
  void init() {
    for (var i = 0; i < 2; i++) {
      rightSeriesData.add([]);
    }
  }

  updateRightData(int idx) {
/*
오른쪽 차트 :
1. y축은 avg.value(값을 레인지로 평균낸 것) && 시간축 선택 &&
2. x축은 파장 헤더 
*/
    int slectedTimeIdx1 = TimeSelectCtrl.to.firstTimeIdx.value;
    //list.clear()보다 이게 더 좋음
    rightSeriesData[idx] = List.empty(growable: true);
    for (var b = 1; b < 2049; b++) {
      final x = FileSelectDropDownCtrl.to.selected[idx].fileData[6][b];
      final y = FileSelectDropDownCtrl
          .to.selected[idx].fileData[slectedTimeIdx1 + 7][b];
      rightSeriesData[idx].add(OESData(x, y));

      update();
    }
    RangeSliderCtrl.to.isPbShow.value = true;
    debugPrint('plot band시점 : ${RangeSliderCtrl.to.isPbShow.value}');
  }
}
