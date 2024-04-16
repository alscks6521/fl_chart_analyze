import 'package:flutter/material.dart';
import 'package:measurement/models/HealthData.dart';

class HealthDataProvider with ChangeNotifier {
  final List<HealthData> _healthDataList = []; // HealthData 객체 저장 리스트

  List<HealthData> get data => _healthDataList;

  void addHealthData(HealthData data) {
    _healthDataList.add(data);
    debugPrint('입력받음 : ${data.date.day}');
    notifyListeners();
  }

  List<HealthData> getDataForDay(DateTime day) {
    return _healthDataList.where((data) {
      // 세 조건 모두 참이면, 해당 data 객체는 결과 리스트에 포함된다,
      return data.date.year == day.year && data.date.month == day.month && data.date.day == day.day;
    }).toList();
  }
}
