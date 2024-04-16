// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:measurement/models/HealthData.dart';
// import 'package:measurement/widgets/line_chart.dart';

// class ChartWidget {
//   static Widget buildChart({
//     required List<HealthData> healthDataList,
//     required BuildContext context,
//     required List<LineChartBarData> lineBarsData,
//     required double normalValue,
//   }) {
//     if (healthDataList.isEmpty) {
//       return Container();
//     }
//     final width = MediaQuery.of(context).size.width;
//     final chartWidth = healthDataList.length * 60.0;
//     final isScrollable = chartWidth > width;
//     final recentDataList = healthDataList.length > 10
//         ? healthDataList.sublist(healthDataList.length - 10)
//         : healthDataList;

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: SizedBox(
//         width: isScrollable ? chartWidth : width,
//         child: LineChart(
//           LineChartData(
//             lineBarsData: [
//               ...lineBarsData,
//               CustomLineChart.buildNormalLineChartBarData(
//                 recentDataList.length,
//                 normalValue,
//                 Colors.green.withOpacity(0.8),
//               ),
//             ],
//             titlesData: CustomLineChart.buildTitlesData(recentDataList),
//           ),
//         ),
//       ),
//     );
//   }

//   static Widget buildBloodPressureChart(List<HealthData> healthDataList, BuildContext context) {
//     return buildChart(
//       healthDataList: healthDataList,
//       context: context,
//       lineBarsData: [
//         CustomLineChart.buildLineChartBarData(
//           healthDataList.asMap().entries.map((entry) {
//             final index = entry.key;
//             final data = entry.value;
//             return FlSpot(index.toDouble(), data.systolicBP.toDouble());
//           }).toList(),
//           Colors.blue.withOpacity(0.7),
//         ),
//         CustomLineChart.buildLineChartBarData(
//           healthDataList.asMap().entries.map((entry) {
//             final index = entry.key;
//             final data = entry.value;
//             return FlSpot(index.toDouble(), data.diastolicBP.toDouble());
//           }).toList(),
//           Colors.red.withOpacity(0.7),
//         ),
//       ],
//       normalValue: 120,
//     );
//   }

//   static Widget buildBloodSugarChart(List<HealthData> healthDataList, BuildContext context) {
//     return buildChart(
//       healthDataList: healthDataList,
//       context: context,
//       lineBarsData: [
//         CustomLineChart.buildLineChartBarData(
//           healthDataList.asMap().entries.map((entry) {
//             final index = entry.key;
//             final data = entry.value;
//             return FlSpot(index.toDouble(), data.bloodSugar.toDouble());
//           }).toList(),
//           Colors.purple.withOpacity(0.8),
//         ),
//       ],
//       normalValue: 100,
//     );
//   }
// }
