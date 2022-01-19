import 'package:flutter/material.dart';
import 'package:wgs_viewer/controller/right_chart_ctrl.dart';

class RightZoomResetBtn extends StatelessWidget {
  const RightZoomResetBtn({Key? key}) : super(key: key);

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
          RightChartCtrl.to.zoomPan.value.reset();
        },
      ),
    );
  }
}
