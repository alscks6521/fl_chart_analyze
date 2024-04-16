import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:measurement/models/HealthData.dart';
import 'package:measurement/providers/health_data_provider.dart';
import 'package:measurement/widgets/line_chart.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final healthDataList = Provider.of<HealthDataProvider>(context).data;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                            height: 50,
                          ),
                          SizedBox(
                            height: 250,
                            child: buildBloodSugarChart(healthDataList, context),
                          ),
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
      lineColors: [Colors.blue, Colors.red], // 수축기와 이완기 혈압에 대한 색상
      normalValues: [120, 80], // 수축기와 이완기 혈압의 정상값
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
      normalValues: [100],
      valueExtractors: [
        (HealthData data) => data.bloodSugar.toDouble(),
      ],
    );
  }
}

class ChartHelper {
  // 차트를 생성하는 static 메서드
  static Widget buildChart({
    required List<HealthData> healthDataList,
    required BuildContext context,
    required List<Color> lineColors, // 차트 라인 색상 배열
    required List<double> normalValues, // 각 데이터 세트의 적정 값 배열
    required List<double Function(HealthData)> valueExtractors, // 데이터에서 값을 추출하는 함수배열
  }) {
    if (healthDataList.isEmpty) {
      return Container();
    }

    final width = MediaQuery.of(context).size.width;
    final chartWidth = healthDataList.length * 60.0;
    final isScrollable = chartWidth > width;
    // 최근 10개 데이터 또는 전체 데이터를 저장
    final recentDataList = healthDataList.length > 10
        ? healthDataList.sublist(healthDataList.length - 10)
        : healthDataList;

    // 각 데이터 세트에 대한 LineChartBarData 객체 생성
    // List.generate 함수를 사용하여 valueExtractors의 길이만큼 LineChartBarData 객체들의 리스트를 생성
    List<LineChartBarData> lineBarsData = List.generate(valueExtractors.length, (index) {
      final spots = recentDataList.asMap().entries.map(
        (entry) {
          final value = valueExtractors[index](entry.value);
          return FlSpot(
            // entry.key는 데이터의 인덱스로 나타냄 double 형으로 변환하여 FlSpot의 x 좌표로 사용
            entry.key.toDouble(),
            // value는 valueExtractors를 통해 추출된 실제 데이터 값으로 FlSpot의 y 좌표로 사용
            value,
          );
        },
      ).toList();

      /// <LineChartBarData>
      return CustomLineChart.buildLineChartBarData(
        spots,
        lineColors[index].withOpacity(0.7),
      );
    });

    // 적정 값을 나타내는 라인 추가
    for (int i = 0; i < normalValues.length; i++) {
      lineBarsData.add(CustomLineChart.buildNormalLineChartBarData(
        recentDataList.length,
        normalValues[i],
        Colors.green.withOpacity(0.8),
      ));
    }

    // 생성된 데이터를 통해 LineChart 반환
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: isScrollable ? chartWidth : width,
        child: LineChart(
          LineChartData(
            lineBarsData: lineBarsData,
            titlesData: CustomLineChart.buildTitlesData(recentDataList),
          ),
        ),
      ),
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