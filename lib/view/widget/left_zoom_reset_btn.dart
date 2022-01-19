import 'package:flutter/material.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';

class LeftZoomResetBtn extends StatelessWidget {
  const LeftZoomResetBtn({Key? key}) : super(key: key);

  /*
  index==0->left chart
  index==1->right chart
   */
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Reset',
      child: TextButton.icon(
        label: const Text(
          'zoom reset',
          style: TextStyle(
            color: Colors.blueGrey,
          ),
        ),
        icon: const Icon(Icons.refresh, color: Colors.blueGrey),
        onPressed: () {
          ChartCtrl.to.zoomPan.value.reset();
        },
      ),
    );
  }
}
