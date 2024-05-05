import 'package:flutter/material.dart';
import 'package:measurement/models/HealthData.dart';

class HealthDataProvider with ChangeNotifier {
  /// 날짜별로 데이터를 그룹화하여 저장. 특정 날짜의 데이터를 가져올 때 더 빠른 검색이 가능
  final Map<DateTime, List<HealthData>> _healthDataMap = {};

  List<HealthData> get allData => _healthDataMap.values.expand((data) => data).toList();

  void addHealthData(HealthData data) {
    final dateKey = DateTime(data.date.year, data.date.month, data.date.day);
    _healthDataMap[dateKey] ??= [];
    _healthDataMap[dateKey]!.add(data);
    debugPrint('입력 : ${data.date.day}');
    notifyListeners();
  }

  List<HealthData> getDataForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return _healthDataMap[dateKey] ?? [];
  }

  //TODO
  // 파이어베이스 데이터 불러오기
  Future<void> loadDataFromFirebase() async {
    // 파이어베이스에서 데이터를 가져오는 로직 구현
    // 가져온 데이터를 _healthDataMap에 추가
    // notifyListeners() 호출
  }
}

// import 'package:flutter/material.dart';
// import 'package:measurement/models/HealthData.dart';

// class HealthDataProvider with ChangeNotifier {
//   final List<HealthData> _healthDataList = []; // HealthData 객체 저장 리스트

//   List<HealthData> get data => _healthDataList;

//   void addHealthData(HealthData data) {
//     _healthDataList.add(data);
//     debugPrint('입력 : ${data.date.day}');
//     notifyListeners();
//   }

//   List<HealthData> getDataForDay(DateTime day) {
//     return _healthDataList.where((data) {
//       return data.date.year == day.year && data.date.month == day.month && data.date.day == day.day;
//     }).toList();
//   }

//   //TODO
//   // 파이어베이스 데이터 불러오기

// }
