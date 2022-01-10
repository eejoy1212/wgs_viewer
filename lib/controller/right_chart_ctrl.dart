import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  Rx<Color> selectedColor = Colors.blueGrey.obs;
  Rx<Color> selectedColor2 = Colors.indigo.obs;
  RxDouble minX = 0.0.obs;
  RxDouble maxX = 0.0.obs;
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
        rightSeriesData[0]
            .add(FlSpot(FilePickerCtrl.to.firstLine[idx.value], yVal.value));
      }
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
    }
    update();
  }

  zoomFunction({required Widget child}) {
    return Listener(
        onPointerSignal: (signal) {
          if (signal is PointerScrollEvent) {
            //확대
            if (signal.scrollDelta.dy.isNegative) {
              if (maxX.value - 6 > minX.value) {
                minX.value += 3;
                maxX.value -= 3;
              }
              debugPrint(
                  '확대minxxxxxxxxxx : $minX max: $maxX  ${TimeSelectCtrl.to.timeIdxList.last}');

              debugPrint(
                  'x축 마지막값 비어있나?? ${TimeSelectCtrl.to.timeIdxList.last}');
            }
            //축소
            else {
              debugPrint(
                  'x축 마지막값 비어있나?? ${TimeSelectCtrl.to.timeIdxList.last}');
              // RightChartCtrl.to.minX.value -= 3;
              // RightChartCtrl.to.maxX.value += 3;
              if (RightChartCtrl.to.minX.value > 0 &&
                  RightChartCtrl.to.maxX.value <
                      TimeSelectCtrl.to.timeIdxList.last / 1000) {
                debugPrint('1 if : true');
                RightChartCtrl.to.minX.value -= 3;
                RightChartCtrl.to.maxX.value += 3;
              }
              if (RightChartCtrl.to.maxX.value + 3 ==
                      TimeSelectCtrl.to.timeIdxList.last / 1000 &&
                  RightChartCtrl.to.minX.value > 0) {
                debugPrint('2 if : true');
                RightChartCtrl.to.minX.value -= 3;
              }
              if (RightChartCtrl.to.minX.value == 0 &&
                  RightChartCtrl.to.maxX.value <
                      TimeSelectCtrl.to.timeIdxList.last / 1000) {
                debugPrint('3 if : true');
                RightChartCtrl.to.maxX.value += 3;
              }
              if (RightChartCtrl.to.maxX.value ==
                      TimeSelectCtrl.to.timeIdxList.last / 1000 &&
                  RightChartCtrl.to.minX.value > 0) {
                debugPrint('4 if : true');
                RightChartCtrl.to.minX.value -= 3;
              }

              debugPrint('축소 minxxxxxxxx : $minX max: $maxX');
            }
          }
        },
        child: GestureDetector(
            onHorizontalDragUpdate: (dragUpdate) {
              double primeDelta = dragUpdate.primaryDelta ?? 0.0;
              if (primeDelta != 0) {
                if (primeDelta.isNegative) {
                  if (maxX.value > minX.value &&
                      maxX.value <=
                          (TimeSelectCtrl.to.timeIdxList.last / 1000) - 3) {
                    minX.value += 3;
                    maxX.value += 3;
                    print('드래그 증가 min : $minX max: $maxX');
                  }
                } else {
                  if (maxX.value > minX.value &&
                      minX > 0 &&
                      minX < TimeSelectCtrl.to.timeIdxList.last / 1000 &&
                      maxX.value <= TimeSelectCtrl.to.timeIdxList.last / 1000) {
                    minX.value -= 3;
                    maxX.value -= 3;
                    print('드래그 감소 min : $minX max: $maxX');
                  }
                }
              }
              update();
            },
            child: child));
  }
}
