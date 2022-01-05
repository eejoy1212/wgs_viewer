import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';

class RightChartCtrl extends GetxController {
  static RightChartCtrl get to => Get.find();
  RxBool rightDataMode = false.obs;
  RxInt seriesCnt = 0.obs;
  RxList<List<FlSpot>> rightSeriesData = RxList.empty();
  RxDouble yVal = 0.0.obs;
  RxList<double> yValList = RxList.empty();
  RxInt idx = 0.obs;
  Rx<double?> maxXLength = 0.0.obs;
//리스트에 담긴 차트에 그려줄 내용 초기화
  void init() {
    for (var i = 0; i < 99; i++) {
      rightSeriesData.add([]);
    }
  }

  Future<void> updateRightData() async {
/*
오른쪽 차트 :
1. y축은 avg.value(값을 레인지로 평균낸 것) && 시간축 선택 &&
2. x축은 파장 헤더 
*/
    debugPrint(
        'timeselected isTrue?? :${TimeSelectCtrl.to.timeSelected.isTrue}');

    if (TimeSelectCtrl.to.timeSelected.isTrue) {
      //slectedTime은 선택한 시간의 인덱스가
      int slectedTimeIdx = TimeSelectCtrl.to.firstTimeIdx.value;

      for (var a = 0; a < 2; a++) {
        rightSeriesData[a].clear();
        for (var b = 1; b < 2049; b++) {
          idx.value = b - 1;
          yVal.value = FilePickerCtrl.to.forfields[slectedTimeIdx + 7][b];

          //f[선택한 시간인덱스][1~2047]들어옴
          //yValList.add(FilePickerCtrl.to.forfields[slectedTimeIdx][b]);
          // debugPrint('오른쪽의 y축 : $yValList');

          rightSeriesData[a]
              .add(FlSpot(FilePickerCtrl.to.firstLine[idx.value], yVal.value));
        }
        // rightSeriesData[a]
        //     .add(FlSpot(FilePickerCtrl.to.firstLine[idx.value], yVal.value));
        // debugPrint('rightSeriesData[0] : ${rightSeriesData[0]}');
        // debugPrint('rightSeriesData[0] : ${rightSeriesData[1]}');
      }
    }
    update();
  }
}
