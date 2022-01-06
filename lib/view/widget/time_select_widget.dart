import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/file_select_dropdown_widget.dart';
import 'package:wgs_viewer/view/widget/right_apply_btn.dart';
import 'package:wgs_viewer/view/widget/second_file_select_dropdown_widget.dart';

class TimeSelectTxtForm extends StatelessWidget {
  const TimeSelectTxtForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              DottedBorder(
                  color: Colors.blueGrey, child: const Text('First Time : ')),
              const SizedBox(width: 20),
              Container(
                width: 20,
                height: 20,
                color: RightChartCtrl.to.selectedColor.value,
              ),
              const SizedBox(width: 20),
              Obx(() {
                return Tooltip(
                  message: 'Press Left Apply Button',
                  child: IgnorePointer(
                    ignoring: TimeSelectCtrl.to.ableTimeSelect.isFalse,
                    child: InkWell(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: TimeSelectCtrl.to.ableTimeSelect.isFalse
                            ? Colors.grey
                            : Colors.blueGrey,
                      ),
                      onTap: () {
                        Get.find<TimeSelectCtrl>().firstDecrease();
                      },
                    ),
                  ),
                );
              }),
              GetBuilder<TimeSelectCtrl>(builder: (controller) {
                if (controller.timeIdxList.isEmpty) {
                  return Text('-');
                } else if (controller.firstTimeIdx.isNegative ||
                    controller.firstTimeIdx.value <
                        controller.timeIdxList
                            .indexOf(controller.timeIdxList.first) ||
                    controller.firstTimeIdx.value >
                        controller.timeIdxList
                            .indexOf(controller.timeIdxList.last)) {
                  return Text('${controller.timeIdxList[0]}');
                } else {
                  return Text(
                      '${controller.timeIdxList[controller.firstTimeIdx.value]}');
                }
              }),
              Obx(() {
                return Tooltip(
                  message: 'Press Left Apply Button',
                  child: IgnorePointer(
                    ignoring: TimeSelectCtrl.to.ableTimeSelect.isFalse,
                    child: InkWell(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: TimeSelectCtrl.to.ableTimeSelect.isFalse
                            ? Colors.grey
                            : Colors.blueGrey,
                      ),
                      onTap: () {
                        Get.find<TimeSelectCtrl>().firstIncrease();
                      },
                    ),
                  ),
                );
              }),
              const Spacer(),
              Row(
                children: [
                  const RightApplyBtn(),
                  const SizedBox(
                    width: 20,
                  ),
                  Visibility(
                    visible: false,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffD83737),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'File Delete',
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          FileSelectDropDown(),
          const SizedBox(
            height: 160,
          ),
          ///////////second Time

          Column(
            children: [
              Row(
                children: [
                  DottedBorder(
                      color: Colors.blueGrey,
                      child: const Text('Second Time : ')),
                  const SizedBox(width: 20),
                  Obx(() {
                    return Container(
                      width: 20,
                      height: 20,
                      color: RightChartCtrl.to.selectedColor2.value,
                    );
                  }),
                  const SizedBox(width: 20),
                  FirstTimeBtnWidget(),

                  GetBuilder<TimeSelectCtrl>(builder: (controller) {
                    if (controller.timeIdxList.isEmpty) {
                      return Text('-');
                    } else if (controller.secondTimeIdx.isNegative ||
                        controller.secondTimeIdx.value <
                            controller.timeIdxList
                                .indexOf(controller.timeIdxList.first) ||
                        controller.secondTimeIdx.value >
                            controller.timeIdxList
                                .indexOf(controller.timeIdxList.last)) {
                      return Text('${controller.timeIdxList[0]}');
                    } else {
                      return Text(
                          '${controller.timeIdxList[controller.secondTimeIdx.value]}');
                    }
                  }),
                  Obx(() {
                    return Tooltip(
                      message: 'Press Left Apply Button',
                      child: IgnorePointer(
                        ignoring: TimeSelectCtrl.to.ableTimeSelect.isFalse,
                        child: InkWell(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: TimeSelectCtrl.to.ableTimeSelect.isFalse
                                ? Colors.grey
                                : Colors.blueGrey,
                          ),
                          // onLongPress: () {
                          //   Get.find<TimeSelectCtrl>().secondIncrease();
                          // },
                          onTap: () {
                            Get.find<TimeSelectCtrl>().secondIncrease();
                          },
                          // onDoubleTap: () {
                          //   return null;
                          // },
                        ),
                      ),
                    );
                  }),

                  const Spacer(),
                  Row(
                    children: [
                      Obx(() {
                        return IgnorePointer(
                          ignoring: FilePickerCtrl.to.selectedFileUrls.isEmpty,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  FilePickerCtrl.to.selectedFileName.isEmpty
                                      ? Colors.grey
                                      : Color(0xff5AEDCA),
                            ),
                            onPressed: () async {
                              //오른쪽 함수 부르는거
                              TimeSelectCtrl.to.timeSelected.value = true;
                              RightChartCtrl.to.updateRightData2();
                              RangeSliderCtrl.to.minMaxFunc();
                            },
                            child: const Text(
                              'Apply',
                              style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(
                        width: 20,
                      ),
                      Visibility(
                        visible: false,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xffD83737),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'File Delete',
                          ),
                        ),
                      )
                    ],
                  ),

                  ///////////second Time
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SecondFileSelectDropDown()
            ],
          ),
        ],
      ),
    );
  }

  Widget FirstTimeBtnWidget() {
    return Obx(() {
      return Tooltip(
        message: 'Press Left Apply Button',
        child: IgnorePointer(
            ignoring: TimeSelectCtrl.to.ableTimeSelect.isFalse,
            child: InkWell(
              child: Icon(
                Icons.arrow_back_ios,
                color: TimeSelectCtrl.to.ableTimeSelect.isFalse
                    ? Colors.grey
                    : Colors.blueGrey,
              ),
              onTap: () {
                Get.find<TimeSelectCtrl>().secondDecrease();
              },
            )),
      );
    });
  }
}
