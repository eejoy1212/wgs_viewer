import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/model/range_slider_model.dart';
import 'package:wgs_viewer/view/widget/range_slider_widget.dart';

class RangeSliderCtrl extends GetxController {
  static RangeSliderCtrl get to => Get.find();
  RxList<RangeValues> currentRv = RxList.empty();

  RxList<WGSrangeSlider> rsWGS = RxList.empty();
  void init() {
    for (var i = 0; i < 5; i++) {
      // RangeSliderCtrl.to.currentRv.add(RangeValues(0, 0));
      // RangeSliderCtrl.to.vStart.add(0.0);
      // RangeSliderCtrl.to.vEnd.add(0.0);
      rsWGS.add(WGSrangeSlider(
        rv: const RangeValues(0, 0).obs,
        wls: [],
        vStart: 0.0.obs,
        vEnd: 0.0.obs,
      ));
    }
  }

//   List<VerticalRangeAnnotation> verticalRA() {
//     List<VerticalRangeAnnotation> ra = [];
// //시간축을 x1 x2에 넣는거
//     ra.add(VerticalRangeAnnotation(
//       x1: TimeSelectCtrl.to.timeIdxList.isEmpty
//           ? 0.0
//           : TimeSelectCtrl.to.timeIdxList[TimeSelectCtrl.to.firstTimeIdx.value],
//       x2: TimeSelectCtrl.to.timeIdxList.isEmpty
//           ? 0.0
//           : TimeSelectCtrl
//                   .to.timeIdxList[TimeSelectCtrl.to.firstTimeIdx.value] +
//               (TimeSelectCtrl.to.timeIdxList.last / 1000),
//       color: Colors.lightBlue,
//     ));
//     ra.add(VerticalRangeAnnotation(
//       x1: ChartCtrl.to.xVal.isNotEmpty
//           ? ChartCtrl.to.xVal[TimeSelectCtrl.to.secondTimeIdx.value]
//           : 0.0,
//       x2: ChartCtrl.to.xVal.isNotEmpty
//           ? ChartCtrl.to.xVal[TimeSelectCtrl.to.secondTimeIdx.value] +
//               (ChartCtrl.to.xVal.last / 1000)
//           : 0.0,
//       color: Colors.deepOrange,
//     ));

// ////
//     return ra;
//   }

  List<PlotBand>? verticalPB() {
    List<PlotBand>? pb = [];
//시간축을 x1 x2에 넣는거
    pb.add(PlotBand(
      isRepeatable: true,
      shouldRenderAboveSeries: false,
      start: TimeSelectCtrl.to.timeIdxList.isEmpty ||
              TimeSelectCtrl.to.firstTimeIdx.value >
                  TimeSelectCtrl.to.timeIdxList.length - 1 ||
              TimeSelectCtrl.to.firstTimeIdx.value < 0
          ? 0.0
          : TimeSelectCtrl.to.timeIdxList[TimeSelectCtrl.to.firstTimeIdx.value],
      end: TimeSelectCtrl.to.timeIdxList.isEmpty ||
              TimeSelectCtrl.to.firstTimeIdx.value >
                  TimeSelectCtrl.to.timeIdxList.length - 1 ||
              TimeSelectCtrl.to.firstTimeIdx.value < 0
          ? 0.0
          : TimeSelectCtrl
                  .to.timeIdxList[TimeSelectCtrl.to.firstTimeIdx.value] +
              (TimeSelectCtrl.to.timeIdxList.last / 1000),
      color: Colors.lightBlue,
    ));
    pb.add(PlotBand(
      shouldRenderAboveSeries: false,
      start: TimeSelectCtrl.to.timeIdxList.isEmpty ||
              TimeSelectCtrl.to.secondTimeIdx.value >
                  TimeSelectCtrl.to.timeIdxList.length - 1 ||
              TimeSelectCtrl.to.secondTimeIdx.value < 0
          ? 0.0
          : TimeSelectCtrl
              .to.timeIdxList[TimeSelectCtrl.to.secondTimeIdx.value],
      end: TimeSelectCtrl.to.timeIdxList.isEmpty ||
              TimeSelectCtrl.to.secondTimeIdx.value >
                  TimeSelectCtrl.to.timeIdxList.length - 1 ||
              TimeSelectCtrl.to.secondTimeIdx.value < 0
          ? 0.0
          : TimeSelectCtrl
                  .to.timeIdxList[TimeSelectCtrl.to.secondTimeIdx.value] +
              (TimeSelectCtrl.to.timeIdxList.last / 1000),
      color: Colors.deepOrange,
    ));
//
////
    return pb;
  }

  pbRange() {
    var pbRange;
    if (TimeSelectCtrl.to.firstTimeIdx.value >
        TimeSelectCtrl.to.timeIdxList
            .indexOf(TimeSelectCtrl.to.timeIdxList.last)) {
      pbRange = TimeSelectCtrl.to.timeIdxList.first;
    }
    if (TimeSelectCtrl.to.firstTimeIdx.value <
        TimeSelectCtrl.to.timeIdxList
            .indexOf(TimeSelectCtrl.to.timeIdxList.first)) {
      pbRange = TimeSelectCtrl.to.timeIdxList.first;
    }
    if (TimeSelectCtrl.to.secondTimeIdx.value >
        TimeSelectCtrl.to.timeIdxList
            .indexOf(TimeSelectCtrl.to.timeIdxList.last)) {
      pbRange = TimeSelectCtrl.to.timeIdxList.first;
    }
    if (TimeSelectCtrl.to.secondTimeIdx.value <
        TimeSelectCtrl.to.timeIdxList
            .indexOf(TimeSelectCtrl.to.timeIdxList.first)) {
      pbRange = TimeSelectCtrl.to.timeIdxList.first;
    } else {}
    return pbRange;
  }

  //레인지 슬라이더 위젯 여러개 만드는 것

  List<WGSRangeSlidersWidget> rsList() {
    List<WGSRangeSlidersWidget> rs = [];
    for (var i = 0; i < 5; i++) {
      rs.add(WGSRangeSlidersWidget(idx: i));
    }
    return rs;
  }
}
