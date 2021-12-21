import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wgs_viewer/controller/time_select_ctrl.dart';

class TimeSelectTxtForm extends StatelessWidget {
  const TimeSelectTxtForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                DottedBorder(
                    color: Colors.blueGrey, child: Text('First Time : ')),
                SizedBox(width: 20),
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
                  return Text('${controller.firstTimeVal}');
                }),
                InkWell(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blueGrey,
                  ),
                  onTap: () {
                    Get.find<TimeSelectCtrl>().firstIncrease();
                  },
                ),
                Spacer(),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff5AEDCA),
                      ),
                      onPressed: () {},
                      child: Text(
                        'File load',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffD83737),
                      ),
                      onPressed: () {},
                      child: Text(
                        'File Delete',
                      ),
                    )
                  ],
                )
              ],
            ),
            ///////////second Time
            Column(
              children: [
                Row(
                  children: [
                    DottedBorder(
                        color: Colors.blueGrey, child: Text('Second Time : ')),
                    SizedBox(width: 20),
                    InkWell(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blueGrey,
                      ),
                      onTap: () {
                        Get.find<TimeSelectCtrl>().secondDecrease();
                      },
                    ),
                    GetBuilder<TimeSelectCtrl>(builder: (controller) {
                      return Text('${controller.secondTimeVal}');
                    }),
                    InkWell(
                      child: Icon(
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
                    Spacer(),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff5AEDCA),
                          ),
                          onPressed: () {},
                          child: Text(
                            'File load',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffD83737),
                          ),
                          onPressed: () {},
                          child: Text(
                            'File Delete',
                          ),
                        )
                      ],
                    ),

                    ///////////second Time
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
