import 'package:flutter/material.dart';

const TextStyle timeTextStyle = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

TextStyle getWeekdayTextStyle(int weekday) {
  if (weekday == DateTime.saturday) {
    return const TextStyle(color: Colors.blue);
  } else if (weekday == DateTime.sunday) {
    return const TextStyle(color: Colors.red);
  } else {
    return const TextStyle(color: Colors.black);
  }
}