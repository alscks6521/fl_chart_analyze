#### Provider 데이터 상태관리를 통해 Chart 및 Calendar 시각화  
#### 사용 package: "Provder", "fl_chart"  
#### Provider 코드블록  
```dart
class HealthDataProvider with ChangeNotifier {
  List<HealthData> healthDataList = []; // HealthData 객체 저장 리스트

  void addHealthData(HealthData data) {
    healthDataList.add(data);
    notifyListeners();
  }

  List<HealthData> get data => healthDataList;
}
```
<hr>  

#### Chart  
코드의 중복을 줄이고, 간결하고 재사용성 있게끔 코드 메서드 분리  
1. chart_page.dart
2. line_chart.dart

🔵 수축기선 / 🔴 이완기선 / 🟣 혈당선 / 🟢 각 적정선

<img width="221" alt="image" src="https://github.com/alscks6521/fl_chart_analyze/assets/112923685/1cee2717-41ce-433e-aa27-ecb35631ddcb">
