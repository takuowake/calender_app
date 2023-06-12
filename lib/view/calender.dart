import 'package:calender_app/view/view_model/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
// import 'package:flutter/painting.dart';


import '../common/calendar_builder.dart';
import '../model/db/plan_db.dart';

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
    // final calendar = ref.watch(datePickerProvider);

    final displayedMonth = date.month;

    // int currentMonth = calendar.month;

    return Column(
      children: [
        _WeekRow(
          const ['月', '火', '水', '木', '金', '土', '日'],
          isHeader: true,
          onDateSelected: (DateTime date) {},
          displayedMonth: displayedMonth,
        ),
        // CalendarDataの各週ごとに_WeekRowを生成
        ...calendarData.map(
              (week) => _WeekRow(
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

/// 曜日を表示するためのウィジェット
class _WeekRow extends StatelessWidget {
  const _WeekRow(this.items, {this.isHeader = false, required this.onDateSelected, required this.displayedMonth});

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
            child: _DateBox(
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

/// カレンダーの日付を表示するためのウィジェット
class _DateBox extends ConsumerWidget {
  const _DateBox({
    required this.text,
    this.date,
    required this.displayedMonth,
    required this.weekday,
    this.isHeader = false,
    required this.onDateSelected,
  });

  final String text;
  final DateTime? date;
  final int displayedMonth;
  final int weekday;
  final bool isHeader;
  final Function(DateTime date) onDateSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planState = ref.watch(planDatabaseNotifierProvider);
    final planItems = planState.planItems;

    Color textColor;
    Color backgroundColor = Colors.white;

    // int currentMonth = calendar.month;
    double fontSize = 14.0;
    double boxHeight = 1.0;
    bool isToday = false;
    bool isData = false;

    // planItems の中で該当する日付があるかをチェック
    if (date != null) {
      for (PlanItemData item in planItems) {
        DateTime startOfDay = DateTime(date!.year, date!.month, date!.day);
        DateTime endOfDay = DateTime(date!.year, date!.month, date!.day, 23, 59, 59);

        if ((item.startDate?.isBefore(endOfDay) ?? false) &&
            (item.endDate?.isAfter(startOfDay) ?? false)) {
          // 該当する日付があれば isData を true に設定
          isData = true;
          break;
        }
      }
    }

    if (date != null && date?.month != displayedMonth) {
      textColor = Colors.grey;
    } else if (weekday == 6) {
      textColor = Colors.blue;
    } else if (weekday == 7) {
      textColor = Colors.red;
    } else {
      textColor = Colors.black;
    }

    if (isHeader) {
      backgroundColor = Colors.grey;
      fontSize = 10.0;
      boxHeight = 3;
    }

    if (date != null) {
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyy-MM-dd');
      isToday = dateFormat.format(date!) == dateFormat.format(now);
      boxHeight = 0.9;
    }

    // 子要素のアスペクト比を制御可能
    return AspectRatio(
      aspectRatio: boxHeight,
      child: GestureDetector(
        onTap: () {
          if (date != null) {
            onDateSelected(date!);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: Stack(
            children: [
              // 今日の日付に青丸を表示
              if(isToday)
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              Center(
                child: Text(
                  // Headerがあればtextを表示。なければdate.dayを表示
                  isHeader ? text : date?.day.toString() ?? '',
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                  ),
                ),
              ),

              if(!isHeader && isData)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 8.0,
                  width: 8.0,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}