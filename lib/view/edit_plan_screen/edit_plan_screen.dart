import 'package:calender_app/common/string.dart';
import 'package:calender_app/repository/providers/plan_database_norifier.dart';
import 'package:calender_app/service/db/plan_db.dart';
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

    // providerの監視
    final planProvider = ref.read(planDatabaseNotifierProvider.notifier);

    // 開始時間・終了時間の定義
    DateTime? startDateTime;
    DateTime? endDateTime;

    // useStateの定義
    final titleState = useState<String>(item.title);
    final commentState = useState<String>(item.comment);
    final isAllState = useState<bool>(item.isAll);
    final startState = useState<DateTime?>(item.startDate);
    final endState = useState<DateTime?>(item.endDate);

    // TextField用のuseStateの定義
    // useTextEditingControllerに初期値として、item.titleとitem.commentを設定
    final titleControllerState = useTextEditingController(text: item.title);
    final commentControllerState = useTextEditingController(text: item.comment);

    // titleとcommentの状態変化を取得
    final isTitleCommentChangedState = useState<bool>(false);
    void handleTitleCommentChange() {
      isTitleCommentChangedState.value = titleControllerState.text.isNotEmpty && commentControllerState.text.isNotEmpty;
    }
    titleControllerState.addListener(handleTitleCommentChange);
    commentControllerState.addListener(handleTitleCommentChange);

    // 全てのデータの状態変化を取得
    final isChanged = useState<bool>(false);
    void handleInputChange() {
      isChanged.value = true;
    }

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
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
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
                    if (isChanged.value && isTitleCommentChangedState.value == true) {
                      return Colors.white;
                    } else {
                      return const Color(0xFFE4E4E4);
                    }
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                    if (isChanged.value && isTitleCommentChangedState.value == true) {
                      return Colors.black;
                    } else {
                      return const Color(0xFFCCCCCC);
                    }
                  }),
                ),
                onPressed: (isChanged.value && isTitleCommentChangedState.value) ? () {
                  PlanItemData data = PlanItemData(
                    id: item.id,
                    title: titleState.value,
                    comment: commentState.value,
                    isAll: isAllState.value,
                    startDate: startState.value,
                    endDate: endState.value,
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
                    handleInputChange();
                  },
                  onSubmitted: (value) {
                    titleState.value = value;
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
                                value: isAllState.value,
                                activeColor: Colors.blue,
                                activeTrackColor: Colors.blueAccent,
                                inactiveThumbColor: Colors.white,
                                inactiveTrackColor: Colors.grey,
                                onChanged: (value) {
                                  isAllState.value = value;
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
                                                  onPressed: ()  {
                                                    startDateTime ??= startState.value;
                                                    startState.value = startDateTime;
                                                    if (item.startDate != startState.value) {
                                                      handleInputChange();
                                                    }
                                                    if (startState.value!.isAfter(endState.value!.subtract(const Duration(hours: 1)))) {
                                                      endState.value = startState.value!.add(const Duration(hours: 1));
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height / 5,
                                            child: CupertinoDatePicker(
                                              // 初期値としてitemオブジェクトのstartDataプロパティの値
                                              initialDateTime: startState.value,
                                              // DatePickerのモードを指定（場合分け）
                                              mode: isAllState.value ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                              minuteInterval: 15,
                                              use24hFormat: true,
                                              onDateTimeChanged: (dateTime) {
                                                startDateTime = DateTime(
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
                                    final format = isAllState.value ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm';
                                    final startDateTime = startState.value;
                                    return Text(
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
                                                    endDateTime ??= endState.value;
                                                    endState.value = endDateTime;
                                                    if (item.endDate != endState.value) {
                                                      handleInputChange();
                                                    }
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
                                              initialDateTime: endState.value,
                                              // DatePickerのモードを指定（場合分け）
                                              mode: isAllState.value ? CupertinoDatePickerMode.date : CupertinoDatePickerMode.dateAndTime,
                                              minuteInterval: 15,
                                              use24hFormat: true,
                                              minimumDate: startState.value!.add(const Duration(hours: 1)),
                                              onDateTimeChanged: (dateTime) {
                                                endDateTime = DateTime(
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
                                    final format = isAllState.value ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm';
                                    final endDateTime = endState.value;
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
                    controller: commentControllerState,
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
                      commentState.value = value;
                      handleInputChange();
                    },
                    onSubmitted: (value) {
                      commentState.value = value;
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