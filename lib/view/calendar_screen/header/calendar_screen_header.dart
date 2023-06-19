import 'package:calender_app/common/string.dart';
import 'package:calender_app/repository/view_model/plan_provider.dart';
import 'package:calender_app/view/calendar_screen/header/header_datepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarScreenHeader extends ConsumerWidget {
  final String currentMonth;
  final PageController pageController;
  final WidgetRef ref;
  final int initialPageIndex;


  const CalendarScreenHeader({
    super.key,
    required this.currentMonth,
    required this.pageController,
    required this.ref,
    required this.initialPageIndex
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),//角の丸み
              ),
            ),
            onPressed: () {
              // DatePickerNotifierの状態を今日の日付に更新
              ref.read(datePickerProvider.notifier).setDate(DateTime.now());
              pageController.jumpToPage(initialPageIndex);
            },
            child: const Text(
              todayText,
              style: TextStyle(color: Colors.black),
            ),
          ),
          const Spacer(),
          Text(
            currentMonth,
            style: const TextStyle(fontSize: 24),
          ),
          const DatePicker(),
          const Spacer(),
        ],
      ),
    );
  }
}