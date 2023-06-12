import 'package:calender_app/view/view_model/plan_provider.dart';
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
              '今日',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const Spacer(),
          Text(
            currentMonth,
            style: const TextStyle(fontSize: 24),
          ),
          const DatePicker(),
          const Spacer(), //
        ],
      ),
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
      icon: const Icon(Icons.arrow_drop_down),
    );
  }
}