import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';

class LeftChartWidget extends StatelessWidget {
  LeftChartWidget({Key? key}) : super(key: key);

  List<LineSeries> lineChart() {
    List<LineSeries> rt = [];
    for (var i = 0; i < ChartCtrl.to.forfields.length; i++) {
      for (var ii = 0; ii < ChartCtrl.to.forfields[i].length; ii++) {
        if (ChartCtrl.to.forfields[i][ii].isNotEmpty) {
          rt.add(lineSeries(ChartCtrl.to.forfields[i][ii]));
        }
      }
    }

    return rt;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SfCartesianChart(
        // annotations: RangeSliderCtrl.to.verticalRA(),
        // trackballBehavior: TrackballBehavior(
        //   // lineWidth: 5,
        //   activationMode: ActivationMode.singleTap,
        //   // Enables the trackball
        //   enable: true,
        //   markerSettings: TrackballMarkerSettings(
        //       markerVisibility: TrackballVisibilityMode.visible),
        // ),
        primaryXAxis: NumericAxis(
          plotBands: RangeSliderCtrl.to.verticalPB(),
        ),
        // <CartesianChartAnnotation>[
        //   // first annotation
        //   CartesianChartAnnotation(
        //     widget: Container(
        //       child: const Text(
        //         'Here',
        //       ),

        //       // Container(
        //       // color: Colors.red,
        //       // width: 200,
        //       // ),
        //     ),
        //     coordinateUnit: CoordinateUnit.point,
        //     x: TimeSelectCtrl.to.timeIdxList.isEmpty
        //         ? 0.0
        //         : TimeSelectCtrl
        //             .to.timeIdxList[TimeSelectCtrl.to.firstTimeIdx.value],
        //     // y: 6,
        //   ),
        // ],
        zoomPanBehavior: ZoomPanBehavior(
            enableDoubleTapZooming: true,
            enableMouseWheelZooming: true,
            enablePanning: true,
            enablePinching: true,
            //사각형으로 영역선택하는 것
            enableSelectionZooming: true,
            selectionRectBorderColor: Colors.red,
            selectionRectBorderWidth: 1,
            selectionRectColor: Colors.grey
            //사각형으로 영역선택하는 것
            ),
        // primaryXAxis: CategoryAxis(),
        // Chart title
        title: ChartTitle(text: 'left chart'),
        // Enable legend
        legend: Legend(isVisible: true, toggleSeriesVisibility: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: lineChart(),
      );
    });
  }
}

class WGSspot {
  WGSspot(this.xVal, this.yVal);

  final dynamic xVal;
  final double yVal;
}

LineSeries<WGSspot, double> lineSeries(List<WGSspot> data) {
  return LineSeries<WGSspot, double>(
    dataSource: data,
    xValueMapper: (WGSspot oesData, _) => oesData.xVal,
    yValueMapper: (WGSspot oesData, _) => oesData.yVal,
  );
}
