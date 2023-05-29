// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PlanStateData {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isReadyData => throw _privateConstructorUsedError;
  List<PlanItemData> get planItems => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlanStateDataCopyWith<PlanStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanStateDataCopyWith<$Res> {
  factory $PlanStateDataCopyWith(
          PlanStateData value, $Res Function(PlanStateData) then) =
      _$PlanStateDataCopyWithImpl<$Res, PlanStateData>;
  @useResult
  $Res call({bool isLoading, bool isReadyData, List<PlanItemData> planItems});
}

/// @nodoc
class _$PlanStateDataCopyWithImpl<$Res, $Val extends PlanStateData>
    implements $PlanStateDataCopyWith<$Res> {
  _$PlanStateDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isReadyData = null,
    Object? planItems = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isReadyData: null == isReadyData
          ? _value.isReadyData
          : isReadyData // ignore: cast_nullable_to_non_nullable
              as bool,
      planItems: null == planItems
          ? _value.planItems
          : planItems // ignore: cast_nullable_to_non_nullable
              as List<PlanItemData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PlanStateDataCopyWith<$Res>
    implements $PlanStateDataCopyWith<$Res> {
  factory _$$_PlanStateDataCopyWith(
          _$_PlanStateData value, $Res Function(_$_PlanStateData) then) =
      __$$_PlanStateDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, bool isReadyData, List<PlanItemData> planItems});
}

/// @nodoc
class __$$_PlanStateDataCopyWithImpl<$Res>
    extends _$PlanStateDataCopyWithImpl<$Res, _$_PlanStateData>
    implements _$$_PlanStateDataCopyWith<$Res> {
  __$$_PlanStateDataCopyWithImpl(
      _$_PlanStateData _value, $Res Function(_$_PlanStateData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isReadyData = null,
    Object? planItems = null,
  }) {
    return _then(_$_PlanStateData(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isReadyData: null == isReadyData
          ? _value.isReadyData
          : isReadyData // ignore: cast_nullable_to_non_nullable
              as bool,
      planItems: null == planItems
          ? _value._planItems
          : planItems // ignore: cast_nullable_to_non_nullable
              as List<PlanItemData>,
    ));
  }
}

/// @nodoc

class _$_PlanStateData implements _PlanStateData {
  _$_PlanStateData(
      {this.isLoading = false,
      this.isReadyData = false,
      final List<PlanItemData> planItems = const []})
      : _planItems = planItems;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isReadyData;
  final List<PlanItemData> _planItems;
  @override
  @JsonKey()
  List<PlanItemData> get planItems {
    if (_planItems is EqualUnmodifiableListView) return _planItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_planItems);
  }

  @override
  String toString() {
    return 'PlanStateData(isLoading: $isLoading, isReadyData: $isReadyData, planItems: $planItems)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlanStateData &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isReadyData, isReadyData) ||
                other.isReadyData == isReadyData) &&
            const DeepCollectionEquality()
                .equals(other._planItems, _planItems));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, isReadyData,
      const DeepCollectionEquality().hash(_planItems));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PlanStateDataCopyWith<_$_PlanStateData> get copyWith =>
      __$$_PlanStateDataCopyWithImpl<_$_PlanStateData>(this, _$identity);
}

abstract class _PlanStateData implements PlanStateData {
  factory _PlanStateData(
      {final bool isLoading,
      final bool isReadyData,
      final List<PlanItemData> planItems}) = _$_PlanStateData;

  @override
  bool get isLoading;
  @override
  bool get isReadyData;
  @override
  List<PlanItemData> get planItems;
  @override
  @JsonKey(ignore: true)
  _$$_PlanStateDataCopyWith<_$_PlanStateData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TempPlanItemData {
  String get title => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;
  bool get isAllDay => throw _privateConstructorUsedError;
  DateTime? get start => throw _privateConstructorUsedError;
  DateTime? get end => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TempPlanItemDataCopyWith<TempPlanItemData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TempPlanItemDataCopyWith<$Res> {
  factory $TempPlanItemDataCopyWith(
          TempPlanItemData value, $Res Function(TempPlanItemData) then) =
      _$TempPlanItemDataCopyWithImpl<$Res, TempPlanItemData>;
  @useResult
  $Res call(
      {String title,
      String comment,
      bool isAllDay,
      DateTime? start,
      DateTime? end});
}

/// @nodoc
class _$TempPlanItemDataCopyWithImpl<$Res, $Val extends TempPlanItemData>
    implements $TempPlanItemDataCopyWith<$Res> {
  _$TempPlanItemDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? comment = null,
    Object? isAllDay = null,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      isAllDay: null == isAllDay
          ? _value.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TempPlanItemDataCopyWith<$Res>
    implements $TempPlanItemDataCopyWith<$Res> {
  factory _$$_TempPlanItemDataCopyWith(
          _$_TempPlanItemData value, $Res Function(_$_TempPlanItemData) then) =
      __$$_TempPlanItemDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String comment,
      bool isAllDay,
      DateTime? start,
      DateTime? end});
}

/// @nodoc
class __$$_TempPlanItemDataCopyWithImpl<$Res>
    extends _$TempPlanItemDataCopyWithImpl<$Res, _$_TempPlanItemData>
    implements _$$_TempPlanItemDataCopyWith<$Res> {
  __$$_TempPlanItemDataCopyWithImpl(
      _$_TempPlanItemData _value, $Res Function(_$_TempPlanItemData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? comment = null,
    Object? isAllDay = null,
    Object? start = freezed,
    Object? end = freezed,
  }) {
    return _then(_$_TempPlanItemData(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      isAllDay: null == isAllDay
          ? _value.isAllDay
          : isAllDay // ignore: cast_nullable_to_non_nullable
              as bool,
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      end: freezed == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_TempPlanItemData implements _TempPlanItemData {
  _$_TempPlanItemData(
      {this.title = '',
      this.comment = '',
      this.isAllDay = false,
      this.start = null,
      this.end = null});

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String comment;
  @override
  @JsonKey()
  final bool isAllDay;
  @override
  @JsonKey()
  final DateTime? start;
  @override
  @JsonKey()
  final DateTime? end;

  @override
  String toString() {
    return 'TempPlanItemData(title: $title, comment: $comment, isAllDay: $isAllDay, start: $start, end: $end)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TempPlanItemData &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.isAllDay, isAllDay) ||
                other.isAllDay == isAllDay) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, title, comment, isAllDay, start, end);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TempPlanItemDataCopyWith<_$_TempPlanItemData> get copyWith =>
      __$$_TempPlanItemDataCopyWithImpl<_$_TempPlanItemData>(this, _$identity);
}

abstract class _TempPlanItemData implements TempPlanItemData {
  factory _TempPlanItemData(
      {final String title,
      final String comment,
      final bool isAllDay,
      final DateTime? start,
      final DateTime? end}) = _$_TempPlanItemData;

  @override
  String get title;
  @override
  String get comment;
  @override
  bool get isAllDay;
  @override
  DateTime? get start;
  @override
  DateTime? get end;
  @override
  @JsonKey(ignore: true)
  _$$_TempPlanItemDataCopyWith<_$_TempPlanItemData> get copyWith =>
      throw _privateConstructorUsedError;
}
