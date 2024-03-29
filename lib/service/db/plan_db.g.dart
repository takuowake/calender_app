// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_db.dart';

// ignore_for_file: type=lint
class $PlanItemTable extends PlanItem
    with TableInfo<$PlanItemTable, PlanItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title =
      GeneratedColumn<String>('title', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isAllMeta = const VerificationMeta('isAll');
  @override
  late final GeneratedColumn<bool> isAll =
      GeneratedColumn<bool>('is_all', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_all" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, comment, isAll, startDate, endDate];
  @override
  String get aliasedName => _alias ?? 'plan_item';
  @override
  String get actualTableName => 'plan_item';
  @override
  VerificationContext validateIntegrity(Insertable<PlanItemData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('is_all')) {
      context.handle(
          _isAllMeta, isAll.isAcceptableOrUnknown(data['is_all']!, _isAllMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanItemData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment'])!,
      isAll: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_all'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
    );
  }

  @override
  $PlanItemTable createAlias(String alias) {
    return $PlanItemTable(attachedDatabase, alias);
  }
}

class PlanItemData extends DataClass implements Insertable<PlanItemData> {
  final int id;
  final String title;
  final String comment;
  final bool isAll;
  final DateTime? startDate;
  final DateTime? endDate;
  const PlanItemData(
      {required this.id,
      required this.title,
      required this.comment,
      required this.isAll,
      this.startDate,
      this.endDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['comment'] = Variable<String>(comment);
    map['is_all'] = Variable<bool>(isAll);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    return map;
  }

  PlanItemCompanion toCompanion(bool nullToAbsent) {
    return PlanItemCompanion(
      id: Value(id),
      title: Value(title),
      comment: Value(comment),
      isAll: Value(isAll),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory PlanItemData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanItemData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      comment: serializer.fromJson<String>(json['comment']),
      isAll: serializer.fromJson<bool>(json['isAll']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'comment': serializer.toJson<String>(comment),
      'isAll': serializer.toJson<bool>(isAll),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
    };
  }

  PlanItemData copyWith(
          {int? id,
          String? title,
          String? comment,
          bool? isAll,
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent()}) =>
      PlanItemData(
        id: id ?? this.id,
        title: title ?? this.title,
        comment: comment ?? this.comment,
        isAll: isAll ?? this.isAll,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
      );
  @override
  String toString() {
    return (StringBuffer('PlanItemData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('comment: $comment, ')
          ..write('isAll: $isAll, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, comment, isAll, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanItemData &&
          other.id == this.id &&
          other.title == this.title &&
          other.comment == this.comment &&
          other.isAll == this.isAll &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class PlanItemCompanion extends UpdateCompanion<PlanItemData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> comment;
  final Value<bool> isAll;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  const PlanItemCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.comment = const Value.absent(),
    this.isAll = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  PlanItemCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.comment = const Value.absent(),
    this.isAll = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
  });
  static Insertable<PlanItemData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? comment,
    Expression<bool>? isAll,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (comment != null) 'comment': comment,
      if (isAll != null) 'is_all': isAll,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    });
  }

  PlanItemCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? comment,
      Value<bool>? isAll,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate}) {
    return PlanItemCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      comment: comment ?? this.comment,
      isAll: isAll ?? this.isAll,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (isAll.present) {
      map['is_all'] = Variable<bool>(isAll.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanItemCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('comment: $comment, ')
          ..write('isAll: $isAll, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $PlanItemTable planItem = $PlanItemTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [planItem];
}
