import 'package:calender_app/service/db/plan_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'plan_model.freezed.dart';

@freezed
//このクラスは、DBの状態を保持するクラスです。
abstract class PlanStateData with _$PlanStateData {
  factory PlanStateData({
    @Default(false) bool isLoading,
    @Default(false) bool isReadyData,
    @Default([]) List<PlanItemData> planItems,
  }) = _PlanStateData;
}

@freezed
//このクラスは、入力中のplanを保持するクラスです。
abstract class TempPlanItemData with _$TempPlanItemData {
  factory TempPlanItemData({
    @Default('') String title,
    @Default('') String comment,
    @Default(false) bool isAll,
    @Default(null) DateTime? startDate,
    @Default(null) DateTime? endDate,
  }) = _TempPlanItemData;
}