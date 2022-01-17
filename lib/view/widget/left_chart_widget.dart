import 'package:flutter/material.dart';
import 'package:fs_shim/fs.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/file_select_dropdown_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';

class LeftChartWidget extends StatelessWidget {
  LeftChartWidget({Key? key}) : super(key: key);

  List<LineSeries> lineChart() {
    List<LineSeries> rt = [];
    for (var i = 0; i < ChartCtrl.to.forfields.length; i++) {
      for (var ii = 0; ii < ChartCtrl.to.forfields[i].length; ii++) {
        if (ChartCtrl.to.forfields[i][ii].isNotEmpty) {
          rt.add(lineSeries(ChartCtrl.to.forfields[i][ii]));
          debugPrint('시리즈 갯수 : ${rt.length}');
        }
      }
    }

    return rt;
  }

  fileNum() {
    for (var f = 0; f < FilePickerCtrl.to.oesFD.length; f++) {
      debugPrint('filenum : ' + f.toString());
    }
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
        // onLegendItemRender: (args) {
        //   // debugPrint('args.text : ${args.text}');
        //   args.text = (args.seriesIndex! + 1).toString();
        //   for (var f = 0; f < FilePickerCtrl.to.oesFD.length; f++) {
        //     debugPrint('filenum : ' + f.toString());
        //     args.text = (f + 1).toString() +
        //         '번째 파일 - ' +
        //         ((args.seriesIndex! + 1) / FilePickerCtrl.to.oesFD.length)
        //             .toInt()
        //             .toString();
        //   }
        //   debugPrint('ser text : ${args.text}');
        //   debugPrint('ser idx : ${args.seriesIndex}');
        //   // for (var w = 0; w < 5; w++) {
        //   //   ChartCtrl.to.seriesName.add('');
        //   //   ChartCtrl.to.seriesName.add('W$w');

        //   //   debugPrint('seriesName : ${ChartCtrl.to.seriesName}');
        //   // }
        // },
        onZooming: (zoomingArgs) {
          zoomingArgs.currentZoomPosition;
          debugPrint('줌 하는중 : ${zoomingArgs.currentZoomPosition}');
        },
        onZoomReset: (ZoomPanArgs zpArgs) {
          // zoom(zoomPanArgs);
          debugPrint(zpArgs.currentZoomPosition.toString());
        },

        zoomPanBehavior: ZoomPanBehavior(
            zoomMode: ZoomMode.xy,
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

        title: ChartTitle(text: 'chart 1'),
        // Enable legend
        legend: Legend(isVisible: true, toggleSeriesVisibility: true),
        // Enable tooltip
        tooltipBehavior: TooltipBehavior(enable: true),
        series: lineChart(),
      );
    });
  }
}

zoomBtn() {
  return ElevatedButton(
    onPressed: () {},
    child: Text('zoom reset'),
  );
}

class WGSspot {
  WGSspot(this.xVal, this.yVal);

  final dynamic xVal;
  final double yVal;
}

seriesName() {
  List<String> name = [];
  for (var i = 0; i < FilePickerCtrl.to.oesFD.length; i++) {
    if (FilePickerCtrl.to.oesFD[i].isChecked.isTrue) {
      name.add(FilePickerCtrl.to.oesFD[i].fileName);
    }
  }
  debugPrint('name : $name');
  return name.toString();
}

LineSeries<WGSspot, double> lineSeries(List<WGSspot> data) {
  return LineSeries<WGSspot, double>(
    dataSource: data,
    animationDuration: 0,
    xValueMapper: (WGSspot oesData, _) => oesData.xVal,
    yValueMapper: (WGSspot oesData, _) => oesData.yVal,
  );
}
