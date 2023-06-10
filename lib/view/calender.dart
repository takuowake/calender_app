import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/painting.dart';


import '../common/calendar_builder.dart';

class Calendar extends StatelessWidget {
  final DateTime date;
  final Function(DateTime date) onDateSelected;

  const Calendar({
    Key? key,
    required this.date,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calendarData = CalendarBuilder().build(date);

    return Column(
      children: [
        _WeekRow(const ['月', '火', '水', '木', '金', '土', '日'], isHeader: true, onDateSelected: (DateTime date) {  },),
        ...calendarData.map(
              (week) => _WeekRow(
            week.map((date) => date?.toString() ?? '').toList(),
            onDateSelected: onDateSelected,
          ),
        ),
      ],
    );
  }
}

class _WeekRow extends StatelessWidget {
  const _WeekRow(this.items, {this.isHeader = false, required this.onDateSelected});

  final List<String> items;
  final bool isHeader;
  final Function(DateTime date) onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        items.length,
            (index) {
          final item = items[index];
          final date = DateTime.tryParse(item);
          return Expanded(
            child: _DateBox(
              date: date,
              weekday: index + 1,
              isHeader: isHeader,
              onDateSelected: date == null ? (DateTime date) {} : onDateSelected,
              text: date == null ? item : date.day.toString(),
            ),
          );
        },
      ).toList(),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.text,
    this.date,
    required this.weekday,
    this.isHeader = false,
    required this.onDateSelected,
    Key? key,
  });

  final String text;
  final DateTime? date;
  final int weekday;
  final bool isHeader;
  final Function(DateTime date) onDateSelected;

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color backgroundColor = Colors.white;
    double fontSize = 14.0; // Set default font size
    double boxHeight = 1.0; // Set default box height
    bool isToday = false;

    if (weekday == 6) {
      textColor = Colors.blue;
    } else if (weekday == 7) {
      textColor = Colors.red;
    } else {
      textColor = Colors.black;
    }
    if (isHeader) {
      backgroundColor = Colors.grey;
      fontSize = 10.0;
      boxHeight = 1.8;
    }

    if (date != null) {
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyy-MM-dd');
      isToday = dateFormat.format(date!) == dateFormat.format(now);

      if (isToday) {
        textColor = Colors.white;
        backgroundColor = Colors.blue;
        boxHeight = 1.0; // Reset box height to square
      }
    }

    return AspectRatio(
      aspectRatio: boxHeight,
      child: GestureDetector(
        onTap: () {
          if (date != null) {
            onDateSelected(date!);
            print('object');
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: isToday ? BoxShape.circle : BoxShape.rectangle,
          ),
          child: Center(
            child: Text(
              isHeader ? text : date?.day.toString() ?? '',
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}