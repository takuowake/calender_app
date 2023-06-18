import 'package:flutter/material.dart';

TextStyle getWeekdayTextStyle(int weekday) {
  if (weekday == DateTime.saturday) {
    return TextStyle(color: Colors.blue);
  } else if (weekday == DateTime.sunday) {
    return TextStyle(color: Colors.red);
  } else {
    return TextStyle(color: Colors.black);
  }
}

String getFormattedWeekDay(DateTime date) {
  String weekday = '';

  switch (date.weekday) {
    case DateTime.monday:
      weekday = '月';
      break;
    case DateTime.tuesday:
      weekday = '火';
      break;
    case DateTime.wednesday:
      weekday = '水';
      break;
    case DateTime.thursday:
      weekday = '木';
      break;
    case DateTime.friday:
      weekday = '金';
      break;
    case DateTime.saturday:
      weekday = '土';
      break;
    case DateTime.sunday:
      weekday = '日';
      break;
  }

  return weekday;
}

String getFormattedDate(DateTime date) {
  String year = date.year.toString();
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');

  return '$year年$month月$day日';
}

const String allDayText = '終日';
const String noPlan = '予定がありません。';
