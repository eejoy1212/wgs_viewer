import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/chart_ctrl.dart';

class RightChartWidget extends StatelessWidget {
  const RightChartWidget({Key? key}) : super(key: key);

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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          color: Colors.pink,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const Padding(
              //   padding: EdgeInsets.only(top: 300.0),
              //   child: Text(
              //     'right chart',
              //     style: TextStyle(fontSize: 30),
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.file_copy_outlined,
                      size: 20,
                    ),
                    label: const Text('Export'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
