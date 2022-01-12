// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:wgs_viewer/view/widget/left_chart_widget.dart';

// class WaveLengthChartData {
//   //x값,y값 리스트
//   List<WGSspot> seriesData;
//   WaveLengthChartData({
//     required this.seriesData,
//   });

//   WaveLengthChartData copyWith({
//     List<WGSspot>? seriesData,
//   }) {
//     return WaveLengthChartData(
//       seriesData: seriesData ?? this.seriesData,
//     );
//   }

//   @override
//   String toString() => 'WaveLengthChartData(seriesData: $seriesData)';

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is WaveLengthChartData &&
//         listEquals(other.seriesData, seriesData);
//   }

//   @override
//   int get hashCode => seriesData.hashCode;
// }
