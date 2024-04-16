import 'package:flutter/material.dart';
import 'package:measurement/models/HealthData.dart';

class HealthDataProvider with ChangeNotifier {
  List<HealthData> healthDataList = []; // HealthData 객체 저장 리스트

  void addHealthData(HealthData data) {
    healthDataList.add(data);
    // debugPrint("$healthDataList");
    notifyListeners();
  }

  List<HealthData> get data => healthDataList;
}
