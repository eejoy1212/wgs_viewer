import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resizable_widget/resizable_widget.dart';
import 'package:wgs_viewer/controller/file_ctrl.dart';
import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
import 'package:wgs_viewer/controller/left_menu_ctrl.dart';
import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
import 'package:wgs_viewer/view/page/left_chart_pg.dart';
import 'package:wgs_viewer/view/page/right_chart_pg.dart';
import 'package:wgs_viewer/view/widget/apply_btn_widget.dart';
import 'package:wgs_viewer/view/widget/file_list_data_widget.dart';
import 'package:wgs_viewer/view/widget/file_select_btn_widget.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(() => MenuCtrl.to.chartSize.value == 0
            ? const SizedBox()
            : Visibility(
                visible: MenuCtrl.to.activateLeftMenu.value,
                child: SizedBox(
                  width: 300,
                ),
              )),
        Obx(
          () => Visibility(
            visible: Get.find<ChartCtrl>().visibleMode.value == 0 ||
                    Get.find<ChartCtrl>().visibleMode.value == 2
                ? true
                : false,
            child: Expanded(
              flex: 1,
              child: LeftChartPg(),
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: Get.find<ChartCtrl>().visibleMode.value == 1 ||
                      Get.find<ChartCtrl>().visibleMode.value == 2
                  ? true
                  : false,
              child: Expanded(
                flex: 1,
                child: RightChartPg(),
              ),
            ))
      ],
    );
  }

//   void _print(List<WidgetSizeInfo> infoList) {
//     print(infoList.map((x) => '(${x.size}, ${x.percentage}%)').join(", "));
//   }

//    void _showSheet() {
//     showFlexibleBottomSheet<void>(
//       minHeight: 0,
//       initHeight: 0.5,s
//       maxHeight: 1,
//       context: context,
//       builder: (context, controller, offset) {
//         return _BottomSheet(
//           scrollController: controller,
//           bottomSheetOffset: offset,
//         );
//       },
//       anchors: [0, 0.5, 1],
//     );
//   }
// }

// class _BottomSheet extends StatelessWidget {
//   final ScrollController scrollController;
//   final double bottomSheetOffset;

//   const _BottomSheet({
//     required this.scrollController,
//     required this.bottomSheetOffset,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Material(
//         child: Container(
//           decoration: const BoxDecoration(
//             color: Color(0xFFFFFFFF),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16),
//               topRight: Radius.circular(16),
//             ),
//           ),
//           child: ListView(
//             padding: EdgeInsets.zero,
//             controller: scrollController,
//             children: [
//               Text(
//                 'position $bottomSheetOffset',
//                 style: Theme.of(context).textTheme.headline6,
//               ),
//               Column(
//                 children: [],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:resizable_widget/resizable_widget.dart';
// // import 'package:wgs_viewer/controller/file_ctrl.dart';
// // import 'package:wgs_viewer/controller/left_chart_ctrl.dart';
// // import 'package:wgs_viewer/controller/left_menu_ctrl.dart';
// // import 'package:wgs_viewer/controller/range_slider_ctrl.dart';
// // import 'package:wgs_viewer/view/page/left_chart_pg.dart';
// // import 'package:wgs_viewer/view/page/right_chart_pg.dart';
// // import 'package:wgs_viewer/view/widget/apply_btn_widget.dart';
// // import 'package:wgs_viewer/view/widget/file_list_data_widget.dart';
// // import 'package:wgs_viewer/view/widget/file_select_btn_widget.dart';

// // class Body extends StatelessWidget {
// //   const Body({Key? key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         Expanded(
// //           flex: 18,
// //           child: ResizableWidget(
// //               key: key,
// //               separatorColor: Colors.blueGrey,
// //               isHorizontalSeparator: true,
// //               percentages: [0.8, 0.2],
// //               onResized: _print,
// //               children: [
// //                 Container(
// //                   child: Row(
// //                     children: [
// //                       Obx(() => MenuCtrl.to.chartSize.value == 0
// //                           ? const SizedBox()
// //                           : Visibility(
// //                               visible: MenuCtrl.to.activateLeftMenu.value,
// //                               child: SizedBox(
// //                                 width: 300,
// //                               ),
// //                             )),
// //                       Obx(
// //                         () => Visibility(
// //                           visible: Get.find<ChartCtrl>().visibleMode.value ==
// //                                       0 ||
// //                                   Get.find<ChartCtrl>().visibleMode.value == 2
// //                               ? true
// //                               : false,
// //                           child: Expanded(
// //                             flex: 1,
// //                             child: LeftChartPg(),
// //                           ),
// //                         ),
// //                       ),
// //                       Obx(() => Visibility(
// //                             visible: Get.find<ChartCtrl>().visibleMode.value ==
// //                                         1 ||
// //                                     Get.find<ChartCtrl>().visibleMode.value == 2
// //                                 ? true
// //                                 : false,
// //                             child: Expanded(
// //                               flex: 1,
// //                               child: RightChartPg(),
// //                             ),
// //                           ))
// //                     ],
// //                   ),
// //                 ),
// //                 /////////////bottom menu
// //                 Container(
// //                   child: Column(
// //                     children: [
// //                       Obx(() {
// //                         return FilePickerCtrl.to.oesFD.isEmpty
// //                             ? Padding(
// //                                 padding: const EdgeInsets.all(8.0),
// //                                 child: Container(
// //                                   height: 100,
// //                                   width: 100,
// //                                   color: Colors.grey,
// //                                   child: const Center(
// //                                     child: Text('No Files'),
// //                                   ),
// //                                 ),
// //                               )
// //                             : FileListData();
// //                       }),
// //                       Padding(
// //                         padding: const EdgeInsets.only(right: 8.0),
// //                         child: Row(
// //                           children: [
// //                             const SizedBox(
// //                               width: 10,
// //                             ),
// //                             const FileSelectBtn(),
// //                             const SizedBox(
// //                               width: 16,
// //                             ),
// //                             SizedBox(
// //                               height: 20,
// //                               width: 70,
// //                               child: ElevatedButton(
// //                                   style: ElevatedButton.styleFrom(
// //                                       primary: const Color(0xffD83737)),
// //                                   onPressed: () {
// //                                     FilePickerCtrl.to.oesFD.clear();
// //                                     ChartCtrl.to.forfields.clear();
// //                                     FilePickerCtrl.to.xWLs.clear();
// //                                     FilePickerCtrl.to.oesFD = RxList.empty();
// //                                     ChartCtrl.to.forfields = RxList.empty();
// //                                     FilePickerCtrl.to.xWLs = RxList.empty();
// //                                     FilePickerCtrl.to.xTimes.clear();
// //                                     RangeSliderCtrl.to.isPbShow.value = false;
// //                                   },
// //                                   child: const Text(
// //                                     'Delete',
// //                                     style: TextStyle(fontSize: 12),
// //                                   )),
// //                             ),
// //                             const Spacer(),
// //                             ApplyBtn(),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 )
// //               ]),
// //         ),
// //         Expanded(flex: 1, child: Text('data'))
// //       ],
// //     );
// //   }

// //   void _print(List<WidgetSizeInfo> infoList) {
// //     print(infoList.map((x) => '(${x.size}, ${x.percentage}%)').join(", "));
// //   }
// // }
}
