import 'package:calender_app/common/fifteen_intervals.dart';
import 'package:calender_app/common/string.dart';
import 'package:calender_app/model/freezed/plan_model.dart';
import 'package:calender_app/repository/providers/plan_database_norifier.dart';
import 'package:calender_app/repository/view_model/plan_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';


class AddPlanScreen extends HookConsumerWidget {

  // データベースに格納するための変数を定義
  TempPlanItemData temp = TempPlanItemData();

  // ユーザーが選択した日付を取得
  final DateTime selectedDate;
  AddPlanScreen({super.key, required this.selectedDate});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // 編集キャンセルのモーダル
    void showEditCanselConfirmation(BuildContext context) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              isDestructiveAction: true,
              child: const Text(editCancelText, style: TextStyle(color: Colors.blue)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(cancelText),
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          ),
        ),
      );
    }

    // providerの監視
    final planProvider = ref.watch(planDatabaseNotifierProvider.notifier);
    final startDateTime = ref.watch(startDateTimeProvider);
    final endDateTime = ref.watch(endDateTimeProvider);

    // useStateの定義
    final titleState = useState('');
    final commentState = useState('');
    final startState = useState<DateTime?>(roundToNearestFifteen(DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      DateTime.now().hour,
      DateTime.now().minute,
    )),);
    final endState = useState<DateTime?>(startState.value!.add(const Duration(hours: 1)));

    // TextField用のuseStateの定義
    final titleControllerState = useTextEditingController();
    final commentControllerState = useTextEditingController();

    // titleとcommentの状態変化を取得
    final isTitleCommentChangedState = useState<bool>(false);
    void handleTitleCommentChange() {
      isTitleCommentChangedState.value = titleControllerState.text.isNotEmpty && commentControllerState.text.isNotEmpty;
    }
    titleControllerState.addListener(handleTitleCommentChange);
    commentControllerState.addListener(handleTitleCommentChange);

    // 全てのデータの状態変化を取得
    final isChangedState = useState<bool>(false);
    void handleInputChange() {
      isChangedState.value = true;
    }

    return GestureDetector(
      onTap: () {
        // 現在のフォーカススコープを取得
        FocusScopeNode currentFocus = FocusScope.of(context);
        // 現在のフォーカススコープが主要なフォーカスを持っていない場合は真
        // 現在のフォーカススコープ内にフォーカスを受け取っている子ウィジェットが存在する場合に真
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          // 現在のフォーカススコープ内の主要なフォーカスが解除
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('予定の追加')),
          leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (isChangedState.value) {
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
                    // Set<MaterialState>型の引数を受け取り、ボタンの状態のセットを表現
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (isTitleCommentChangedState.value) {
                      return Colors.white;
                    } else {
                      return Colors.white70;
                    }
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (isTitleCommentChangedState.value) {
                      return Colors.black;
                    } else {
                      return Colors.grey;
                    }
                  }),
                ),
                onPressed: isTitleCommentChangedState.value ? () async {
                  temp = temp.copyWith(
                    title: titleControllerState.text,
                    comment: commentControllerState.text,
                    startDate: startDateTime ?? startState.value,
                    endDate: endDateTime ?? endState.value,
                  );
                  planProvider.writeData(temp);
                  Navigator.pop(context);
                } : null,
                child: const Text(saveText),
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
                  controller: titleControllerState,
                  style: const TextStyle(color: Colors.black),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: titleHintText,
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
                    titleState.value = value;
                    // temp = temp.copyWith(title: value);
                    handleInputChange();
                  },
                  onSubmitted: (value) {
                    titleState.value = value;
                    // temp = temp.copyWith(title: value);
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
                              const Text(allDayText),
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
                              const Text(startText),
                              // タップを検出するためのウィジェット
                              GestureDetector(
                                onTap: () async {
                                  final DateTime? selectedDate = await showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => Container(
                                      height: MediaQuery.of(context).size.height / 3,
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
                                                  child: const Text(cancelText),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                ),
                                                CupertinoButton(
                                                  // selectDateがダイアログpopされる
                                                  child: const Text(completeText),
                                                  onPressed: ()  {
                                                    // temp = temp.copyWith(startDate: startState.value);
                                                    ref.read(startDateTimeProvider.notifier).updateDateTime(startState.value!);
                                                    ref.read(endDateTimeProvider.notifier).updateDateTime(startState.value!.add(const Duration(hours: 1)));
                                                    if (startDateTime != startState.value) {
                                                      handleInputChange();
                                                    }
                                                    endState.value = startState.value!.add(const Duration(hours: 1));
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height / 5,
                                            child: CupertinoDatePicker(
                                              // 初期値を設定
                                              initialDateTime: startDateTime ?? roundToNearestFifteen(DateTime(
                                                this.selectedDate.year,
                                                this.selectedDate.month,
                                                this.selectedDate.day,
                                                DateTime.now().hour,
                                                DateTime.now().minute,
                                              )),
                                              // DatePickerのモードを指定（場合分け）
                                              mode: ref.watch(switchProvider) ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                              minuteInterval: 15,
                                              use24hFormat: true,
                                              onDateTimeChanged: (dateTime) {
                                                startState.value = DateTime(
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
                              const Text(endText),
                              GestureDetector(
                                onTap: () async {
                                  final DateTime? selectedDate = await showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => Container(
                                      height: MediaQuery.of(context).size.height / 3,
                                      color: CupertinoColors.white,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CupertinoButton(
                                                  child: const Text(cancelText),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                ),
                                                CupertinoButton(
                                                  child: const Text(completeText),
                                                  onPressed: () {
                                                    // temp = temp.copyWith(endDate: endState.value);
                                                    if (endDateTime != endState.value) {
                                                      handleInputChange();
                                                    }
                                                    ref.read(endDateTimeProvider.notifier).updateDateTime(endState.value!);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height / 5,
                                            child: CupertinoDatePicker(
                                              initialDateTime: endDateTime ?? roundToNearestFifteen(DateTime(
                                                this.selectedDate.year,
                                                this.selectedDate.month,
                                                this.selectedDate.day,
                                                DateTime.now().hour + 1,
                                                DateTime.now().minute,
                                              )),
                                              // DatePickerのモードを指定（場合分け）
                                              mode: ref.watch(switchProvider) ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                              minuteInterval: 15,
                                              use24hFormat: true,
                                              minimumDate: startDateTime?.add(const Duration(hours: 1)) ?? roundToNearestFifteen(DateTime(
                                            this.selectedDate.year,
                                              this.selectedDate.month,
                                              this.selectedDate.day,
                                              DateTime.now().hour + 1,
                                              DateTime.now().minute,
                                            )),
                                              onDateTimeChanged: (dateTime) {
                                                endState.value = DateTime(
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
                                      DateTime.now().hour +1,
                                      DateTime.now().minute,
                                    ));
                                    final endDateTime = ref.watch(endDateTimeProvider);
                                    return Text(
                                      DateFormat(format).format(endDateTime ?? initialEndDateTime),
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
                    controller: commentControllerState,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: commentHintText,
                      contentPadding: EdgeInsets.only(left: 10, top: 20),
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
                      commentState.value = value;
                      // temp = temp.copyWith(comment: value);
                      handleInputChange();
                    },
                    onSubmitted: (value) {
                      commentState.value = value;
                      // temp = temp.copyWith(comment: value);
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