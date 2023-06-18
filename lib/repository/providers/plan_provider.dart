/// DBへの読み込み、追加、削除、更新を行う。
/// DBへの操作が行われるたびに更新通知を送り、画面を再描画する。
import 'package:calender_app/common/fifteen_intervals.dart';
import 'package:calender_app/model/freezed/plan_model.dart';
import 'package:calender_app/repository/providers/date_picker_notifier.dart';
import 'package:calender_app/repository/providers/plan_database_norifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final planDatabaseNotifierProvider = StateNotifierProvider<PlanDatabaseNotifier, PlanStateData>((ref) {
  PlanDatabaseNotifier notify = PlanDatabaseNotifier();
  notify.readData();
  return notify;
});

final planDatabaseProvider = Provider<PlanDatabaseNotifier>((ref) {
  // PlanDatabaseNotifierクラスの新しいインスタンスを生成して返す
  return PlanDatabaseNotifier();
});

final datePickerProvider = StateNotifierProvider<DatePickerNotifier, DateTime>((ref) => DatePickerNotifier());

final pageControllerProvider = Provider<PageController>((ref) {
  return PageController(initialPage: 1000);
});

class StartDateTimeNotifier extends StateNotifier<DateTime?> {
  StartDateTimeNotifier() : super(null);

  void updateDateTime(DateTime? dateTime) {
    state = dateTime;
  }
}

final startDateTimeProvider = StateNotifierProvider<StartDateTimeNotifier, DateTime?>((ref) {
  return StartDateTimeNotifier();
});

class EndDateTimeNotifier extends StateNotifier<DateTime?> {
  EndDateTimeNotifier() : super(null);

  void updateDateTime(DateTime? dateTime) {
    state = dateTime;
  }
}

final endDateTimeProvider = StateNotifierProvider<EndDateTimeNotifier, DateTime?>((ref) {
  return EndDateTimeNotifier();
});