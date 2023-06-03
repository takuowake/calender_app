import 'package:calender_app/view/view_model/plan_provider.dart';
import 'package:drift/drift.dart' as Drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';


import '../model/db/plan_db.dart';
import '../model/freezed/plan_model.dart';

DateTime roundToNearestFifteen(DateTime dateTime) {
  final int minute = dateTime.minute;
  final int remainder = minute % 15;
  if (remainder >= 8) {
    return dateTime.add(Duration(minutes: 15 - remainder));
  } else {
    return dateTime.subtract(Duration(minutes: remainder));
  }
}


class AddPlanScreen extends HookConsumerWidget {

  //Providerが保持しているplanItemsを取得します。
  TempPlanItemData temp = TempPlanItemData();


  DateTime startDateTime = roundToNearestFifteen(DateTime.now());
  DateTime endDateTime = roundToNearestFifteen(DateTime.now()).add(Duration(hours: 1));
  DateTime? selectedDate;

  final switchProvider = StateNotifierProvider<SwitchProvider, bool>((ref) {
    return SwitchProvider();
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final temp = useState<TempPlanItemData>(TempPlanItemData());
    final temp = ref.watch(tempPlanItemProvider);
    //Providerの状態が変化したさいに再ビルドします
    final planProvider = ref.watch(planDatabaseNotifierProvider.notifier);
    //Providerのメソッドや値を取得します
    //bottomsheetが閉じた際に再ビルドするために使用します。
    // List<PlanItemData> planItems = planProvider.state.planItems;

    final start = useState<DateTime?>(null);
    final end = useState<DateTime?>(null);


    return Scaffold(
      appBar: AppBar(
        title: const Text('予定の追加'),
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {},
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0, bottom: 5),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (temp.title.isNotEmpty && temp.comment.isNotEmpty) {
                    return Colors.white; // 保存ボタンの背景色を変更
                  } else {
                    return Colors.white70;
                  }
                }),
                // foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  if (temp.title.isNotEmpty && temp.comment.isNotEmpty) {
                    return Colors.black;
                  } else {
                    return Colors.white70;
                  }
                }),
              ),
              onPressed: (temp.title.isNotEmpty && temp.comment.isNotEmpty) ? () {
                planProvider.writeData(temp);
                Navigator.pop(context);
              } : null,
              child: Text('保存'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              style: TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                hintText: 'タイトルを入力してください',
                contentPadding: const EdgeInsets.only(left: 10),
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                  ),
                ),
              ),
              onEditingComplete: () {

              },
              onChanged: (value) {
                ref.read(tempProvider.notifier).setTitle(value);
                temp.state = temp.copyWith(title: value);
              },
              onSubmitted: (value) {
                ref.read(tempProvider.notifier).setTitle(value);
                temp.state = temp.copyWith(title: value);
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
                  Container(
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
                              temp = temp.copyWith(isAllDay: value);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('開始'),
                          // タップを検出するためのウィジェット
                          GestureDetector(
                            // タップが検出されると指定されたコールバック関数が実行
                            onTap: () async {
                              // モーダルダイアログを表示。戻り値は選択された日付と時刻を表すselectedDate
                              final DateTime? selectedDate = await showCupertinoModalPopup(
                                context: context,
                                // Containerとその中に配置されたColumnでダイアログのコンテンツを構築
                                builder: (_) => Container(
                                  height: MediaQuery.of(context).size.height / 3,
                                  color: CupertinoColors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CupertinoButton(
                                              // ダイアログが閉じられる
                                              child: Text('キャンセル'),
                                              onPressed: () => Navigator.of(context).pop(),
                                            ),
                                            CupertinoButton(
                                              // selectDateがダイアログpopされる
                                              child: Text('完了'),
                                              onPressed: () => {
                                                planProvider.writeData(temp),
                                                Navigator.of(context).pop(),
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 220,
                                        child: CupertinoDatePicker(
                                          // 初期値を設定
                                          initialDateTime: startDateTime,
                                          // DatePickerのモードを指定（場合分け）
                                          mode: ref.watch(switchProvider) ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                          minuteInterval: 15,
                                          onDateTimeChanged: (dateTime) {
                                            start.value = DateTime(
                                              dateTime.year,
                                              dateTime.month,
                                              dateTime.day,
                                              dateTime.hour,
                                              dateTime.minute,
                                            );
                                            // temp変数のlimitプロパティが選択された日付と時間に更新される
                                            temp.state = temp.copyWith(startDate: start.value);
                                            startDateTime = start.value!;
                                            endDateTime = start.value!.add(Duration(hours: 1));
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
                                return Text(
                                  // DateFormat(format).format(selectedDate!),
                                  DateFormat(format).format(startDateTime),
                                  style: TextStyle(color: Colors.blue),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
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
                                  height: MediaQuery.of(context).size.height / 3,
                                  color: CupertinoColors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 60,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CupertinoButton(
                                              child: Text('キャンセル'),
                                              onPressed: () => Navigator.of(context).pop(),
                                            ),
                                            CupertinoButton(
                                              child: Text('完了'),
                                              onPressed: () => {
                                                planProvider.writeData(temp),
                                                Navigator.of(context).pop(),
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 220, // CupertinoDatePicker has an intrinsic height of 216.0
                                        child: CupertinoDatePicker(
                                          // 初期値を設定
                                          initialDateTime: endDateTime,
                                          // DatePickerのモードを指定（場合分け）
                                          mode: CupertinoDatePickerMode.dateAndTime,
                                          minuteInterval: 15,
                                          onDateTimeChanged: (dateTime) {
                                            end.value = DateTime(
                                              dateTime.year,
                                              dateTime.month,
                                              dateTime.day,
                                              dateTime.hour,
                                              dateTime.minute,
                                            );
                                            // temp変数のlimitプロパティが選択された日付と時間に更新される
                                            temp.state = temp.copyWith(endDate: end.value);
                                            endDateTime = end.value!;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              // if (selectedDate != null) {
                              //   setState(() => _endDateTime = selectedDate);
                              // }
                            },
                            child: Consumer(
                              builder: (context, watch, _) {
                                final switchState = ref.watch(switchProvider);
                                final format = switchState ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm';
                                return Text(
                                  DateFormat(format).format(endDateTime),
                                  style: TextStyle(color: Colors.blue),
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
            child: Container(
              height: 200,
              width: 400,
              child: TextField(
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'コメントを入力してください',
                  contentPadding: const EdgeInsets.only(left: 10, top: 20, ),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                onChanged: (value) {
                  temp.state = temp.copyWith(comment: value);
                },
                onSubmitted: (value) {
                  temp.state = temp.copyWith(comment: value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}