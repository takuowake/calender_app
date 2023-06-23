import 'package:calender_app/repository/view_model/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatePicker extends ConsumerWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        await onPressedElevatedButton(context, ref);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}

Future<void> onPressedElevatedButton(BuildContext context, WidgetRef ref) async {
  final date = ref.watch(datePickerProvider);

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

    // PageControllerを取得し、選択された月にページを移動
    final pageController = ref.read(pageControllerProvider);
    final monthsDifference = (picked.year * 12 + picked.month) - (DateTime.now().year * 12 + DateTime.now().month);
    pageController.jumpToPage(1000 + monthsDifference);
  }
}
