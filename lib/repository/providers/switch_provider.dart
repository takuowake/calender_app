import 'package:calender_app/repository/providers/plan_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SwitchProvider extends StateNotifier<bool> {
  SwitchProvider() : super(false);

  void updateSwitch(bool value) {
    state = value;
  }
}

final switchProvider = StateNotifierProvider<SwitchProvider, bool>((ref) {
  return SwitchProvider();
});