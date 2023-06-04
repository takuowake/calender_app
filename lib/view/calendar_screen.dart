import 'package:calender_app/view/plan_list.dart';
import 'package:calender_app/view/view_model/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/db/plan_db.dart';
import '../model/freezed/plan_model.dart';
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
// 新たに状態管理用のStateNotifierを定義
class DatePickerNotifier extends StateNotifier<DateTime> {
  DatePickerNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }
}
// DatePickerNotifier用のProviderを定義
final datePickerProvider = StateNotifierProvider<DatePickerNotifier, DateTime>((ref) => DatePickerNotifier());
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final selectedDate = ref.watch(datePickerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('カレンダー')),
      body: SizedBox.expand(
        child: Column(
          children: [
            CalendarScreenHeader(
              currentMonth: '${selectedDate.year}年 ${selectedDate.month}月',
            ),
            const SizedBox(height: 16),
            Calendar(
              date: selectedDate,
              onDateSelected: (DateTime date) {
                const PlanList().ShowDialog(context, ref, date);
              },
            ),
          ],
        ),
      ),
    );
  }
}