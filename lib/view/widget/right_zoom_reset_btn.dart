import 'package:flutter/material.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
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
      child: IgnorePointer(
        ignoring: FilePickerCtrl.to.oesFD.isEmpty,
        child: TextButton.icon(
          label: Text(
            'zoom reset',
            style: TextStyle(
              color: FilePickerCtrl.to.oesFD.isEmpty
                  ? Colors.grey
                  : Colors.blueGrey,
            ),
          ),
          icon: Icon(Icons.refresh,
              color: FilePickerCtrl.to.oesFD.isEmpty
                  ? Colors.grey
                  : Colors.blueGrey),
          onPressed: () {
            RightChartCtrl.to.zoomPan.value.reset();
          },
        ),
      ),
    );
  }
}
