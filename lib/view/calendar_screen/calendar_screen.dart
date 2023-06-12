import 'package:calender_app/repository/providers/plan_provider.dart';
import 'package:calender_app/view/daily_plan_list_screen/plan_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'header/calendar_screen_header.dart';
import 'calendar/calender.dart';

class CalendarScreen extends ConsumerWidget {
  final DateTime? initialDate;

  const CalendarScreen({Key? key, this.initialDate}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const initialPageIndex = 10000;
    final currentDate = initialDate ?? ref.watch(datePickerProvider);
    final initialPageOffset = (currentDate!.year * 12 + currentDate.month) - (ref.watch(datePickerProvider).year * 12 + ref.watch(datePickerProvider).month);
    final pageController = PageController(initialPage: initialPageIndex + initialPageOffset);

    return Scaffold(
      appBar: AppBar(title: const Text('カレンダー')),
      body: PageView.builder(
        controller: pageController,
        itemBuilder: (context, index) {
          final currentDate = ref.watch(datePickerProvider);
          final monthsToAdd = index - initialPageIndex;
          final displayDate = DateTime(currentDate.year, currentDate.month + monthsToAdd, 1);

          return SizedBox.expand(
            child: Column(
              children: [
                CalendarScreenHeader(
                  currentMonth: '${displayDate.year}年 ${displayDate.month}月',
                  pageController: pageController,
                  ref: ref,
                  initialPageIndex: initialPageIndex,
                ),
                const SizedBox(height: 16),
                Calendar(
                  date: displayDate,
                  displayedMonth: displayDate.month,
                  onDateSelected: (DateTime date) {
                    const PlanList().ShowDialog(context, ref, date);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
