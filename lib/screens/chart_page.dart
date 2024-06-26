import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:measurement/models/HealthData.dart';
import 'package:measurement/providers/health_data_provider.dart';
import 'package:measurement/widgets/chart_widhget.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final healthDataList = Provider.of<HealthDataProvider>(context).allData;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: healthDataList.isNotEmpty
                    ? ListView(
                        children: [
                          SizedBox(
                            height: 250,
                            child: buildBloodPressureChart(healthDataList, context),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      color: Colors.green,
                                    ),
                                    const Text('안전 수축기'),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      color: Colors.blue,
                                    ),
                                    const Text('수축기'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      color: Colors.red,
                                    ),
                                    const Text('안전 이완기'),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      color: Colors.orange,
                                    ),
                                    const Text('이완기'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            height: 250,
                            child: buildBloodSugarChart(healthDataList, context),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      color: Colors.green,
                                    ),
                                    const Text('안전 혈당'),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      color: Colors.purple,
                                    ),
                                    const Text('혈당'),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : const Center(child: Text('혹시 데이터를 추가하셨나요?')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBloodPressureChart(List<HealthData> healthDataList, BuildContext context) {
    return ChartHelper.buildChart(
      healthDataList: healthDataList,
      context: context,
      lineColors: [Colors.blue, Colors.orange], // 수축기와 이완기 혈압에 대한 색상
      normalValues: [200, 120, 80], // 수축기와 이완기 혈압의 정상값
      valueExtractors: [
        (HealthData data) => data.systolicBP.toDouble(),
        (HealthData data) => data.diastolicBP.toDouble(),
      ],
    );
  }

  Widget buildBloodSugarChart(List<HealthData> healthDataList, BuildContext context) {
    return ChartHelper.buildChart(
      healthDataList: healthDataList,
      context: context,
      lineColors: [Colors.purple],
      normalValues: [300, 100],
      valueExtractors: [
        (HealthData data) => data.bloodSugar.toDouble(),
      ],
    );
  }
}
// Version. 1
// /// 혈압 차트 시각화 위젯
  // Widget _buildBloodPressureChart(List<HealthData> healthDataList, BuildContext context) {
  //   if (healthDataList.isEmpty) {
  //     return Container();
  //   }
  //   final width = MediaQuery.of(context).size.width;

  //   final chartWidth = healthDataList.length * 60.0; // 데이터 포인트 수에 따라 차트 너비 설정
  //   final isScrollable = chartWidth > width; // 스크롤 여부 결정

  //   // 최근 10개의 데이터만 표시
  //   final recentDataList = healthDataList.length > 10
  //       ? healthDataList.sublist(healthDataList.length - 10)
  //       : healthDataList;

  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: SizedBox(
  //       width: isScrollable ? chartWidth : width, // 스크롤 가능 시 차트 너비, 아닐 시 화면 너비
  //       child: LineChart(
  //         LineChartData(
  //           lineBarsData: [
  //             // 수축기 혈압 데이터를 플롯으로 변환
  //             CustomLineChart.buildLineChartBarData(
  //               recentDataList.asMap().entries.map((entry) {
  //                 final index = entry.key;
  //                 final data = entry.value;
  //                 return FlSpot(index.toDouble(), data.systolicBP.toDouble());
  //               }).toList(),
  //               Colors.blue.withOpacity(0.7),
  //             ),
  //             // 이완기 혈압 데이터를 플롯으로 변환
  //             CustomLineChart.buildLineChartBarData(
  //               recentDataList.asMap().entries.map((entry) {
  //                 final index = entry.key;
  //                 final data = entry.value;
  //                 return FlSpot(index.toDouble(), data.diastolicBP.toDouble());
  //               }).toList(),
  //               Colors.red.withOpacity(0.7),
  //             ),
  //             // 적정 수축기 혈압 라인
  //             CustomLineChart.buildNormalLineChartBarData(
  //               recentDataList.length,
  //               120,
  //               Colors.green.withOpacity(0.8),
  //             ),
  //             // 적정 이완기 혈압 라인
  //             CustomLineChart.buildNormalLineChartBarData(
  //               recentDataList.length,
  //               80,
  //               const Color.fromARGB(255, 16, 87, 18).withOpacity(0.8),
  //             ),
  //           ],
  //           // 차트 축 설정
  //           titlesData: CustomLineChart.buildTitlesData(recentDataList),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // /// 혈당 차트 시각화 위젯
  // Widget _buildBloodSugarChart(List<HealthData> healthDataList, BuildContext context) {
  //   if (healthDataList.isEmpty) {
  //     return Container();
  //   }
  //   final width = MediaQuery.of(context).size.width;

  //   final chartWidth = healthDataList.length * 60.0; // 데이터 포인트 수에 따라 차트 너비 설정
  //   final isScrollable = chartWidth > width; // 스크롤 여부 결정

  //   // 최근 10개의 데이터만 표시
  //   final recentDataList = healthDataList.length > 10
  //       ? healthDataList.sublist(healthDataList.length - 10)
  //       : healthDataList;

  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: SizedBox(
  //       width: isScrollable ? chartWidth : width,
  //       child: LineChart(
  //         LineChartData(
  //           lineBarsData: [
  //             CustomLineChart.buildLineChartBarData(
  //               recentDataList.asMap().entries.map((entry) {
  //                 final index = entry.key;
  //                 final data = entry.value;
  //                 return FlSpot(index.toDouble(), data.bloodSugar.toDouble());
  //               }).toList(),
  //               Colors.purple.withOpacity(0.8),
  //             ),
  //             CustomLineChart.buildNormalLineChartBarData(
  //               recentDataList.length,
  //               100,
  //               Colors.green.withOpacity(0.8),
  //             ),
  //           ],
  //           titlesData: CustomLineChart.buildTitlesData(recentDataList),
  //         ),
  //       ),
  //     ),
  //   );
  // }