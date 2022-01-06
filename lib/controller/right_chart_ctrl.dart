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
  RxDouble yVal2 = 0.0.obs;
  RxList<double> yValList = RxList.empty();
  RxInt idx = 0.obs;
  Rx<double?> maxXLength = 0.0.obs;
//리스트에 담긴 차트에 그려줄 내용 초기화
  void init() {
    for (var i = 0; i < 99; i++) {
      rightSeriesData.add([]);
    }
  }

  Future<void> updateRightData1() async {
/*
오른쪽 차트 :
1. y축은 avg.value(값을 레인지로 평균낸 것) && 시간축 선택 &&
2. x축은 파장 헤더 
*/
    debugPrint(
        'timeselected isTrue?? :${TimeSelectCtrl.to.timeSelected.isTrue}');

    if (TimeSelectCtrl.to.timeSelected.isTrue) {
      //slectedTime은 선택한 시간의 인덱스가
      int slectedTimeIdx1 = TimeSelectCtrl.to.firstTimeIdx.value;

      rightSeriesData[0].clear();
      for (var b = 1; b < 2049; b++) {
        idx.value = b - 1;
        yVal.value =
            FileSelectDropDownCtrl.to.firstFields[slectedTimeIdx1 + 7][b];
        //f[선택한 시간인덱스][1~2047]들어옴
        //yValList.add(FilePickerCtrl.to.forfields[slectedTimeIdx][b]);
        // debugPrint('오른쪽의 y축 : $yValList');

        rightSeriesData[0]
            .add(FlSpot(FilePickerCtrl.to.firstLine[idx.value], yVal.value));
      }
      // rightSeriesData[a]
      //     .add(FlSpot(FilePickerCtrl.to.firstLine[idx.value], yVal.value));
      // debugPrint('rightSeriesData[0] : ${rightSeriesData[0]}');
      // debugPrint('rightSeriesData[0] : ${rightSeriesData[1]}');

    }
    update();
  }

  void updateRightData2() async {
/*
오른쪽 차트 :
1. y축은 avg.value(값을 레인지로 평균낸 것) && 시간축 선택 &&
2. x축은 파장 헤더 
*/
    debugPrint(
        'timeselected isTrue?? :${TimeSelectCtrl.to.timeSelected.isTrue}');

    if (TimeSelectCtrl.to.timeSelected.isTrue) {
      //slectedTime은 선택한 시간의 인덱스가
      int slectedTimeIdx2 = TimeSelectCtrl.to.secondTimeIdx.value;

      rightSeriesData[1].clear();
      for (var b = 1; b < 2049; b++) {
        idx.value = b - 1;
        // debugPrint('왜 없어 : ${FileSelectDropDownCtrl.to.secondFields[7][1]}');
        yVal2.value = await FileSelectDropDownCtrl
            .to.secondFields[slectedTimeIdx2 + 7][b];
        //f[선택한 시간인덱스][1~2047]들어옴
        //yValList.add(FilePickerCtrl.to.forfields[slectedTimeIdx][b]);
        // debugPrint('오른쪽의 y축 : $yValList');

        rightSeriesData[1]
            .add(FlSpot(FilePickerCtrl.to.firstLine[idx.value], yVal2.value));
      }
      // rightSeriesData[a]
      //     .add(FlSpot(FilePickerCtrl.to.firstLine[idx.value], yVal.value));
      // debugPrint('rightSeriesData[0] : ${rightSeriesData[0]}');
      // debugPrint('rightSeriesData[0] : ${rightSeriesData[1]}');

    }
    update();
  }
}
