import 'package:flutter/material.dart';
import 'package:resizable_widget/resizable_widget.dart';

void main() {
  runApp(MaterialApp(home: MyPage()));
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResizableWidget(
        children: [
          // required
          Container(color: Colors.greenAccent),
          Container(color: Colors.yellowAccent),
          Container(color: Colors.redAccent),
        ],
        isHorizontalSeparator: false, // optional
        isDisabledSmartHide: false, // optional
        separatorColor: Colors.white12, // optional
        separatorSize: 4, // optional
        percentages: [0.2, 0.5, 0.3], // optional
        onResized: (infoList) => // optional
            print(infoList
                .map((x) => '(${x.size}, ${x.percentage}%)')
                .join(", ")),
      ),
    );
  }
}
