/// DBへの読み込み、追加、削除、更新を行う。
/// DBへの操作が行われるたびに更新通知を送り、画面を再描画する。
import 'package:calender_app/model/freezed/plan_model.dart';
import 'package:calender_app/repository/providers/date_picker_notifier.dart';
import 'package:calender_app/repository/providers/plan_database_norifier.dart';
import 'package:calender_app/repository/providers/switch_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final planDatabaseNotifierProvider = StateNotifierProvider<PlanDatabaseNotifier, PlanStateData>((ref) {
  PlanDatabaseNotifier notify = PlanDatabaseNotifier();
  notify.readData();
  //初期化処理
  return notify;
});

final planDatabaseProvider = Provider<PlanDatabaseNotifier>((ref) {
  // PlanDatabaseNotifierクラスの新しいインスタンスを生成して返す
  return PlanDatabaseNotifier();
});

final datePickerProvider = StateNotifierProvider<DatePickerNotifier, DateTime>((ref) => DatePickerNotifier());

final currentDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final switchProvider = StateNotifierProvider<SwitchProvider, bool>((ref) {
  return SwitchProvider();
});