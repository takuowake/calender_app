import 'package:drift/drift.dart';

part 'event_database.drift.dart';

@DataClassName('Event')
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  DateTimeColumn get date => dateTime()();
}

@DriftDatabase(tables: [Events])
class EventDatabase extends _$EventDatabase {
  EventDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  Future<List<Event>> getAllEvents() => select(events).get();
  Stream<List<Event>> watchAllEvents() => select(events).watch();
  Future insertEvent(Event event) => into(events).insert(event);
  Future updateEvent(Event event) => update(events).replace(event);
  Future deleteEvent(Event event) => delete(events).delete(event);
}
