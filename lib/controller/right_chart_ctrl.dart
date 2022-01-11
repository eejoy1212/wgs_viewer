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

  Future<void> updateRightData(int idx) async {
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

      rightSeriesData[idx].clear();
      debugPrint('선택된거 제대로 보냄? : ${FileSelectDropDownCtrl.to.firstFields}');
      // debugPrint('선택된거 시간축? : ${FilePickerCtrl.to.firstLine}');
      for (var b = 1; b < 2049; b++) {
        final x = FileSelectDropDownCtrl.to.selected[idx].fileData[6][b];
        final y = FileSelectDropDownCtrl
            .to.selected[idx].fileData[slectedTimeIdx1 + 7][b];
        rightSeriesData[idx].add(FlSpot(x, y));
      }
    }
    debugPrint('오른쪽 차트 업데이트? : $rightSeriesData');
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
            }
            //축소
            else {
              if (RightChartCtrl.to.minX.value >
                  FilePickerCtrl.to.xTimes.first) {
                RightChartCtrl.to.minX.value -= 3;
                RightChartCtrl.to.maxX.value += 3;
              }
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
                          (FilePickerCtrl.to.xTimes.last / 1000) - 3) {
                    minX.value += 3;
                    maxX.value += 3;
                    print('드래그 증가 min : $minX max: $maxX');
                  }
                } else {
                  if (maxX.value > minX.value &&
                      minX > 0 &&
                      minX < FilePickerCtrl.to.xTimes.last / 1000 &&
                      maxX.value <= FilePickerCtrl.to.xTimes.last / 1000) {
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
