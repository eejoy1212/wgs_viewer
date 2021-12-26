import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

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
  RxList<List<FlSpot>> leftChartData = RxList.empty();
  RxList<List<FlSpot>> rightChartData = RxList.empty();
  RxBool leftDataMode = false.obs;
  RxBool rightDataMode = false.obs;
  RxInt tempFileNum = 50.obs;
  RxInt tempWaveNum = 10.obs;
  List tempXdata = [];
  List tempYdata = [];
/*
1. 만약에 leftChartSignal==true면,
2. count(==(아래 메뉴에서 파일 선택한 갯수)*(왼쪽 메뉴에서 파장 선택한 갯수))대로 시리즈가 들어오고,
3.  leftChartData의 FlSpot에서 x축 , y축 값을 .add한다.
*/
/*  
<예시>
if (nChannel == true) {
        for (var i = 0; i < Get.find<iniController>().OES_Count.value; i++) {
          for (var x = 0; x < listWavelength.length; x++) {
            oesData[i].add(FlSpot(listWavelength[x], fmtSpec[x]));
          }
        }
      }
*/
  void updateLeftData() {
    if (leftDataMode.value == true) {
      for (var i = 0; i < tempFileNum.value * tempWaveNum.value; i++) {
        for (var j = 0; j < 2048; j++) {
          leftChartData[i].add(FlSpot(tempXdata[j], tempYdata[j]));
        }
      }
    }

    update();
  }

// double setRandom() {
//   double yValue = 1800 + math.Random().nextInt(500).toDouble();
//   return yValue;
// }

//       Future<void> updateSimulation(Timer timer) async {
//      if (oneData.isNotEmpty) {
//        oneData.clear();
//        twoData.clear();
//        threeData.clear();
//        fourData.clear();
//        fiveData.clear();
//        sixData.clear();
//        sevenData.clear();
//        eightData.clear();
//      }
//      for (double i = 190; i < 760; i++) {
//        oneData.add(FlSpot(i, setRandom()));
//        twoData.add(FlSpot(i, setRandom()));
//        threeData.add(FlSpot(i, setRandom()));
//        fourData.add(FlSpot(i, setRandom()));
//        fiveData.add(FlSpot(i, setRandom()));
//        sixData.add(FlSpot(i, setRandom()));
//        sevenData.add(FlSpot(i, setRandom()));
//        eightData.add(FlSpot(i, setRandom()));
//      }
//      if (Get.find<CsvController>().fileSave.value)
//        await Get.find<CsvController>().csvSave();
//      if (Get.find<CsvController>().fileSave2.value)
//        await Get.find<CsvController>().SecondcsvSave();
//      if (Get.find<CsvController>().fileSave3.value)
//        await Get.find<CsvController>().ThirdcsvSave();
//      if (Get.find<CsvController>().fileSave4.value)
//        await Get.find<CsvController>().FourthcsvSave();
//      if (Get.find<CsvController>().fileSave5.value)
//        await Get.find<CsvController>().FifthcsvSave();
//      if (Get.find<CsvController>().fileSave6.value)
//        await Get.find<CsvController>().SixthcsvSave();
//      if (Get.find<CsvController>().fileSave7.value)
//        await Get.find<CsvController>().SeventhcsvSave();
//      if (Get.find<CsvController>().fileSave8.value)
//        await Get.find<CsvController>().EightcsvSave();
//      update();
//    }

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
              children: [
                Text('Wavelength 1'),
              ],
            ),
          ),
          SfRangeSlider(
            min: 0,
            max: 100,
            interval: 20,
            inactiveColor: Colors.blueGrey[50],
            onChanged: (dynamic value) {
              setState(() {
                _rangevalues = value;
              });
            },
            values: _rangevalues,
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Wavelength 2'),
              ],
            ),
          ),
          SfRangeSlider(
            min: 0,
            max: 100,
            interval: 20,
            inactiveColor: Colors.blueGrey[50],
            onChanged: (dynamic value) {
              setState(() {
                _rangevalues = value;
              });
            },
            values: _rangevalues,
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Wavelength 3'),
              ],
            ),
          ),
          SfRangeSlider(
            min: 0,
            max: 100,
            interval: 20,
            inactiveColor: Colors.blueGrey[50],
            onChanged: (dynamic value) {
              setState(() {
                _rangevalues = value;
              });
            },
            values: _rangevalues,
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Wavelength 4'),
              ],
            ),
          ),
          SfRangeSlider(
            min: 0,
            max: 100,
            interval: 20,
            inactiveColor: Colors.blueGrey[50],
            onChanged: (dynamic value) {
              setState(() {
                _rangevalues = value;
              });
            },
            values: _rangevalues,
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text('Wavelength 5'),
              ],
            ),
          ),
          SfRangeSlider(
            min: 0,
            max: 100,
            interval: 20,
            inactiveColor: Colors.blueGrey[50],
            onChanged: (dynamic value) {
              setState(() {
                _rangevalues = value;
              });
            },
            values: _rangevalues,
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }
}
