import 'package:calender_app/repository/providers/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return GestureDetector(
      onTap: onPressedElevatedButton,
      behavior: HitTestBehavior.translucent, // Ensure tap is detected within the entire area
      child: Container(
        padding: const EdgeInsets.all(16.0), // Adjust padding as needed
        child: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}