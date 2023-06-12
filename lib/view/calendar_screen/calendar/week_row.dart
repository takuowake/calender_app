import 'package:calender_app/view/calendar_screen/calendar/date_box.dart';
import 'package:flutter/material.dart';

/// 曜日を表示するためのウィジェット
class WeekRow extends StatelessWidget {
  const WeekRow(this.items, {super.key, this.isHeader = false, required this.onDateSelected, required this.displayedMonth});

  // 曜日の文字列を格納したリスト
  final List<String> items;
  final bool isHeader;
  final int displayedMonth;
  final Function(DateTime date) onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      // items.lengthの数だけリストを生成
      children: List.generate(
        items.length,
            (index) {
          final item = items[index];
          // DateTime.tryParseは、itemをDateTimeオブジェクトへと変換を試みる。できなければnullを返す
          final date = DateTime.tryParse(item);
          return Expanded(
            // 日付を表示するためのウィジェット
            child: DateBox(
              date: date,
              weekday: index + 1,
              isHeader: isHeader,
              onDateSelected: date == null ? (DateTime date) {} : onDateSelected,
              text: date == null ? item : date.day.toString(),
              displayedMonth: displayedMonth,
            ),
          );
        },
      ).toList(),
    );
  }
}