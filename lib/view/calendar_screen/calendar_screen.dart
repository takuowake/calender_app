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
    const initialPageIndex = 1000;
    final pageController = ref.watch(pageControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('カレンダー'))),
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (index) {
          final monthsToAdd = index - initialPageIndex;
          final newDate = DateTime(DateTime.now().year, DateTime.now().month + monthsToAdd, 1);
          ref.read(datePickerProvider.notifier).setDate(newDate);
        },
        itemBuilder: (context, index) {
          final monthsToAdd = index - initialPageIndex;
          final displayDate = DateTime(DateTime.now().year, DateTime.now().month + monthsToAdd, 1);

          return SizedBox.expand(
            child: Column(
              children: [
                CalendarScreenHeader(
                  currentMonth: '${displayDate.year}年 ${displayDate.month.toString().padLeft(2, '0')}月',
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