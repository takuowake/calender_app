import 'package:flutter/material.dart';

import '../common/calendar_builder.dart';

class Calendar extends StatelessWidget {
  const Calendar({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final calendarData = CalendarBuilder().build(date);

    return Column(
      children: [
        const _WeekRow(['月', '火', '水', '木', '金', '土', '日'], isHeader: true), // Specify this row as header
        ...calendarData.map(
              (week) => _WeekRow(
            week.map((date) => date?.toString() ?? '').toList(),
          ),
        ),
      ],
    );
  }
}

class _WeekRow extends StatelessWidget {
  const _WeekRow(this.datesOfWeek, {this.isHeader = false}); // Added isHeader to constructor

  final List<String> datesOfWeek;
  final bool isHeader; // Added isHeader variable to determine if this row is a header

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        datesOfWeek.length,
            (index) => Expanded(
          child: _DateBox(
            datesOfWeek[index],
            weekday: index + 1,
            isHeader: isHeader, // Pass this to _DateBox
          ),
        ),
      ).toList(),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox(
      this.label, {
        required this.weekday,
        this.isHeader = false, // Added isHeader to constructor
        super.key,
      });

  final String label;
  final int weekday;
  final bool isHeader; // Added isHeader variable to determine if this box is part of a header

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color backgroundColor = Colors.white;
    double fontSize = 14.0; // Set default font size
    double boxHeight = 1.0; // Set default box height
    if (weekday == 6) {
      textColor = Colors.blue;
    } else if (weekday == 7) {
      textColor = Colors.red;
    } else {
      textColor = Colors.black;
    }
    if (isHeader) { // If this box is part of a header
      backgroundColor = Colors.grey; // Change background color to grey
      fontSize = 10.0; // Change font size to smaller
      boxHeight = 1.8; // Change box height to smaller
    }
    return AspectRatio(
      aspectRatio: boxHeight, // Apply box height here
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize, // Apply font size here
            ),
          ),
        ),
      ),
    );
  }
}