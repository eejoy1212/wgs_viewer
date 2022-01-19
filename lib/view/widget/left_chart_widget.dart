import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';

class LeftChartWidget extends StatelessWidget {
  final leftScroller = ScrollController();

  List<LineSeries<WGSspot, dynamic>> lineChart() {
    List<LineSeries<WGSspot, dynamic>> rt = [];
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
        primaryXAxis: NumericAxis(
          plotBands: RangeSliderCtrl.to.isPbShow.isFalse
              ? null
              : RangeSliderCtrl.to.verticalPB(),
        ),
        zoomPanBehavior: ChartCtrl.to.zoomPan.value,
        onZoomStart: (z) {
          // debugPrint('current zoom position : ${z.currentZoomPosition}');
        },
        onChartTouchInteractionDown: (tapArgs) {
          debugPrint('longpressed ?  ${tapArgs.position.distance}');
          debugPrint(
              'onChartTouchInteractionDown: (x: ${tapArgs.position.dx.toString()} , y: ${tapArgs.position.dx.toString()})');
        },
        // palette: [
        //   Colors.black,
        // ],
        // selectionGesture: ActivationMode.longPress,

        onLegendItemRender: (args) {
          int f = args.seriesIndex! ~/ 5;
          int w = args.seriesIndex! % 5;
          args.text = 'F${f + 1}-W${w + 1}';
        },
        selectionType: SelectionType.series,
        title: ChartTitle(text: 'chart 1'),
        // Enable legend
        legend: Legend(
          isVisible: true,
          toggleSeriesVisibility: true,
        ),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(
          enable: true,
        ),
        series: lineChart(),
      );
    });
  }
}

class WGSspot {
  WGSspot(this.xVal, this.yVal);

  final dynamic xVal;
  final dynamic yVal;
}

LineSeries<WGSspot, dynamic> lineSeries(List<WGSspot> data) {
  return LineSeries<WGSspot, dynamic>(
    dataSource: data,
    animationDuration: 0,
    xValueMapper: (WGSspot oesData, _) => oesData.xVal,
    yValueMapper: (WGSspot oesData, _) => oesData.yVal,
    legendIconType: LegendIconType.seriesType,
  );
}
