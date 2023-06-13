import 'package:calender_app/view/calendar_screen/calendar/calendar_builder.dart';
import 'package:calender_app/view/calendar_screen/calendar/week_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// カレンダーを表示するためのウィジェット
class Calendar extends ConsumerWidget {
  final DateTime date;
  // 日付が選択された時に呼び出されるコールバック関数
  final Function(DateTime date) onDateSelected;
  final int displayedMonth;

  const Calendar({
    Key? key,
    required this.date,
    required this.onDateSelected,
    required this.displayedMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 与えられたdateに基づいてカレンダーのデータを生成するためにCalendarBuilderを使用
    final calendarData = CalendarBuilder().build(date);
    final displayedMonth = date.month;

    return Column(
      children: [
        WeekRow(
          const ['月', '火', '水', '木', '金', '土', '日'],
          isHeader: true,
          onDateSelected: (DateTime date) {},
          displayedMonth: displayedMonth,
        ),
        // CalendarDataの各週ごとに_WeekRowを生成
        ...calendarData.map(
              (week) => WeekRow(
                // 隔週の行には日付データのリストが渡される
                week.map((date) => date?.toString() ?? '').toList(),
                onDateSelected: onDateSelected,
                displayedMonth: displayedMonth,
          ),
        ),
      ],
    );
  }
}