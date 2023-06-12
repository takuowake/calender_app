import 'package:calender_app/view/plan_list.dart';
import 'package:calender_app/view/view_model/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'calendar_screen_header.dart';
import 'calender.dart';

final currentDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
class DateRangeNotifier extends StateNotifier<List<DateTime>> {
  DateRangeNotifier() : super([
    DateTime.now().subtract(const Duration(days: 1)),
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
  ]);

  void setDate(DateTime date) {
    state = [
      date.subtract(const Duration(days: 1)),
      date,
      date.add(const Duration(days: 1)),
    ];
  }
}

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
