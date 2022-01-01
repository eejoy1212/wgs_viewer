import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';

class RightChartCtrl extends GetxController {
  static RightChartCtrl get to => Get.find();
  RxBool rightDataMode = false.obs;
  RxInt seriesCnt = 0.obs;
  RxList<List<FlSpot>> rightSeriesData = RxList.empty();
  RxDouble yVal = 0.0.obs;
//리스트에 담긴 차트에 그려줄 내용 초기화
  void init() {
    for (var i = 0; i < 99; i++) {
      rightSeriesData.add([]);
    }
  }

  Future<void> updateRightData() async {
    //시리즈 갯수==FileSelectDropDownCtrl.to.firstList.length+FileSelectDropDownCtrl.to.secondList.length
    seriesCnt.value = FileSelectDropDownCtrl.to.firstList.length;
    for (var i = 0; i < seriesCnt.value; i++) {
      rightSeriesData[i].clear();
    }
//시간축
    for (var ii = 7; ii < 14; ii++) {
      int idx = ii - 7;
      yVal.value = 0.0;
      for (var iii = 0; iii < seriesCnt.value; iii++) {
        rightSeriesData[ii].add(FlSpot(idx.toDouble(), yVal.value));
      }
    }
    debugPrint('업데이트?? : $rightSeriesData');
    update();
  }
}
