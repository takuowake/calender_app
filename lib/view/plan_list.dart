import 'package:calender_app/view/add_plan_screen.dart';
import 'package:calender_app/view/edit_plan_screen.dart';
import 'package:calender_app/view/view_model/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/db/plan_db.dart';
import '../model/freezed/plan_model.dart';


final planListProvider = StateProvider<int>((ref) => 0);

// 新たに状態管理用のStateNotifierを定義
class DatePickerNotifier extends StateNotifier<DateTime> {
  DatePickerNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }
}

// DatePickerNotifier用のProviderを定義
final datePickerProvider = StateNotifierProvider<DatePickerNotifier, DateTime>((ref) => DatePickerNotifier());

final planDatabaseProvider = Provider<PlanDatabaseNotifier>((ref) {
  return PlanDatabaseNotifier();
});

class PlanList extends ConsumerWidget {

  final TextStyle defaultTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  PlanList({super.key});

  List<Widget> _buildPlanList(
      // _buildPlanListの引数は、planItemListとdb
      List<PlanItemData> planItemList, PlanDatabaseNotifier db) {
    //追加
    List<Widget> list = [];
    // planItemListの各要素について、for...inループを使用して処理を行う
    for (PlanItemData item in planItemList) {
      Widget tile = ListTile(
        title: Text(item.title),
        // null出ない場合はその値を表示し、nullの場合はから文字列を表示する
        subtitle: Text(item.startDate == null ? "" : item.startDate.toString()),
        // 右端に表示。leading: は左端。
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                db.deleteData(item);
              },
              icon: Icon(Icons.delete),
            ),
            // IconButton(
            //   onPressed: () {
            //     TodoItemData data = TodoItemData(
            //       id: item.id,
            //       title: item.title,
            //       description: item.description,
            //       limitDate: item.limitDate,
            //       isNotify: !item.isNotify,
            //     );
            //     db.updateData(data);
            //   },
            //   icon: Icon(
            //     item.isNotify ? Icons.notifications_off : Icons.notifications_active,
            //   ),
            // ),
          ],
        ),
      );
      list.add(tile);
      //listにtileを追加
    }
    return list;
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = DateTime.now(); // 仮に現在の日付を選択日付としています。
    var date = selectedDate;
    // ここで、適切な日付を選択するロジックを追加するべきです。

    // return _buildCustomDialogForDate(context, selectedDate, ref, selectedDate);
    return buildCustomDialog(context, date, ref);
  }

  Widget buildCustomDialog(BuildContext context, DateTime date, WidgetRef ref) {
    // planDatabaseProviderの状態を監視し、stateに取得
    final state = ref.watch(planDatabaseProvider);

    // final planItems = state.planItems;
    //Providerの状態が変化したさいに再ビルドします
    final planProvider = ref.watch(planDatabaseProvider);
    //Providerのメソッドや値を取得します
    //bottomsheetが閉じた際に再ビルドするために使用します。
    List<PlanItemData> planItems = planProvider.state.planItems;
    List<Widget> tiles = _buildPlanList(planItems, planProvider);

    // ダイアログの日付を定義
    String dialogDate = '${date.year}年 ${date.month}月 ${date.day}日';

    // selectedDate(選ばれた日付)とplanItemsの中のデータが一致したら、matchedPlanItemsにデータを格納する
    // for (var planItem in planItems) {
    //   if (planItem.startDate.day == date.day &&
    //       planItem.startDate.month == date.month &&
    //       planItem.startDate.year == date.year) {
    //     dialogDatePlanItems.add(planItem as TempPlanItemData);
    //   }
    // }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 200.0, right: 8.0, bottom: 10.0),
      // ダイアログの外枠のUI
      child: Container(
        width: 100,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          // ダイアログの中身のUI
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ダイアログのタイトル（日付）
                    Text(
                      dialogDate,
                      style: defaultTextStyle,
                    ),
                    // 予定追加画面へのアイコン
                    IconButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditPlanScreen()),
                      );
                    }, icon: Icon(Icons.add, color: Colors.blue))
                  ],
                ),
                Divider(),
                // tilesのデータを表示
                ...tiles,

                // 予定一覧
                // Row(
                //   children: [
                //     Container(
                //       width: 40,
                //       child: Column(
                //         children: [
                //           Text(matchedPlanItems.start.toString()),
                //           Text(matchedPlanItems.end.toString()),
                //         ],
                //       ),
                //     ),
                //     Container(
                //       width: 4.0,
                //       height: 50.0,
                //       color: Colors.blue, // 縦棒の色
                //       margin: EdgeInsets.symmetric(horizontal: 10.0), // 縦棒の左右の余白
                //     ),
                //     TextButton(onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => EditPlanScreen()),
                //       );
                //     }, child: Text(matchedPlanItems.title.length > 14 ? matchedPlanItems.title.substring(0, 11) + '...' : 'title', style: defaultTextStyle)),
                //   ],
                // ),
                Divider(),
                // Row(
                //   children: [
                //     Container(
                //       width: 40,
                //       child: Text(
                //         '終日',
                //         style: defaultTextStyle,
                //       ),
                //     ),
                //     Container(
                //       width: 4.0,
                //       height: 50.0,
                //       color: Colors.blue, // 縦棒の色
                //       margin: EdgeInsets.symmetric(horizontal: 10.0),
                //     ),
                //     // Text(
                //     //   dialogDate.length > 14 ? dialogDate.substring(0, 11) + '...' : dialogDate,
                //     //   style: defaultTextStyle,
                //     // ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Widget _buildCustomDialogForDate(BuildContext context, DateTime date, WidgetRef ref, DateTime selectedDate, TempPlanItemData matchedPlanItems) {
  //   // String dialogDate = '${date.year}年 ${date.month}月 ${date.day}日';
  //   return buildCustomDialog(context, matchedPlanItems, ref);
  // }

  void ShowDialog(BuildContext context, WidgetRef ref, DateTime selectedDate) {
    // final planItems = ref.watch(planDatabaseProvider).state.planItems;
    //
    // List<TempPlanItemData> matchedPlanItems = [];
    // TempPlanItemData selectedPlanItem;

    // selectedDate(選ばれた日付)とplanItemsの中のデータが一致したら、matchedPlanItemsにデータを格納する
    // for (var planItem in planItems) {
    //   if (planItem.startDate.day == selectedDate.day &&
    //       planItem.startDate.month == selectedDate.month &&
    //       planItem.startDate.year == selectedDate.year) {
    //     matchedPlanItems.add(planItem as TempPlanItemData);
    //   }
    // }

    // もしmatchedPlanItemsがnullでなければ、buildCustomDialogをbuildする
    // if (matchedPlanItems.isNotEmpty) {
    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return buildCustomDialog(context, matchedPlanItems, ref);
    //     },
    //   );
    // }

    // PageViewの初期表示ページを設定
    final pageController = PageController(
      initialPage: 100,
      // 隣同士のダイアログの端をどれくらい画面に表示するかの割合
      viewportFraction: 0.8,
    );

    // 透明な背景のダイアログを表示し、その中にページビューを配置
    showDialog(
      context: context,
      // ダイアログの外側をタップすると、ダイアログが閉じる
      barrierDismissible: true,
      builder: (context) {
        return Material(
          // 透明の背景
          type: MaterialType.transparency,
          // タップイベントを検知してダイアログを閉じる
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.7,
              child: PageView.builder(
                // ページのスワイプを制御
                controller: pageController,
                // ページが変更された時に実行されるコールバック関数
                // valueには現在のページのインデックスが渡される
                onPageChanged: (value) {
                  // ページが変更されるたびに、現在のページのインデックスから新しい日付を計算し、それを日付ピッカーの状態に反映させることで、選択された日付を更新
                  DateTime newDate = selectedDate.add(Duration(days: value - 100));
                  ref.read(datePickerProvider.notifier).setDate(newDate);
                },
                // 各ページの内容を構築するための関数（indexには現在のページのインデックス）
                itemBuilder: (context, index) {
                  // ページのインデックスから日付を計算
                  DateTime date = selectedDate.add(Duration(days: index - 100));
                  // context, date, refを引数として、buildCustomDialogを構築
                  return buildCustomDialog(context, date, ref);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

