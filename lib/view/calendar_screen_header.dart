import 'package:calender_app/view/plan_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 新たに状態管理用のStateNotifierを定義
class DatePickerNotifier extends StateNotifier<DateTime> {
  DatePickerNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }
}

// DatePickerNotifier用のProviderを定義
final datePickerProvider = StateNotifierProvider<DatePickerNotifier, DateTime>((ref) => DatePickerNotifier());

class CalendarScreenHeader extends ConsumerWidget {
  const CalendarScreenHeader({
    Key? key,
    required this.currentMonth,
  });

  final String currentMonth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),//角の丸み
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => PlanList(),
            );
          },
          child: Text(
            '今日',
            style: TextStyle(color: Colors.black),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(currentMonth),
          ),
        ),
        DatePicker(),
      ],
    );
  }
}

class DatePicker extends ConsumerWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // DatePickerNotifierから現在の日付を取得
    final date = ref.watch(datePickerProvider);

    void onPressedElevatedButton() async {
      final DateTime? picked = await showDatePicker(
        locale: const Locale("ja"),
        context: context,
        initialDate: date,
        firstDate: DateTime(2010, 1, 1),
        lastDate: DateTime(2030, 12, 31),
      );

      if (picked != null) {
        // 日付が選択された場合、DatePickerNotifierの状態を更新
        ref.read(datePickerProvider.notifier).setDate(picked);
      }
    }
    return IconButton(
      onPressed: onPressedElevatedButton,
      icon: Icon(Icons.arrow_drop_down),
    );
  }
}