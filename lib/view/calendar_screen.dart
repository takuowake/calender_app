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
    DateTime.now().subtract(Duration(days: 1)),
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
  ]);

  void setDate(DateTime date) {
    state = [
      date.subtract(Duration(days: 1)),
      date,
      date.add(Duration(days: 1)),
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
  CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Providerの状態が変化した際に再ビルドします
    // final planState = ref.watch(planDatabaseProvider);
    //Providerのメソッドや値を取得します
    //dialogが閉じた際に再ビルドするために使用します。
    // final planProvider = ref.watch(planDatabaseProvider);
    //Providerが保持しているplanItemsを取得します。
    // List<PlanItemData> planItems = planProvider.state.planItems;
    //追加
    TempPlanItemData temp = TempPlanItemData();

    // 現在の日付をStateProviderから取得します
    final currentDate = ref.watch(currentDateProvider.notifier).state;

    final selectedDate = ref.watch(datePickerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('カレンダー')),
      body: SizedBox.expand(
        child: Column(
          children: [
            CalendarScreenHeader(
              currentMonth: '${selectedDate.year}年 ${selectedDate.month}月',
            ),
            SizedBox(height: 16),
            Calendar(
              date: selectedDate,
              onDateSelected: (DateTime date) {
                PlanList().ShowDialog(context, ref, date);
              },
            ),
          ],
        ),
      ),
    );
  }
}