import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/model/range_slider_model.dart';

class WGSRangeSlidersWidget extends StatelessWidget {
  const WGSRangeSlidersWidget(
      {Key? key, required this.idx, required this.rsModel})
      : super(key: key);
  final int idx;
  final RangeSliderModel rsModel;

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width: 500,
      child: Column(
        children: [
          ///////첫번째 레인지슬라이더
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              children: [
                SizedBox(
                  child: DottedBorder(
                    color: Colors.white,
                    child: Text('Wavelength ${idx + 1}'),
                  ),
                ),
                Obx(
                  () => IgnorePointer(
                    ignoring: FilePickerCtrl.to.oesFD.isEmpty,
                    child: Checkbox(
                        value: rsModel.isChecked.value,
                        onChanged: (val) {
                          if (val != null) {
                            if (RangeSliderCtrl.to.rsModel.isNotEmpty) {
                              rsModel.isChecked.value = val;
                            }
                          }
                        }),
                  ),
                ),
                const Spacer(),
                Obx(() {
                  return FilePickerCtrl.to.xWLs.isEmpty
                      ? Text('-')
                      : RangeSliderCtrl.to.rsModel[idx].vStart.value > 0.0
                          ? Text(
                              '${RangeSliderCtrl.to.rsModel[idx].vStart.toStringAsFixed(3)} ~${RangeSliderCtrl.to.rsModel[idx].vEnd.toStringAsFixed(3)}')
                          : Text(
                              '${FilePickerCtrl.to.xWLs.first.toStringAsFixed(3)} ~${FilePickerCtrl.to.xWLs.last.toStringAsFixed(3)}');
                })
              ],
            ),
          ),
          Obx(() {
            //file select onPessed 할 때 enableRangeSelect=true 해 주기
            return IgnorePointer(
                ignoring: FilePickerCtrl.to.oesFD.isEmpty ||
                    FilePickerCtrl.to.xWLs.isEmpty ||
                    RangeSliderCtrl.to.rsModel.isEmpty ||
                    rsModel.isChecked.isFalse,
                child: RangeSlider(
                  activeColor: FilePickerCtrl.to.oesFD.isEmpty ||
                          FilePickerCtrl.to.xWLs.isEmpty ||
                          RangeSliderCtrl.to.rsModel.isEmpty ||
                          rsModel.isChecked.isFalse
                      ? Colors.grey
                      : Colors.blue,
                  onChanged: (RangeValues v) {
                    RangeSliderCtrl.to.rsModel[idx].rv.value = v;
                    //v.start는 값이 아니라 인덱스임
                    RangeSliderCtrl.to.rsModel[idx].vStart.value =
                        FilePickerCtrl.to.xWLs[v.start.round()];
                    RangeSliderCtrl.to.rsModel[idx].vEnd.value =
                        FilePickerCtrl.to.xWLs[v.end.round()];
                  },
                  values: RangeSliderCtrl.to.rsModel[idx].rv.value,
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
                  divisions: FilePickerCtrl.to.xWLs.isNotEmpty
                      ? FilePickerCtrl.to.xWLs
                          .indexOf(FilePickerCtrl.to.xWLs.last)
                      : 1,
                  labels: RangeLabels(
                      RangeSliderCtrl.to.rsModel.isNotEmpty
                          ? RangeSliderCtrl.to.rsModel[idx].vStart.value
                              .toStringAsFixed(3)
                          : '0',
                      RangeSliderCtrl.to.rsModel.isNotEmpty
                          ? RangeSliderCtrl.to.rsModel[idx].vEnd.value
                              .toStringAsFixed(3)
                          : '0'),
                ));
          }),
        ],
      ),
    );
  }
}
