import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// DataPicker
final datePickerProvider = StateNotifierProvider<DatePickerNotifier, DateTime>((ref) => DatePickerNotifier());
class DatePickerNotifier extends StateNotifier<DateTime> {
  DatePickerNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }
}

/// PageController
final pageControllerProvider = Provider<PageController>((ref) {
  return PageController(initialPage: 1000);
});

/// StartDate
final startDateTimeProvider = StateNotifierProvider.autoDispose<StartDateTimeNotifier, DateTime?>((ref) {
  return StartDateTimeNotifier();
});
class StartDateTimeNotifier extends StateNotifier<DateTime?> {
  StartDateTimeNotifier() : super(null);

  void updateDateTime(DateTime? dateTime) {
    state = dateTime;
  }
}

/// EndDate
final endDateTimeProvider = StateNotifierProvider.autoDispose<EndDateTimeNotifier, DateTime?>((ref) {
  return EndDateTimeNotifier();
});
class EndDateTimeNotifier extends StateNotifier<DateTime?> {
  EndDateTimeNotifier() : super(null);

  void updateDateTime(DateTime? dateTime) {
    state = dateTime;
  }
}

/// IsAll
final switchProvider = StateNotifierProvider.autoDispose<SwitchProvider, bool>((ref) {
  return SwitchProvider();
});
class SwitchProvider extends StateNotifier<bool> {
  SwitchProvider() : super(false);

  void updateSwitch(bool value) {
    state = value;
  }
}