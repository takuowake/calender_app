import '../service/event_database.dart';

class EventRepository {
  final EventDatabase eventDatabase;

  EventRepository({required this.eventDatabase});

  Stream<List<Event>> watchAllEvents() {
    return eventDatabase.watchAllEvents();
  }

  Future insertEvent(Event event) async {
    await eventDatabase.insertEvent(event);
  }

  Future updateEvent(Event event) async {
    await eventDatabase.updateEvent(event);
  }

  Future deleteEvent(Event event) async {
    await eventDatabase.deleteEvent(event);
  }
}
