import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/view/page/left_chart_pg.dart';
import 'package:wgs_viewer/view/widget/right_chart_widget.dart';

class RightChartPg extends StatelessWidget {
  const RightChartPg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //right Chat 클릭 하면, right Chart만 보이게 하기.
        Get.find<ChartCtrl>().visibleMode.value = 1;
      },
      onDoubleTap: () {
        //right Chat 더블 클릭 하면, 양쪽 차트 다 보이게 하기.
        Get.find<ChartCtrl>().visibleMode.value = 2;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 10,
            child: RightChartWidget(),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                  onPressed: () {
                    DateTime current = DateTime.now();
                    ChartCtrl.to.fileName.value =
                        DateFormat('yyyyMMdd_HHmmss').format(current);
                    exportCSV(name: "Wavelength", data: []);
                  },
                  icon: const Icon(
                    Icons.file_copy_outlined,
                    size: 20,
                  ),
                  label: const Text('Export'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
