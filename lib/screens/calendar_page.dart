import 'package:flutter/material.dart';
import 'package:measurement/models/HealthData.dart';
import 'package:measurement/providers/health_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _customTableCalendar(context),
            const SizedBox(
              height: 20,
            ),
            _selectedDayDetails(context),
            // Expanded(
            //   child: eventCalendar(),
            // ),
          ],
        ),
      ),
    );
  }

  TableCalendar<HealthData> _customTableCalendar(BuildContext context) {
    final healthDataProvider = Provider.of<HealthDataProvider>(context);

    return TableCalendar(
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
        weekendStyle: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
        weekdayStyle: TextStyle(
          fontWeight: FontWeight.bold,
          height: 1.0,
        ),
      ),
      daysOfWeekHeight: 30.0,

      calendarStyle: CalendarStyle(
        cellAlignment: Alignment.topCenter,
        weekendTextStyle: const TextStyle(color: Colors.red),
        cellMargin: EdgeInsets.zero,
        defaultDecoration: const BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        weekendDecoration: const BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        // 선택한 날짜 Style
        selectedDecoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.9),
          shape: BoxShape.rectangle,
        ),
        // 오늘 날짜 Style
        todayDecoration: BoxDecoration(
          color: Colors.green.withOpacity(0.6),
          shape: BoxShape.rectangle,
        ),
      ),

      eventLoader: (day) {
        final data = Provider.of<HealthDataProvider>(context, listen: false).getDataForDay(day);
        // debugPrint('Data for day $day: $data'); // 데이터 확인을 위한 print 문 추가
        return data;
      },

      // 캘린더를 다루는 제스처 방식 허용 범위
      availableGestures: AvailableGestures.all,

      // 선택된 날짜를 확인하기 위한 조건을 지정. _selectedDay와 day가 동일한지 여부를 확인.
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
        });

        debugPrint('Selected day: $selectedDay');
        debugPrint('Data for selected day: $_selectedDay');
      },
      // 캘린더의 형식(월간, 주간, 년간 등)을 나타내는 _calendarFormat 변수를 설정.
      calendarFormat: CalendarFormat.month,
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (events.isNotEmpty) {
            return Positioned(
              right: 1,
              bottom: 1,
              child: buildEventMarker(day, events),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget buildEventMarker(DateTime date, List<Object?> events) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle, // 사각형 모양
        color: Colors.purple[100], // 마커의 배경색
      ),
      padding: const EdgeInsets.all(4.0),
      constraints: const BoxConstraints(
        minWidth: 16.0, // 최소 너비
        minHeight: 16.0, // 최소 높이
      ),
      child: Text(
        '+${events.length}', // 이벤트 개수 표시
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.purple, // 텍스트 색상
          fontSize: 10.0, // 텍스트 크기
        ),
      ),
    );
  }

  /// 선택날짜 컬럼뷰
  Widget _selectedDayDetails(BuildContext context) {
    final healthDataProvider = Provider.of<HealthDataProvider>(context);
    final selectedDayData =
        _selectedDay == null ? [] : healthDataProvider.getDataForDay(_selectedDay!);

    return Expanded(
      child: ListView.separated(
        itemCount: selectedDayData.length,
        itemBuilder: (context, index) {
          final data = selectedDayData[index];
          return ListTile(
            title: Text('측정 시간: ${data.date.hour}:${data.date.minute}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('수축기: ${data.systolicBP}'),
                Text('이완기: ${data.diastolicBP}'),
                Text('혈당: ${data.bloodSugar}'),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
