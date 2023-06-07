/// カレンダー画面で使うプロバイダのためのクラスを記述
import 'package:freezed_annotation/freezed_annotation.dart';

import '../db/plan_db.dart';

part 'plan_model.freezed.dart';

DateTime roundToNearestFifteen(DateTime dateTime) {
  final int minute = dateTime.minute;
  final int remainder = minute % 15;
  if (remainder >= 8) {
    return dateTime.add(Duration(minutes: 15 - remainder));
  } else {
    return dateTime.subtract(Duration(minutes: remainder));
  }
}

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