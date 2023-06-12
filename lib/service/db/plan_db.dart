/// planを記録するためのDBを構築する

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'dart:io';

part 'plan_db.g.dart';

class PlanItem extends Table {
  IntColumn get id => integer().autoIncrement()(); //primary key
  // タイトルは最低1文字以上
  TextColumn get title =>
      text().withDefault(const Constant('')).withLength(min: 1)();
  // コメントはnullでも許容
  TextColumn get comment => text().withDefault(const Constant(''))();

  // 終日かどうか
  BoolColumn get isAll => boolean().withDefault(const Constant(false))();

  // 開始時間と終了時間
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
}

// データベース接続
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // SQLiteデータベースファイルをアプリケーションのドキュメントディレクトリに配置
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [PlanItem])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //全てのデータ取得
  Future<List<PlanItemData>> readAllPlanData() => select(planItem).get();

  //追加
  Future writePlan(PlanItemCompanion data) => into(planItem).insert(data);

  //更新
  Future updatePlan(PlanItemData data) => update(planItem).replace(data);

  //削除
  Future deletePlan(int id) => (delete(planItem)..where((it) => it.id.equals(id))).go();
}