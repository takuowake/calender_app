import 'package:calender_app/common/fifteen_intervals.dart';
import 'package:calender_app/model/freezed/plan_model.dart';
import 'package:calender_app/repository/providers/plan_provider.dart';
import 'package:calender_app/repository/providers/switch_provider.dart';
import 'package:calender_app/view/calendar_screen/calendar_screen.dart';
import 'package:calender_app/view/daily_plan_list_screen/plan_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';


class AddPlanScreen extends HookConsumerWidget {

  //Providerが保持しているplanItemsを取得します。
  TempPlanItemData temp = TempPlanItemData();
  final DateTime selectedDate;
  AddPlanScreen({super.key, required this.selectedDate});

  late DateTime startDateTime = roundToNearestFifteen(DateTime.now());
  late DateTime endDateTime = startDateTime.add(const Duration(hours: 1));

  final titleFocusNode = FocusNode();


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    void showEditCanselConfirmation(BuildContext context) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(switchProvider.notifier).updateSwitch(false);
                ref.read(startDateTimeProvider.notifier).updateDateTime(roundToNearestFifteen(DateTime.now()));
                ref.read(endDateTimeProvider.notifier).updateDateTime(roundToNearestFifteen(DateTime.now().add(const Duration(hours: 1))));
                Navigator.of(context).pop();
              },
              isDestructiveAction: true,
              child: const Text('編集を破棄', style: TextStyle(color: Colors.blue)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('キャンセル'),
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          ),
        ),
      );
    }

    //Providerの状態が変化したさいに再ビルドします
    final planProvider = ref.watch(planDatabaseNotifierProvider.notifier);

    final start = useState<DateTime?>(null);
    final end = useState<DateTime?>(null);
    final title = useState('');
    final comment = useState('');

    final isChanged = useState<bool>(false);
    void handleInputChange() {
      isChanged.value = true;
    }

    final initialEndDateTimeProvider = StateProvider<DateTime?>((ref) => roundToNearestFifteen(DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      DateTime.now().hour + 1,
      DateTime.now().minute,
    )));




    return GestureDetector(
      onTap: () {
        // キーボードが表示されている場合、非表示にする
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('予定の追加')),
          leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (isChanged.value) {
                showEditCanselConfirmation(context);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 5, bottom: 5),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (temp.title.isNotEmpty && temp.comment.isNotEmpty) {
                      return Colors.white; // 保存ボタンの背景色を変更
                    } else {
                      return Colors.white70;
                    }
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (temp.title.isNotEmpty && temp.comment.isNotEmpty) {
                      return Colors.black;
                    } else {
                      return Colors.grey;
                    }
                  }),
                ),
                onPressed: (temp.title.isNotEmpty && temp.comment.isNotEmpty) ? () async {
                  temp = temp.copyWith(
                    startDate: temp.startDate ?? startDateTime,
                    endDate: temp.endDate ?? endDateTime,
                  );
                  await planProvider.writeData(temp);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  PlanList().ShowDialog(context, ref, startDateTime);
                  ref.read(switchProvider.notifier).updateSwitch(false);
                  ref.read(startDateTimeProvider.notifier).updateDateTime(roundToNearestFifteen(DateTime.now()));
                  ref.read(endDateTimeProvider.notifier).updateDateTime(roundToNearestFifteen(DateTime.now().add(const Duration(hours: 1))));
                } : null,
                child: const Text('保存'),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  style: const TextStyle(color: Colors.grey),
                  autofocus: true,
                  focusNode: titleFocusNode,
                  decoration: const InputDecoration(
                    hintText: 'タイトルを入力してください',
                    contentPadding: EdgeInsets.only(left: 10),
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    title.value = value;
                    temp = temp.copyWith(title: value);
                    handleInputChange();
                  },
                  onSubmitted: (value) {
                    title.value = value;
                    temp = temp.copyWith(title: value);
                  },
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('終日'),
                              Switch(
                                value: ref.watch(switchProvider),
                                activeColor: Colors.blue,
                                activeTrackColor: Colors.blueAccent,
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (value) {
                                  ref.read(switchProvider.notifier).updateSwitch(value);
                                  temp = temp.copyWith(isAll: value);
                                  handleInputChange();
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('開始'),
                              // タップを検出するためのウィジェット
                              GestureDetector(
                                onTap: () async {
                                  final DateTime? selectedDate = await showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => Container(
                                      height: MediaQuery.of(context).size.height / 3 + 16,
                                      color: CupertinoColors.white,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CupertinoButton(
                                                  // ダイアログが閉じられる
                                                  child: const Text('キャンセル'),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                ),
                                                CupertinoButton(
                                                  // selectDateがダイアログpopされる
                                                  child: const Text('完了'),
                                                  onPressed: ()  {
                                                    temp = temp.copyWith(startDate: start.value);
                                                    if (startDateTime != start.value) {
                                                      handleInputChange();
                                                    }
                                                    ref.read(startDateTimeProvider.notifier).updateDateTime(start.value!);
                                                    ref.read(endDateTimeProvider.notifier).updateDateTime(start.value!.add(Duration(hours: 1)));
                                                    startDateTime = start.value!;
                                                    endDateTime = start.value!.add(const Duration(hours: 1));
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 220,
                                            child: CupertinoDatePicker(
                                              // 初期値を設定
                                              initialDateTime: startDateTime,
                                              // DatePickerのモードを指定（場合分け）
                                              mode: ref.watch(switchProvider) ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                              minuteInterval: 15,
                                              use24hFormat: true,
                                              onDateTimeChanged: (dateTime) {
                                                start.value = DateTime(
                                                  dateTime.year,
                                                  dateTime.month,
                                                  dateTime.day,
                                                  dateTime.hour,
                                                  dateTime.minute,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Consumer(
                                  builder: (context, watch, _) {
                                    final switchState = ref.watch(switchProvider);
                                    final format = switchState ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm';
                                    final initialStartDateTime = roundToNearestFifteen(DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      DateTime.now().hour,
                                      DateTime.now().minute,
                                    ));
                                    final startDateTime = ref.watch(startDateTimeProvider);
                                    return Text(
                                      DateFormat(format).format(startDateTime ?? initialStartDateTime),
                                      // DateFormat(format).format(startDateTime),
                                      style: const TextStyle(color: Colors.blue),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('終了'),
                              GestureDetector(
                                onTap: () async {
                                  final DateTime? selectedDate = await showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => Container(
                                      height: MediaQuery.of(context).size.height / 3 + 16,
                                      color: CupertinoColors.white,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CupertinoButton(
                                                  child: const Text('キャンセル'),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                ),
                                                CupertinoButton(
                                                  child: const Text('完了'),
                                                  onPressed: () {
                                                    temp = temp.copyWith(endDate: end.value);
                                                    if (endDateTime != end.value) {
                                                      handleInputChange();
                                                    }
                                                    ref.read(endDateTimeProvider.notifier).updateDateTime(end.value!);
                                                    endDateTime = end.value!;
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 220,
                                            child: CupertinoDatePicker(
                                              // 初期値を設定
                                              initialDateTime: endDateTime,
                                              // DatePickerのモードを指定（場合分け）
                                              mode: ref.watch(switchProvider) ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                              minuteInterval: 15,
                                              use24hFormat: true,
                                              minimumDate: startDateTime.add(const Duration(hours: 1)),
                                              onDateTimeChanged: (dateTime) {
                                                end.value = DateTime(
                                                  dateTime.year,
                                                  dateTime.month,
                                                  dateTime.day,
                                                  dateTime.hour,
                                                  dateTime.minute,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Consumer(
                                  builder: (context, watch, _) {
                                    final switchState = ref.watch(switchProvider);
                                    final format = switchState ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm';
                                    final initialEndDateTime = roundToNearestFifteen(DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      DateTime.now().hour+1,
                                      DateTime.now().minute,
                                    ));
                                    final endDateTime = ref.watch(endDateTimeProvider);
                                    return Text(
                                      DateFormat(format).format(endDateTime ?? initialEndDateTime),
                                      // DateFormat(format).format(endDateTime),
                                      style: const TextStyle(color: Colors.blue),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 200,
                  width: 400,
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'コメントを入力してください',
                      contentPadding: EdgeInsets.only(left: 10, top: 20, ),
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      comment.value = value;
                      temp = temp.copyWith(comment: value);
                      handleInputChange();
                    },
                    onSubmitted: (value) {
                      comment.value = value;
                      temp = temp.copyWith(comment: value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}