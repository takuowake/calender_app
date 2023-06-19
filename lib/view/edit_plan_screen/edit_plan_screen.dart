import 'package:calender_app/common/string.dart';
import 'package:calender_app/repository/providers/plan_database_norifier.dart';
import 'package:calender_app/repository/providers/plan_provider.dart';
import 'package:calender_app/service/db/plan_db.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';


class EditPlanScreen extends HookConsumerWidget {
  // EditPlanScreenのインスタンス化時に引数として渡される
  PlanItemData item;

  // EditPlanScreenクラスのコンストラクタを定義
  EditPlanScreen({Key? key, required this.item}) : super(key: key);

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
                // CupertinoActionSheetをポップします。
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

    final planProvider = ref.read(planDatabaseNotifierProvider.notifier);

    final isChanged = useState<bool>(false);
    void handleInputChange() {
      isChanged.value = true;
    }

    final start = useState<DateTime?>(item.startDate);
    final end = useState<DateTime?>(item.endDate);

    DateTime? startDateTime = item.startDate;
    DateTime? endDateTime = item.endDate;


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
            title: const Text(deletePlanText),
            content: const Text(confirmDeleteText),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text(cancelText),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  // ここで予定を削除する処理を追加する
                  planProvider.deleteData(item);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(deleteText, style: TextStyle(color: Colors.blue)),
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
          title: const Center(child: Text('予定の編集')),
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
                    if (isChanged.value == true) {
                      return Colors.white;
                    } else {
                      return Colors.white70;
                    }
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (isChanged.value == true) {
                      return Colors.black;
                    } else {
                      return Colors.grey;
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
                  ref.read(planDatabaseNotifierProvider.notifier).updateData(data);
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
                  controller: titleController,
                  style: const TextStyle(color: Colors.grey),
                  autofocus: true,
                  focusNode: titleFocusNode,
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
                              const Text(allDayText),
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
                              const Text(startText),
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
                                                  child: const Text(cancelText),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                ),
                                                CupertinoButton(
                                                  child: const Text(completeText),
                                                  onPressed: ()  {
                                                    item = item.copyWith(startDate: drift.Value(start.value));
                                                    item = item.copyWith(endDate: drift.Value(start.value!.add(const Duration(hours:1))));
                                                    ref.read(startDateTimeProvider.notifier).updateDateTime(start.value!);
                                                    ref.read(endDateTimeProvider.notifier).updateDateTime(start.value!.add(const Duration(hours: 1)));
                                                    if (startDateTime != start.value) {
                                                      handleInputChange();
                                                    }
                                                    startDateTime = start.value!;
                                                    Navigator.of(context).pop();
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
                                              mode: item.isAll ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
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
                                    final switchState = item.isAll;
                                    final format = switchState ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm';
                                    final startDateTime = ref.watch(startDateTimeProvider);
                                    final initialStartDateTime = item.startDate;
                                    return Text(
                                      DateFormat(format).format(initialStartDateTime ?? startDateTime!),
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
                                                  child: const Text(cancelText),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                ),
                                                CupertinoButton(
                                                  child: const Text(completeText),
                                                  onPressed: () {
                                                    item = item.copyWith(endDate: drift.Value(end.value));
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
                                              mode: item.isAll ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                              minuteInterval: 15,
                                              use24hFormat: true,
                                              minimumDate: startDateTime?.add(const Duration(hours: 1)),
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
                                    final switchState = item.isAll;
                                    final format = switchState ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm';
                                    final endDateTime = ref.watch(endDateTimeProvider);
                                    final initialEndDateTime = item.endDate;
                                    return Text(
                                      DateFormat(format).format(initialEndDateTime ?? endDateTime!),
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
                      hintText: commentHintText,
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
                    child: Center(child: Text(deleteThisPlanText, style: TextStyle(color: Colors.red))),
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