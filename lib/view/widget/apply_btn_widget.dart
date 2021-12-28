import 'package:flutter/material.dart';
import 'package:wgs_viewer/controller/chart_ctrl.dart';

class ApplyBtn extends StatelessWidget {
  const ApplyBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: const Color(0xff5AEDCA)),
        onPressed: () async {
          ChartCtrl.to.leftDataMode.value = true;
          await ChartCtrl.to.updateLeftData();
        },
        child: const Text(
          'Apply',
          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ));
  }
}
