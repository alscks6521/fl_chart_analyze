import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:measurement/models/HealthData.dart';
import 'package:measurement/providers/health_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart'; // SystemChrome을 사용하기 위해 필요

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
    // 화면을 세로 모드로 고정
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // 다른 화면에서는 가로 모드와 세로 모드를 모두 허용
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _customTableCalendar(context),
            const SizedBox(
              height: 15,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: _selectedDayDetails(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customTableCalendar(BuildContext context) {
    return Consumer<HealthDataProvider>(
      builder: (context, provider, child) {
        return TableCalendar<HealthData>(
          locale: "ko_KR",
          focusedDay: _focusedDay ?? DateTime.now(),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          rowHeight: 60.0,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            headerPadding: EdgeInsets.symmetric(vertical: 3),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekendStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          daysOfWeekHeight: 30.0,
          calendarStyle: CalendarStyle(
            cellAlignment: Alignment.topCenter,
            weekendTextStyle: const TextStyle(color: Colors.red),
            cellMargin: EdgeInsets.zero,
            defaultDecoration: const BoxDecoration(shape: BoxShape.rectangle),
            weekendDecoration: const BoxDecoration(shape: BoxShape.rectangle),
            selectedDecoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.9),
              shape: BoxShape.rectangle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.green.withOpacity(0.6),
              shape: BoxShape.rectangle,
            ),
          ),
          eventLoader: (day) => provider.getDataForDay(day),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay) || !isSameDay(_focusedDay, focusedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
          },
          calendarFormat: CalendarFormat.month,
          onPageChanged: (focusedDay) {
            if (!isSameDay(_focusedDay, focusedDay)) {
              setState(() {
                _focusedDay = focusedDay;
              });
            }
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: buildEventMarker(events.length),
                );
              }
              return null;
            },
          ),
        );
      },
    );
  }

  Widget buildEventMarker(int count) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.purple[100],
      ),
      padding: const EdgeInsets.all(4.0),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.purple,
          fontSize: 10.0,
        ),
      ),
    );
  }

  /// 선택날짜 컬럼뷰
  Widget _selectedDayDetails() {
    return Consumer<HealthDataProvider>(
      builder: (context, provider, child) {
        final data = _selectedDay == null ? [] : provider.getDataForDay(_selectedDay!);
        return data.isEmpty
            ? const Center(child: Text('입력된 데이터가 없어요!'))
            : ListView.separated(
                itemCount: data.length,
                itemBuilder: (_, index) => ListTile(
                  title: Text(
                      '${index + 1} 측정시간: ${data[index].date.hour}시${data[index].date.minute}분'),
                  subtitle: Text(
                      '수축기: ${data[index].systolicBP}, 이완기: ${data[index].diastolicBP}, 혈당: ${data[index].bloodSugar}'),
                ),
                separatorBuilder: (_, __) => const Divider(),
              );
      },
    );
  }
}
