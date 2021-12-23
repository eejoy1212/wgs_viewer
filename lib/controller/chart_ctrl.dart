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
