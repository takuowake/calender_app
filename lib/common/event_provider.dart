import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/event_repository.dart';
import '../service/event_database.dart';

final eventProvider = Provider<EventRepository>((ref) {
  final database = EventDatabase();
  return EventRepository(eventDatabase: database);
});
