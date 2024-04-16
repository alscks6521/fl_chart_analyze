import 'package:flutter/material.dart';
import 'package:measurement/models/HealthData.dart';
import 'package:measurement/providers/health_data_provider.dart';
import 'package:measurement/screens/chart_page.dart';
import 'package:measurement/widgets/input_field.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HealthData> healthDataList = []; // HealthData 객체 저장 리스트

  final _formKey = GlobalKey<FormState>(); // Form 위젯 상태 관리키
  final systolicBPController = TextEditingController();
  final diastolicBPController = TextEditingController();
  final bloodSugarController = TextEditingController();

  @override
  void dispose() {
    systolicBPController.dispose();
    diastolicBPController.dispose();
    bloodSugarController.dispose();
    super.dispose();
  }

  /// 건강 데이터 추가 함수.
  void addHealthData() {
    // 입력 값 검증
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final systolicBP = int.tryParse(systolicBPController.text) ?? 0;
      final diastolicBP = int.tryParse(diastolicBPController.text) ?? 0;
      final bloodSugar = int.tryParse(bloodSugarController.text) ?? 0;

      final newData = HealthData(
        date: now,
        systolicBP: systolicBP,
        diastolicBP: diastolicBP,
        bloodSugar: bloodSugar,
      );

      Provider.of<HealthDataProvider>(context, listen: false).addHealthData(newData);

      // systolicBPController.clear();
      // diastolicBPController.clear();
      // bloodSugarController.clear();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChartPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // 입력 폼
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputFields(),
              const SizedBox(height: 16.0),
              _buildAddDataButton(),
              const SizedBox(height: 16.0),
              Expanded(
                child: healthDataList.isEmpty
                    ? const Center(child: Text('입력된 데이터가 없어요!'))
                    : ListView(
                        children: const [
                          SizedBox(
                            height: 200,
                            // 혈압 차트 위젯
                            // child: _buildBloodPressureChart(),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 200,
                            // 혈당 차트 위젯
                            // child: _buildBloodSugarChart(),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 혈압, 혈당 위젯
  Widget _buildInputFields() {
    return Column(
      children: [
        InputField(controller: systolicBPController, label: '수축기 혈압'),
        InputField(controller: diastolicBPController, label: '이완기 혈압'),
        InputField(controller: bloodSugarController, label: '혈당'),
      ],
    );
  }

  /// ADD Btn
  Widget _buildAddDataButton() {
    return ElevatedButton(
      onPressed: addHealthData,
      child: const Text('Add Data'),
    );
  }
}
