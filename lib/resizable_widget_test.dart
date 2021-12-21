import 'package:flutter/material.dart';
import 'package:resizable_widget/resizable_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resizable Widget Example',
      theme: ThemeData.dark(),
      home: const MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resizable Widget Example'),
      ),
      body: ResizableWidget(
        isHorizontalSeparator: false,
        isDisabledSmartHide: true,
        separatorColor: Colors.white12,
        separatorSize: 4,
        onResized: _printResizeInfo,
        children: [
          Container(color: Colors.black),
          ResizableWidget(
            isHorizontalSeparator: true,
            separatorColor: Colors.blue,
            separatorSize: 10,
            children: [
              Container(color: Colors.greenAccent),
            ],
          ),
          Container(color: Colors.redAccent),
        ],
      ),
    );
  }

  void _printResizeInfo(List<WidgetSizeInfo> dataList) {
    // ignore: avoid_print
    print(dataList.map((x) => '(${x.size}, ${x.percentage}%)').join(", "));
  }
}
