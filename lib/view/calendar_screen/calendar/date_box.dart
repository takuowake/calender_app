import 'package:calender_app/repository/providers/plan_database_norifier.dart';
import 'package:calender_app/service/db/plan_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// カレンダーの日付を表示するためのウィジェット
class DateBox extends ConsumerWidget {
  const DateBox({super.key,
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

    if (date != null) {
      final now = DateTime.now();
      final dateFormat = DateFormat('yyyy-MM-dd');
      isToday = dateFormat.format(date!) == dateFormat.format(now);
      boxHeight = 0.9;
    }

    if (date != null && date?.month != displayedMonth) {
      textColor = Colors.grey;
    } else if (isToday == true) {
      textColor = Colors.white;
    } else if (weekday == 6) {
      textColor = Colors.blue;
    } else if (weekday == 7) {
      textColor = Colors.red;
    } else {
      textColor = Colors.black;
    }

    if (isHeader) {
      backgroundColor = Color.fromARGB(240, 240, 240, 240);
      fontSize = 10.0;
      boxHeight = 3;
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