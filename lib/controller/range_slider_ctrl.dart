// import 'package:get/get.dart';

// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:wgs_viewer/controller/chart_ctrl.dart';

// class RangeSlidersCtrl extends GetxController {
//   static RangeSliderCtrl get to => Get.find();
//   var largestValue = 0.0.obs;
//   vvv() {
//     if (ChartCtrl.to.enableApply.value == true) {
//       largestValue.value = ChartCtrl.to.rangeList[0];
//       var smallestValue = ChartCtrl.to.rangeList[0];

//       for (var i = 0; i < ChartCtrl.to.rangeList.length; i++) {
//         if (ChartCtrl.to.rangeList[i] > largestValue.value) {
//           largestValue.value = ChartCtrl.to.rangeList[i];
//         }

//         if (ChartCtrl.to.rangeList[i] < smallestValue) {
//           smallestValue = ChartCtrl.to.rangeList[i];
//         }
//       }

//       // Printing the values
//       debugPrint("Smallest value in the list : $smallestValue");
//       debugPrint("Largest value in the list : $largestValue.value");
//     }
//   }

//   void setRangeVal(start, end) {
//     if (start < 0) return;
//     if (start > end) return;
//   }
// }
