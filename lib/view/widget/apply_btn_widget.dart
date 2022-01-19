import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';
import 'package:wgs_viewer/main.dart';

class ApplyBtn extends StatelessWidget {
  ApplyBtn({Key? key}) : super(key: key);
  var lastTimeClicked = 0;
  RxBool isHover = false.obs;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IgnorePointer(
          ignoring: FilePickerCtrl.to.oesFD.isEmpty &&
              FilePickerCtrl.to.ableApply.isFalse,
          child: InkWell(
            onHover: (value) {
              isHover.value = value;
            },
            onDoubleTap: () => null,
            onTap: () async {
              debugPrint('tap');
              await ChartCtrl.to.updateLeftData();
              TimeSelectCtrl.to.ableTimeSelect.value = true;
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: FilePickerCtrl.to.oesFD.isEmpty &&
                        FilePickerCtrl.to.ableApply.isFalse
                    ? Colors.grey
                    : isHover == true
                        ? Color(0xff5AEDCA).withOpacity(0.9)
                        : Color(0xff5AEDCA),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              width: 60,
              child: const Center(child: Text('Apply')),
            ),
          )

          ///////////////

          );
    });
  }
}
