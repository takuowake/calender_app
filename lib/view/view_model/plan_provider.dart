/// DBへの読み込み、追加、削除、更新を行う。
/// DBへの操作が行われるたびに更新通知を送り、画面を再描画する。

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../model/db/plan_db.dart';
import '../../model/freezed/plan_model.dart';
import '../calendar_screen.dart';

//データベースの状態が変わるたびPlanのviewをビルドするようにするクラスです。
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
  //初期化処理
  return notify;
});

// PlanDatabaseNotifierのインスタンスをアプリ全体で利用できるようにするためのProviderを定義
// PlanDatabaseNotifierは、状態管理やデータの変更を通知するためのクラス
// refは、プロバイダーの値を利用するためのProviderContainerオブジェクト
final planDatabaseProvider = Provider<PlanDatabaseNotifier>((ref) {
  // PlanDatabaseNotifierクラスの新しいインスタンスを生成して返す
  return PlanDatabaseNotifier();
});

// final planNotifierProvider = StateNotifierProvider<PlanDatabaseNotifier, PlanStateData>((ref) {
//   return PlanDatabaseNotifier();
// });

// final selectDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
// final titleControllerProvider = StateProvider<StateController<String>>((ref) => StateController(""));
// final titleStateProvider = StateProvider<String>((ref) => "");
// final selectedDateProvider = StateProvider<DateTime?>((ref) => null);
//

class SwitchProvider extends StateNotifier<bool> {
  SwitchProvider() : super(false);

  void updateSwitch(bool value) {
    state = value;
  }
}

// DatePickerNotifier用のProviderを定義
final datePickerProvider = StateNotifierProvider<DatePickerNotifier, DateTime>((ref) => DatePickerNotifier());
// 新たに状態管理用のStateNotifierを定義
class DatePickerNotifier extends StateNotifier<DateTime> {
  DatePickerNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }
}
// final tempPlanItemProvider = StateProvider<TempPlanItemData>((ref) => TempPlanItemData());
// final tempProvider = StateNotifierProvider<TempPlanItemDataNotifier, TempPlanItemData>((ref) {
//   return TempPlanItemDataNotifier(TempPlanItemData());
// });

// class TempPlanItemDataNotifier extends StateNotifier<TempPlanItemData> {
//   TempPlanItemDataNotifier(TempPlanItemData state) : super(state);
//
//   void setTitle(String title) {
//     state = state.copyWith(title: title);
//   }
//
//   void setComment(String comment) {
//     state = state.copyWith(comment: comment);
//   }
// }

