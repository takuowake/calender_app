import 'package:calender_app/view/plan_list.dart';
import 'package:calender_app/view/view_model/plan_provider.dart';
import 'package:drift/drift.dart' as Drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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


class EditPlanScreen extends HookConsumerWidget {

  PlanItemData item;

  EditPlanScreen({required this.item});

  // DateTime? startDateTime;
  // DateTime? endDateTime;
  // DateTime? selectedDate;

  final switchProvider = StateNotifierProvider<SwitchProvider, bool>((ref) {
    return SwitchProvider();
  });

  final titleFocusNode = FocusNode();


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final planState = ref.watch(planDatabaseNotifierProvider);
    final planProvider = ref.watch(planDatabaseNotifierProvider.notifier);
    // final PlanDatabaseNotifier db = ref.read(planDatabaseNotifierProvider.notifier);

    final isChanged = useState<bool>(false);
    void handleInputChange() {
      isChanged.value = true;
    }

    void showEditCanselConfirmation() {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                // 現在の画面（EditPlanScreen）をポップします。
                Navigator.of(context).pop();
                // CupertinoActionSheetをポップします。
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

    // final start = useState<DateTime?>(item.startDate);
    // final end = useState<DateTime?>(item.endDate);
    final start = useState<DateTime?>(item.startDate);
    final end = useState<DateTime?>(item.endDate);

    DateTime? startDateTime = item.startDate;
    DateTime? endDateTime = item.endDate;
    // DateTime? selectedDate;


    final title = useState(item.title);
    final comment = useState(item.comment);


    // useTextEditingControllerに初期値として、item.titleとitem.commentを設定
    final titleController = useTextEditingController(text: item.title);
    final commentController = useTextEditingController(text: item.comment);

    Future<void> showDeleteConfirmation() async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('予定の削除'),
            content: const Text('本当にこの日の予定を削除しますか？'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('キャンセル'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  // ここで予定を削除する処理を追加する
                  planProvider.deleteData(item);
                  Navigator.pushNamed(context, '/');
                  PlanList().ShowDialog(context, ref, startDateTime!);
                },
                child: const Text('削除', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
    }

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
          title: const Text('予定の編集'),
          leading: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (isChanged.value) {
                showEditCanselConfirmation();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 5),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (isChanged.value == true) {
                      return Colors.white; // 保存ボタンの背景色を変更
                    } else {
                      return Colors.white70;
                    }
                  }),
                  // foregroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (isChanged.value == true) {
                      return Colors.black;
                    } else {
                      return Colors.white70;
                    }
                  }),
                ),
                onPressed: (isChanged.value) ? () {
                  PlanItemData data = PlanItemData(
                    id: item.id,
                    title: item.title,
                    comment: item.comment,
                    isAll: item.isAll,
                    startDate: item.startDate,
                    endDate: item.endDate,
                  );
                  // await db.updateData(data);
                  ref.read(planDatabaseNotifierProvider.notifier).updateData(data);
                  Navigator.pushNamed(context, '/');
                  PlanList().ShowDialog(context, ref, startDateTime!);
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
                  controller: titleController,
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
                    item = item.copyWith(title: value);
                    handleInputChange();
                  },
                  onSubmitted: (value) {
                    title.value = value;
                    item = item.copyWith(title: value);
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
                                value: item.isAll,
                                activeColor: Colors.blue,
                                activeTrackColor: Colors.blueAccent,
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (value) {
                                  // スイッチの状態を更新するための処理を行う
                                  ref.read(switchProvider.notifier).updateSwitch(value);
                                  item = item.copyWith(isAll: value);
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
                                // タップが検出されると指定されたコールバック関数が実行
                                onTap: () async {
                                  // モーダルダイアログを表示。戻り値は選択された日付と時刻を表すselectedDate
                                  final DateTime? selectedDate = await showCupertinoModalPopup(
                                    context: context,
                                    // Containerとその中に配置されたColumnでダイアログのコンテンツを構築
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
                                                  onPressed: () => {
                                                    planProvider.updateData(item),
                                                    Navigator.of(context).pop(),
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 220,
                                            child: CupertinoDatePicker(
                                              // 初期値としてitemオブジェクトのstartDataプロパティの値
                                              initialDateTime: item.startDate,
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
                                                // item = item.copyWith(startDate: start.value);
                                                // copyWithメソッドを使用してitemオブジェクトのコピーを作成し、startDateプロパティを新しい値
                                                item = item.copyWith(startDate: Drift.Value(start.value));

                                                // item.startDate = start.value;
                                                startDateTime = start.value!;
                                                endDateTime = start.value!.add(const Duration(hours: 1));
                                                handleInputChange();
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
                                      DateFormat(format).format(startDateTime!),
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
                                                  onPressed: () => {
                                                    planProvider.updateData(item),
                                                    Navigator.of(context).pop(),
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 220, // CupertinoDatePicker has an intrinsic height of 216.0
                                            child: CupertinoDatePicker(
                                              // 初期値を設定
                                              initialDateTime: endDateTime,
                                              // DatePickerのモードを指定（場合分け）
                                              mode: ref.watch(switchProvider) ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                              minuteInterval: 15,
                                              minimumDate: startDateTime,
                                              onDateTimeChanged: (dateTime) {
                                                end.value = DateTime(
                                                  dateTime.year,
                                                  dateTime.month,
                                                  dateTime.day,
                                                  dateTime.hour,
                                                  dateTime.minute,
                                                );
                                                // item = item.copyWith(endDate: end.value);
                                                // item.endDate = end.value;
                                                item = item.copyWith(endDate: Drift.Value(end.value));
                                                endDateTime = end.value!;
                                                handleInputChange();
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
                                      DateFormat(format).format(endDateTime!),
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
                    controller: commentController,
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
                      item = item.copyWith(comment: value);
                      handleInputChange();
                    },
                    onSubmitted: (value) {
                      comment.value = value;
                      item = item.copyWith(comment: value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: showDeleteConfirmation,
                  child: const SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Center(child: Text('この予定を削除', style: TextStyle(color: Colors.red))),

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