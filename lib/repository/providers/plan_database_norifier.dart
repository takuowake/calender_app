import 'package:calender_app/model/freezed/plan_model.dart';
import 'package:calender_app/service/db/plan_db.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Database
// 予定データベースの操作を管理するためのクラス
// StateNotifier<PlanStateData>を継承しており、内部でデータベースへの操作を行うメソッドやデータの状態を管理する状態を持っている
class PlanDatabaseNotifier extends StateNotifier<PlanStateData> {
  //ここからはデータベースに関する処理をこのクラスで行えるように記述します。
  PlanDatabaseNotifier() : super(PlanStateData());
  final _db = MyDatabase();
  bool hasChanges = false;
  // 予定追加処理
  writeData(TempPlanItemData data) async {

    PlanItemCompanion entry = PlanItemCompanion(
      title: Value(data.title),
      comment: Value(data.comment),
      startDate: Value(data.startDate),
      endDate: Value(data.endDate),
      isAll: Value(data.isAll),
    );
    state = state.copyWith(isLoading: true);
    await _db.writePlan(entry);
    readData();
  }

  //削除処理部分
  deleteData(PlanItemData data) async {
    state = state.copyWith(isLoading: true);
    await _db.deletePlan(data.id);
    readData();
    //削除するたびにデータベースを読み込む
  }

  //更新処理部分
  updateData(PlanItemData data) async {
    if (data.title.isEmpty) {
      return;
    }
    state = state.copyWith(isLoading: true);
    await _db.updatePlan(data);
    readData();
    //更新するたびにデータベースを読み込む
  }

  //データ読み込み処理
  readData() async {
    state = state.copyWith(isLoading: true);

    final planItems = await _db.readAllPlanData();

    state = state.copyWith(
      isLoading: false,
      isReadyData: true,
      planItems: planItems,
    );
  }
}
final planDatabaseNotifierProvider = StateNotifierProvider<PlanDatabaseNotifier, PlanStateData>((ref) {
  PlanDatabaseNotifier notify = PlanDatabaseNotifier();
  notify.readData();
  return notify;
});