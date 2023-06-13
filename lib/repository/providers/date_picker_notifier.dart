// 新たに状態管理用のStateNotifierを定義
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DatePickerNotifier extends StateNotifier<DateTime> {
  DatePickerNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }
}