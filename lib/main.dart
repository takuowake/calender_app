import 'package:calender_app/view/calender_screen.dart';
import 'package:calender_app/view/event_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'カレンダー',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en"),
      ],
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  var _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('カレンダー')),
      body: SizedBox.expand(
        child: Column(
          children: [
            _CalendarController(
              currentMonth: '${_currentDate.year}年 ${_currentDate.month}月',
              date: _currentDate,
              onDateChanged: (date) {
                setState(() {
                  _currentDate = date;
                });
              },
            ),
            SizedBox(height: 16),

            Calendar(date: _currentDate),
          ],
        ),
      ),
    );
  }
}

class _CalendarController extends StatelessWidget {
  const _CalendarController({
    required this.currentMonth,
    required this.date,
    required this.onDateChanged,
  });

  final String currentMonth;
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),//角の丸み
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => DialogPageView(),
            );
          },
          child: Text(
            '今日',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(currentMonth),
          ),
        ),
        DatePicker(
          date: date,
          onDateChanged: onDateChanged,
        ),
      ],
    );
  }
}

class DatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;

  DatePicker({required this.date, required this.onDateChanged});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _date = DateTime.now();

  void onPressedElevatedButton() async {
    final DateTime? picked = await showDatePicker(
      locale: const Locale("ja"),
      context: context,
      initialDate: _date,
      firstDate: new DateTime(2010, 1, 1),
      lastDate: new DateTime(2030, 12, 31),
    );

    if (picked != null) {
      setState(() => _date = picked);
      widget.onDateChanged(picked);
    }
  }

  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(70.0),
        child: Column(
          children: <Widget>[
            IconButton(onPressed: onPressedElevatedButton, icon: Icon(Icons.arrow_drop_down)),
          ],
        )
    );
  }
}

