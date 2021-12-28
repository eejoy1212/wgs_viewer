import 'dart:async';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';

class ChartCtrl extends GetxController {
  static ChartCtrl get to => Get.find();
  /*visible mode == 0 ->left chart
  visible mode == 1 ->right chart
  visible mode == 2 ->all chart
  */
  RxInt visibleMode = 2.obs;
  RxDouble rangeStart = 0.0.obs;
  RxDouble rangeEnd = 0.0.obs;
  RxBool leftMode = false.obs;
  RxBool rightMode = false.obs;
  RxList<FlSpot> simData = RxList.empty();
  List<FlSpot> leftChartData = RxList.empty();
  RxList<List<FlSpot>> rightChartData = RxList.empty();
  RxBool leftDataMode = false.obs;
  RxBool rightDataMode = false.obs;
  RxInt tempFileNum = 50.obs;
  RxInt tempWaveNum = 10.obs;
  RxList xAxisData = RxList.empty();
  List<FlSpot> forfields = RxList.empty();
  List<List<FlSpot>> seriesList = RxList.empty();
  Timer? simTimer;
/*
1. 만약에 leftChartSignal==true면,
2. count(==(아래 메뉴에서 파일 선택한 갯수)*(왼쪽 메뉴에서 파장 선택한 갯수))대로 시리즈가 들어오고,
3.  leftChartData의 FlSpot에서 x축 , y축 값을 .add한다.
*/

//랜덤데이터 y 축
  double setRandom() {
    double yValue = 1800 + math.Random().nextInt(500).toDouble();
    return yValue;
  }

//시뮬레이션 업데이트
  Future<void> updateSim(Timer simTimer) async {
    if (simData.isNotEmpty) {
      simData.clear();
    }
    for (double i = 190; i < 760; i++) {
      simData.add(FlSpot(i, setRandom()));
    }

    update();
  }

  double parseTimeFunc() {
    return 0.0;
  }

  Future<void> updateLeftData() async {
    //왼쪽 데이터 signal을 주었을 때
    if (leftDataMode.value == true) {
      //시리즈갯수
      for (var i = 7; i < 13; i++) {
        String time = FilePickerCtrl.to.forfields[i][0];
        //Time을 Double로 parsing해야 함.
        //분
        var substringMin = time.substring(3, 5);
        //초
        var substringSec = time.substring(6).replaceAll(':', '.');
        debugPrint('substringSec : $substringSec');
        for (var j = 1; j < 2048; j++) {
          forfields.add(FlSpot(
              double.parse(substringSec), FilePickerCtrl.to.forfields[i][j]));
        }
      }
    } else {}
    debugPrint('forfields : $forfields');
    //시리즈
    // for (int seriesNum = 0; seriesNum < 5; seriesNum++) {
    //   seriesList.add(forfields);
    //   debugPrint('seriesList length : ${seriesList.length}');
    // }

    debugPrint('seriesList length : ${seriesList.length}');
    update();
  }
}

class RangeSliders extends StatefulWidget {
  @override
  State<RangeSliders> createState() => _RangeSlidersState();
}

class _RangeSlidersState extends State<RangeSliders> {
  SfRangeValues _rangevalues =
      SfRangeValues(ChartCtrl.to.rangeStart.value, ChartCtrl.to.rangeEnd.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: const [
                Text('Wavelength 1'),
              ],
            ),
          ),
          // RangeSlider(
          //   min: 0,
          //   max: 100,
          //   activeColor: RangeSliderCtrl.to.disabledBtn.value
          //       ? Colors.grey
          //       : Colors.blue,
          //   onChanged: (dynamic value) {
          //     setState(() {
          //       _rangevalues = value;
          //     });
          //   },
          //   // values: null,
          // ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Wavelength 2'),
              ],
            ),
          ),
          // RangeSlider(
          //   min: 0,
          //   max: 100,
          //   inactiveColor: Colors.blueGrey[50],
          //   onChanged: (dynamic value) {
          //     setState(() {
          //       _rangevalues = value;
          //     });
          //   },
          // ),
          // SizedBox(height: 50),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0),
          //   child: Row(
          //     children: [
          //       Text('Wavelength 3'),
          //     ],
          //   ),
          // ),
          // RangeSlider(
          //   min: 0,
          //   max: 100,
          //   inactiveColor: Colors.blueGrey[50],
          //   onChanged: (dynamic value) {
          //     setState(() {
          //       _rangevalues = value;
          //     });
          //   },
          // ),
          // SizedBox(height: 50),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0),
          //   child: Row(
          //     children: [
          //       Text('Wavelength 4'),
          //     ],
          //   ),
          // ),
          // RangeSlider(
          //   min: 0,
          //   max: 100,
          //   inactiveColor: Colors.blueGrey[50],
          //   onChanged: (dynamic value) {
          //     setState(() {
          //       _rangevalues = value;
          //     });
          //   },
          // ),
          // SizedBox(height: 50),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0),
          //   child: Row(
          //     children: [
          //       Text('Wavelength 5'),
          //     ],
          //   ),
          // ),
          // RangeSlider(
          //   min: 0,
          //   max: 100,
          //   inactiveColor: Colors.blueGrey[50],
          //   onChanged: (dynamic value) {
          //     setState(() {
          //       _rangevalues = value;
          //     });
          //   },
          // ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}

class RangeWaveLength {
  RangeWaveLength({
    required this.rv,
    required this.vStart,
    required this.vEnd,
    required this.tableX,
    required this.visible,
    required this.color,
    required this.value,
  });

  RangeValues rv;
  double vStart;
  double vEnd;
  List<double> tableX;
  bool visible;
  Color color;
  double value;

  factory RangeWaveLength.init() {
    return RangeWaveLength(
      rv: RangeValues(0, 0),
      vStart: 0.0,
      vEnd: 0.0,
      tableX: [],
      visible: true,
      color: Colors.white,
      value: 0.0,
    );
  }
}

class RangeSliderCtrl extends GetxController {
  static RangeSliderCtrl get to => Get.find();
  RxBool disabledBtn = false.obs;
  late Rx<RangeWaveLength> rwl;
}
