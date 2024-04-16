import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:measurement/providers/health_data_provider.dart';
import 'package:measurement/screens/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  // 언어설정(intl)
  WidgetsFlutterBinding.ensureInitialized(); // 이 라인을 추가하세요
  await initializeDateFormatting('ko_KR', null); // 'ko_KR'을 명시적으로 전달
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HealthDataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Fl_Chart',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
