
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/db/plan_db.dart';

// StateNotifierを拡張したもので、PlanItemDataの状態を保持
class TimelineDataNotifier extends StateNotifier<List<PlanItemData>> {
  TimelineDataNotifier() : super([]);

  // データベースから全てのデータを非同期に読み込む
  Future<List<PlanItemData>> read() async {
    final db = MyDatabase();
    List<PlanItemData> datas = await db.readAllPlanData();
    return datas;
  }
}

// StateNotifierProviderでアプリケーションの他の部分からTimelineDataNotifierのインスタンスにアクセス
final timelineDataProvider =
StateNotifierProvider((ref) => TimelineDataNotifier());