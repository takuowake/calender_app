import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_drift_riverpod_calendar/common/event_provider.dart';
import 'package:flutter_drift_riverpod_calendar/service/event_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EventDetailScreen extends HookWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: event.title);

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Detail'),
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
          ),
          ElevatedButton(
            child: Text('Update'),
            onPressed: () {
              // イベントのタイトルを更新する
              context.read(eventProvider).updateEvent(event.copyWith(title: titleController.text));
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: Text('Delete'),
            onPressed: () {
              // イベントを削除する
              context.read(eventProvider).deleteEvent(event);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}