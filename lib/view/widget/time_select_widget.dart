import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/file_select_dropdown_widget.dart';
import 'package:wgs_viewer/view/widget/right_apply_btn.dart';

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
              InkWell(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.blueGrey,
                ),
                onTap: () {
                  Get.find<TimeSelectCtrl>().firstDecrease();
                },
              ),
              GetBuilder<TimeSelectCtrl>(builder: (controller) {
                if ((controller.firstTimeIdx.value > 0) &&
                    (controller.firstTimeIdx.value < 7) &&
                    ChartCtrl.to.xVal.isNotEmpty) {
                  return Text(
                      '${ChartCtrl.to.xVal[controller.firstTimeIdx.value]}');
                } else {
                  return Text('-');
                }
              }),
              InkWell(
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blueGrey,
                ),
                onTap: () {
                  Get.find<TimeSelectCtrl>().firstIncrease();
                },
              ),
              const Spacer(),
              Row(
                children: [
                  const RightApplyBtn(),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xffD83737),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'File Delete',
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
                  FirstTimeBtnWidget(),

                  GetBuilder<TimeSelectCtrl>(builder: (controller) {
                    if ((controller.secondTimeIdx.value > 0) &&
                        (controller.secondTimeIdx.value < 7) &&
                        ChartCtrl.to.xVal.isNotEmpty) {
                      return Text(
                          '${ChartCtrl.to.xVal[controller.secondTimeIdx.value]}');
                    } else {
                      return Text('-');
                    }
                  }),

                  InkWell(
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueGrey,
                    ),
                    onLongPress: () {
                      Get.find<TimeSelectCtrl>().secondIncrease();
                    },
                    onTap: () {
                      Get.find<TimeSelectCtrl>().secondIncrease();
                    },
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff5AEDCA),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xffD83737),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'File Delete',
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
              FileSelectDropDown()
            ],
          ),
        ],
      ),
    );
  }

  Widget FirstTimeBtnWidget() {
    return InkWell(
      child: const Icon(
        Icons.arrow_back_ios,
        color: Colors.blueGrey,
      ),
      onTap: () {
        Get.find<TimeSelectCtrl>().secondDecrease();
      },
    );
  }
}
