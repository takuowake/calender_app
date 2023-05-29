/// DBへの読み込み、追加、削除、更新を行う。
/// DBへの操作が行われるたびに更新通知を送り、画面を再描画する。

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../model/db/plan_db.dart';
import '../../model/freezed/plan_model.dart';

//データベースの状態が変わるたびPlanのviewをビルドするようにするクラスです。
class PlanDatabaseNotifier extends StateNotifier<PlanStateData> {
  //ここからはデータベースに関する処理をこのクラスで行えるように記述します。
  PlanDatabaseNotifier() : super(PlanStateData());
  final _db = MyDatabase();
  //書き込み処理部分
  writeData(TempPlanItemData data) async {
    if (data.title.isEmpty) {
      return;
    }
    PlanItemCompanion entry = PlanItemCompanion(
      title: Value(data.title),
      comment: Value(data.comment),
      startDate: Value(data.start ?? DateTime.now()),
      endDate: Value(data.end ?? DateTime.now()),
      isAllDay: Value(data.isAllDay),
    );
    state = state.copyWith(isLoading: true);
    await _db.writePlan(entry);
    //書き込むたびにデータベースを読み込む
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
    //stateを更新します
    //freezedを使っているので、copyWithを使うことができます
    //これは、stateの中身をすべて更新する必要がありません。例えば
    //state.copyWith(isLoading: true)のように一つの値だけを更新することもできます。
    //複数の値を監視したい際、これはとても便利です。
  }
}

final planDatabaseProvider = StateNotifierProvider((_) {
  PlanDatabaseNotifier notify = PlanDatabaseNotifier();
  notify.readData();
  //初期化処理
  return notify;
});