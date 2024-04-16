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

  // bool isSameDay(DateTime date1, DateTime date2) {
  //   return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  // }

  List<HealthData> getDataForDay(DateTime day) {
    return _healthDataList.where((data) {
      return data.date.year == day.year && data.date.month == day.month && data.date.day == day.day;
    }).toList();
    // for (var a in _healthDataList) {
    //   debugPrint("내용: ${a.date}");
    // }

    // return _healthDataList.where((data) => isSameDay(data.date, day)).toList();
  }
}
