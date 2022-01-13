import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';

class WGSRangeSlidersWidget extends StatelessWidget {
  const WGSRangeSlidersWidget({Key? key, required this.idx}) : super(key: key);
  final int idx;

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: 500,
      child: Column(
        children: [
          ///////첫번째 레인지슬라이더
          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: DottedBorder(
                    color: Colors.white,
                    child: Text('Wavelength ${idx + 1} :'),
                  ),
                ),
                Obx(() {
                  return RangeSliderCtrl.to.rsWGS.isNotEmpty
                      ? Text(
                          '${RangeSliderCtrl.to.rsWGS[idx].vStart.toStringAsFixed(3)} ~${RangeSliderCtrl.to.rsWGS[idx].vEnd.toStringAsFixed(3)}')
                      : const Text('-');
                })
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
                ignoring: FilePickerCtrl.to.xWLs.isEmpty ||
                    RangeSliderCtrl.to.rsWGS.isEmpty,
                child: Column(
                  children: [
                    SfRangeSlider(
                      activeColor: FilePickerCtrl.to.xWLs.isEmpty ||
                              RangeSliderCtrl.to.rsWGS.isEmpty
                          ? Colors.grey
                          : Colors.blue,
                      values: FilePickerCtrl.to.xWLs.isNotEmpty &&
                              RangeSliderCtrl.to.rsWGS.isNotEmpty
                          ? RangeSliderCtrl.to.rsWGS[idx].rv.value
                          : const SfRangeValues(0, 0),
                      min: FilePickerCtrl.to.xWLs.isNotEmpty
                          ? FilePickerCtrl.to.xWLs
                              .indexOf(FilePickerCtrl.to.xWLs.first)
                              .toDouble()
                          : 0,
                      max: FilePickerCtrl.to.xWLs.isNotEmpty
                          ? FilePickerCtrl.to.xWLs
                              .indexOf(FilePickerCtrl.to.xWLs.last)
                              .toDouble()
                          : 1,

                      //division이 없어..??
                      tooltipShape: const SfPaddleTooltipShape(),
                      // enableTooltip: true,
                      showLabels: true,
                      showTicks: true,
                      // tooltipTextFormatterCallback:
                      // (actualValue, formattedText) {
                      // debugPrint(
                      //     'activeValue || rv: $actualValue || ${RangeSliderCtrl.to.rsWGS[idx].rv.value}');

                      // formattedText = 'aaa';
                      // return formattedText;
                      // },

                      onChanged: (SfRangeValues v) {
                        // RangeSliderCtrl.to.currentRv[idx] = v;

                        RangeSliderCtrl.to.rsWGS[idx].rv.value = v;
                        //v.start는 값이 아니라 인덱스임
                        RangeSliderCtrl.to.rsWGS[idx].vStart.value =
                            FilePickerCtrl.to.xWLs[v.start.round()];
                        RangeSliderCtrl.to.rsWGS[idx].vEnd.value =
                            FilePickerCtrl.to.xWLs[v.end.round()];
                      },
                      // onChangeStart: (v) {
                      //   debugPrint('value.start : ${v.start}');
                      //   RangeSliderCtrl.to.rsWGS[idx].vStart.value =
                      //       FilePickerCtrl.to.xWLs[v.start.round()];
                      // },
                      // onChangeEnd: (v) {
                      //   debugPrint('value.end : ${v.start}');
                      //   RangeSliderCtrl.to.rsWGS[idx].vEnd.value =
                      //       FilePickerCtrl.to.xWLs[v.end.round()];
                      // },
                    ),
                    // RangeSlider(
                    //   activeColor: FilePickerCtrl.to.xWLs.isEmpty ||
                    //           RangeSliderCtrl.to.rsWGS.isEmpty
                    //       ? Colors.grey
                    //       : Colors.blue,
                    //   onChanged: (RangeValues v) {
                    //     // RangeSliderCtrl.to.currentRv[idx] = v;

                    //     RangeSliderCtrl.to.rsWGS[idx].rv.value = v;
                    //     //v.start는 값이 아니라 인덱스임
                    //     RangeSliderCtrl.to.rsWGS[idx].vStart.value =
                    //         FilePickerCtrl.to.xWLs[v.start.round()];
                    //     RangeSliderCtrl.to.rsWGS[idx].vEnd.value =
                    //         FilePickerCtrl.to.xWLs[v.end.round()];
                    //   },
                    //   // values: FilePickerCtrl.to.xWLs.isNotEmpty &&
                    //   //         RangeSliderCtrl.to.rsWGS.isNotEmpty
                    //   //     ? RangeSliderCtrl.to.rsWGS[idx].rv.value
                    //   //     : const RangeValues(0, 0),
                    //   min: FilePickerCtrl.to.xWLs.isNotEmpty
                    //       ? FilePickerCtrl.to.xWLs
                    //           .indexOf(FilePickerCtrl.to.xWLs.first)
                    //           .toDouble()
                    //       : 0,
                    //   max: FilePickerCtrl.to.xWLs.isNotEmpty
                    //       ? FilePickerCtrl.to.xWLs
                    //           .indexOf(FilePickerCtrl.to.xWLs.last)
                    //           .toDouble()
                    //       : 1,
                    //   divisions: FilePickerCtrl.to.xWLs.isNotEmpty
                    //       ? FilePickerCtrl.to.xWLs
                    //           .indexOf(FilePickerCtrl.to.xWLs.last)
                    //       : 1,
                    //   labels: RangeLabels(
                    //       RangeSliderCtrl.to.rsWGS.isNotEmpty
                    //           ? RangeSliderCtrl.to.rsWGS[idx].vStart.value
                    //               .toStringAsFixed(3)
                    //           : '0',
                    //       RangeSliderCtrl.to.rsWGS.isNotEmpty
                    //           ? RangeSliderCtrl.to.rsWGS[idx].vEnd.value
                    //               .toStringAsFixed(3)
                    //           : '0'),
                    // ),
                  ],
                ));
          }),
        ],
      ),
    );
  }
}
