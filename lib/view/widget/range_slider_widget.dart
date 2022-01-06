import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';

class RangeSliders extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: 500,
      child: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DottedBorder(
                  color: Colors.white,
                  child: Text('Wavelength 1 :'),
                ),
                Obx(() {
                  return RangeSliderCtrl.to.vStart.isNotEmpty
                      ? Text(
                          '${RangeSliderCtrl.to.vStart[0].toStringAsFixed(3)} ~${RangeSliderCtrl.to.vEnd[0].toStringAsFixed(3)}')
                      : Text('-');
                })
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
              ignoring: FilePickerCtrl.to.firstLine.isEmpty ||
                  RangeSliderCtrl.to.currentRv.isEmpty,
              child: RangeSlider(
                onChanged: (RangeValues v) {
                  RangeSliderCtrl.to.currentRv[0] = v;
                  //v.start는 값이 아니라 인덱스임
                  RangeSliderCtrl.to.vStart[0] =
                      FilePickerCtrl.to.firstLine[v.start.round()];
                  RangeSliderCtrl.to.vEnd[0] =
                      FilePickerCtrl.to.firstLine[v.end.round()];
// debugPrint('currentRv length && currentRv[0] && RangeSliderCtrl.to.currentRv && currentRv2 : ${RangeSliderCtrl.to.currentRv.length} && ${RangeSliderCtrl.to.currentRv[0]} && ${RangeSliderCtrl.to.currentRv[1]} && ${RangeSliderCtrl.to.currentRv[2]}');
                  debugPrint('onChanged Idx: ${RangeSliderCtrl.to.currentRv}');
                },
                values: FilePickerCtrl.to.firstLine.isNotEmpty &&
                        RangeSliderCtrl.to.currentRv.isNotEmpty
                    ? RangeSliderCtrl.to.currentRv[0]
                    : const RangeValues(0, 0),
                min: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.first)
                        .toDouble()
                    : 0,
                max: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                        .toDouble()
                    : 1,
                divisions: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                    : 1,
                labels: RangeLabels(
                    RangeSliderCtrl.to.vStart.isNotEmpty
                        ? RangeSliderCtrl.to.vStart[0].toStringAsFixed(3)
                        : '0',
                    RangeSliderCtrl.to.vEnd.isNotEmpty
                        ? RangeSliderCtrl.to.vEnd[0].toStringAsFixed(3)
                        : '0'),
              ),
            );
          }),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DottedBorder(
                  color: Colors.white,
                  child: Text('Wavelength 2 :'),
                ),
                Obx(() {
                  return RangeSliderCtrl.to.vStart.isNotEmpty
                      ? Text(
                          '${RangeSliderCtrl.to.vStart[1].toStringAsFixed(3)} ~${RangeSliderCtrl.to.vEnd[1].toStringAsFixed(3)}')
                      : Text('-');
                })
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
              ignoring: FilePickerCtrl.to.firstLine.isEmpty ||
                  RangeSliderCtrl.to.currentRv.isEmpty,
              child: RangeSlider(
                onChanged: (RangeValues v) {
                  RangeSliderCtrl.to.currentRv[1] = v;
                  //v.start는 값이 아니라 인덱스임
                  RangeSliderCtrl.to.vStart[1] =
                      FilePickerCtrl.to.firstLine[v.start.round()];
                  RangeSliderCtrl.to.vEnd[1] =
                      FilePickerCtrl.to.firstLine[v.end.round()];
// debugPrint('currentRv length && currentRv[0] && RangeSliderCtrl.to.currentRv && currentRv2 : ${RangeSliderCtrl.to.currentRv.length} && ${RangeSliderCtrl.to.currentRv[0]} && ${RangeSliderCtrl.to.currentRv[1]} && ${RangeSliderCtrl.to.currentRv[2]}');
                  debugPrint(
                      'firstLine length && onChanged : ${FilePickerCtrl.to.firstLine.length} ${RangeSliderCtrl.to.currentRv}');
                },
                values: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? RangeSliderCtrl.to.currentRv[1]
                    : const RangeValues(0, 0),
                min: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.first)
                        .toDouble()
                    : 0,
                max: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                        .toDouble()
                    : 1,
                divisions: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                    : 1,
                labels: RangeLabels(
                    RangeSliderCtrl.to.vStart[1].toStringAsFixed(3),
                    RangeSliderCtrl.to.vEnd[1].toStringAsFixed(3)),
              ),
            );
          }),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DottedBorder(
                  color: Colors.white,
                  child: Text('Wavelength 3 :'),
                ),
                Obx(() {
                  return RangeSliderCtrl.to.vStart.isNotEmpty
                      ? Text(
                          '${RangeSliderCtrl.to.vStart[2].toStringAsFixed(3)} ~${RangeSliderCtrl.to.vEnd[2].toStringAsFixed(3)}')
                      : Text('-');
                })
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
              ignoring: FilePickerCtrl.to.firstLine.isEmpty ||
                  RangeSliderCtrl.to.currentRv.isEmpty,
              child: RangeSlider(
                onChanged: (RangeValues v) {
                  RangeSliderCtrl.to.currentRv[2] = v;
                  //v.start는 값이 아니라 인덱스임
                  RangeSliderCtrl.to.vStart[2] =
                      FilePickerCtrl.to.firstLine[v.start.round()];
                  RangeSliderCtrl.to.vEnd[2] =
                      FilePickerCtrl.to.firstLine[v.end.round()];
// debugPrint('currentRv length && currentRv[0] && RangeSliderCtrl.to.currentRv && currentRv2 : ${RangeSliderCtrl.to.currentRv.length} && ${RangeSliderCtrl.to.currentRv[0]} && ${RangeSliderCtrl.to.currentRv[1]} && ${RangeSliderCtrl.to.currentRv[2]}');
                  debugPrint(
                      'firstLine length && onChanged : ${FilePickerCtrl.to.firstLine.length} ${RangeSliderCtrl.to.currentRv}');
                },
                values: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? RangeSliderCtrl.to.currentRv[2]
                    : const RangeValues(0, 0),
                min: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.first)
                        .toDouble()
                    : 0,
                max: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                        .toDouble()
                    : 1,
                divisions: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                    : 1,
                labels: RangeLabels(
                    RangeSliderCtrl.to.vStart[2].toStringAsFixed(3),
                    RangeSliderCtrl.to.vEnd[2].toStringAsFixed(3)),
              ),
            );
          }),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DottedBorder(
                  color: Colors.white,
                  child: Text('Wavelength 4 :'),
                ),
                Obx(() {
                  return RangeSliderCtrl.to.vStart.isNotEmpty
                      ? Text(
                          '${RangeSliderCtrl.to.vStart[3].toStringAsFixed(3)} ~${RangeSliderCtrl.to.vEnd[3].toStringAsFixed(3)}')
                      : Text('-');
                })
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
              ignoring: FilePickerCtrl.to.firstLine.isEmpty ||
                  RangeSliderCtrl.to.currentRv.isEmpty,
              child: RangeSlider(
                onChanged: (RangeValues v) {
                  RangeSliderCtrl.to.currentRv[3] = v;
                  //v.start는 값이 아니라 인덱스임
                  RangeSliderCtrl.to.vStart[3] =
                      FilePickerCtrl.to.firstLine[v.start.round()];
                  RangeSliderCtrl.to.vEnd[3] =
                      FilePickerCtrl.to.firstLine[v.end.round()];
// debugPrint('currentRv length && currentRv[0] && RangeSliderCtrl.to.currentRv && currentRv2 : ${RangeSliderCtrl.to.currentRv.length} && ${RangeSliderCtrl.to.currentRv[0]} && ${RangeSliderCtrl.to.currentRv[1]} && ${RangeSliderCtrl.to.currentRv[2]}');
                  debugPrint(
                      'firstLine length && onChanged : ${FilePickerCtrl.to.firstLine.length} ${RangeSliderCtrl.to.currentRv}');
                },
                values: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? RangeSliderCtrl.to.currentRv[3]
                    : const RangeValues(0, 0),
                min: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.first)
                        .toDouble()
                    : 0,
                max: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                        .toDouble()
                    : 1,
                divisions: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                    : 1,
                labels: RangeLabels(
                    RangeSliderCtrl.to.vStart[3].toStringAsFixed(3),
                    RangeSliderCtrl.to.vEnd[3].toStringAsFixed(3)),
              ),
            );
          }),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DottedBorder(
                  color: Colors.white,
                  child: Text('Wavelength 5 :'),
                ),
                Obx(() {
                  return RangeSliderCtrl.to.vStart.isNotEmpty
                      ? Text(
                          '${RangeSliderCtrl.to.vStart[4].toStringAsFixed(3)} ~${RangeSliderCtrl.to.vEnd[4].toStringAsFixed(3)}')
                      : Text('-');
                })
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
              ignoring: FilePickerCtrl.to.firstLine.isEmpty ||
                  RangeSliderCtrl.to.currentRv.isEmpty,
              child: RangeSlider(
                onChanged: (RangeValues v) {
                  RangeSliderCtrl.to.currentRv[4] = v;
                  //v.start는 값이 아니라 인덱스임
                  RangeSliderCtrl.to.vStart[4] =
                      FilePickerCtrl.to.firstLine[v.start.round()];
                  RangeSliderCtrl.to.vEnd[4] =
                      FilePickerCtrl.to.firstLine[v.end.round()];
// debugPrint('currentRv length && currentRv[0] && RangeSliderCtrl.to.currentRv && currentRv2 : ${RangeSliderCtrl.to.currentRv.length} && ${RangeSliderCtrl.to.currentRv[0]} && ${RangeSliderCtrl.to.currentRv[1]} && ${RangeSliderCtrl.to.currentRv[2]}');
                  debugPrint(
                      'firstLine length && onChanged : ${FilePickerCtrl.to.firstLine.length} ${RangeSliderCtrl.to.currentRv}');
                },
                values: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? RangeSliderCtrl.to.currentRv[4]
                    : const RangeValues(0, 0),
                min: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.first)
                        .toDouble()
                    : 0,
                max: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                        .toDouble()
                    : 1,
                divisions: FilePickerCtrl.to.firstLine.isNotEmpty
                    ? FilePickerCtrl.to.firstLine
                        .indexOf(FilePickerCtrl.to.firstLine.last)
                    : 1,
                labels: RangeLabels(
                    RangeSliderCtrl.to.vStart[4].toStringAsFixed(3),
                    RangeSliderCtrl.to.vEnd[4].toStringAsFixed(3)),
              ),
            );
          }),
        ],
      ),
    );
  }
}
