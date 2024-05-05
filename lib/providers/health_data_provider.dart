import 'package:flutter/material.dart';
import 'package:measurement/models/HealthData.dart';

class HealthDataProvider with ChangeNotifier {
  final List<HealthData> _healthDataList = []; // HealthData 객체 저장 리스트

  List<HealthData> get data => _healthDataList;

  void addHealthData(HealthData data) {
    _healthDataList.add(data);
    debugPrint('입력 : ${data.date.day}');
    notifyListeners();
  }

  List<HealthData> getDataForDay(DateTime day) {
    return _healthDataList.where((data) {
      return data.date.year == day.year && data.date.month == day.month && data.date.day == day.day;
    }).toList();
  }

  //TODO
  // 파이어베이스 데이터 불러오기

}
