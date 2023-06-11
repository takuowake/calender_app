import 'package:calender_app/view/add_plan_screen.dart';
import 'package:calender_app/view/edit_plan_screen.dart';
import 'package:calender_app/view/view_model/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/db/plan_db.dart';
import '../model/freezed/plan_model.dart';


// 新たに状態管理用のStateNotifierを定義
class DatePickerNotifier extends StateNotifier<DateTime> {
  DatePickerNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }
}


class PlanList extends ConsumerWidget {

  final TextStyle defaultTextStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  final TextStyle timeTextStyle = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  const PlanList({super.key});

  // _buildPlanListの引数は、planItemListとdb
  List<Widget> _buildPlanList(List<PlanItemData> planItemList, PlanDatabaseNotifier db, DateTime date, BuildContext context) {
    List<Widget> list = [];
    // planItemListの各要素について、for...inループを使用して処理を行う
    for (PlanItemData item in planItemList) {
      // ここで日付が一致するアイテムだけをチェック
      if (item.startDate?.year == date.year &&
          item.startDate?.month == date.month &&
          item.startDate?.day == date.day) {
        String startTime = '${item.startDate?.hour.toString().padLeft(2, '0')}:${item.startDate?.minute.toString().padLeft(2, '0')}';
        String endTime = '${item.endDate?.hour.toString().padLeft(2, '0')}:${item.endDate?.minute.toString().padLeft(2, '0')}';

        Widget tile = Column(
          children: [
            Divider(
              thickness: 1,
            ),
            ListTile(
              title: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditPlanScreen(item: item)),
                  );
                },
                child: Text(
                  item.title,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                ),
              ),
              leading: SizedBox(
                width: 50,
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!item.isAll) // isAllがFalseの場合のみstartTimeとendTimeを表示
                            Column(
                              children: [
                                Text(
                                  startTime,
                                  style: timeTextStyle,
                                ),
                                Text(
                                  endTime,
                                  style: timeTextStyle,
                                ),
                              ],
                            ),
                          if (item.isAll) // isAllがTrueの場合は「終日」を表示
                            Text(
                              '終日',
                              style: timeTextStyle,
                            ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.blue,
                      thickness: 3,
                      // width: 15,
                      indent: 0,
                      endIndent: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
        list.add(tile);
        //listにtileを追加
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = DateTime.now(); // 仮に現在の日付を選択日付としています。
    var date = selectedDate;
    // ここで、適切な日付を選択するロジックを追加するべきです。

    return buildCustomDialog(context, date, ref);
  }

  Widget buildCustomDialog(BuildContext context, DateTime date, WidgetRef ref) {
    final planProvider = ref.watch(planDatabaseProvider);
    // return FutureBuilder(
    //   future: planProvider.readData(),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     // データがまだ読み込まれていない場合
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else {
    //       // データが読み込まれた場合
    //       List<PlanItemData> planItems = planProvider.state.planItems;
    //       List<Widget> tiles = _buildPlanList(planItems, planProvider, date, context);
    //
    //       String dialogDate = '${date.year}年 ${date.month}月 ${date.day}日';
    //
    //       return Padding(
    //         padding: const EdgeInsets.only(left: 8.0, top: 200.0, right: 8.0, bottom: 10.0),
    //         child: Container(
    //           width: 100,
    //           height: 300,
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(20.0),
    //             child: SingleChildScrollView(
    //               child: Column(
    //                 children: [
    //                   Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text(
    //                         dialogDate,
    //                         style: defaultTextStyle,
    //                       ),
    //                       IconButton(
    //                         onPressed: () {
    //                           Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                               builder: (context) => AddPlanScreen(selectedDate: date),
    //                             ),
    //                           );
    //                         },
    //                         icon: Icon(Icons.add, color: Colors.blue),
    //                       )
    //                     ],
    //                   ),
    //                   if (tiles.isEmpty) {
    //                     Center(child: Text("予定がありません")),
    //                   } else {
    //                     Column(
    //                       children: tiles,
    //                     ),
    //                   }
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     }
    //   },
    //   // ここに非同期のデータ読み込み処理を指定します。
    //   // builder: (BuildContext context, AsyncSnapshot snapshot) {
    //   //   // データがまだ読み込まれていない場合
    //   //   if (snapshot.connectionState == ConnectionState.waiting) {
    //   //     return Center(
    //   //       child: CircularProgressIndicator(), // ローディングインジケータを表示します。
    //   //     );
    //   //   } else {
    //   //     if (snapshot.hasData) {
    //   //       // データが読み込まれた場合、_buildPlanListメソッドを呼び出す
    //   //       List<PlanItemData> planItems = snapshot.data;
    //   //       List<Widget> tiles = _buildPlanList(planItems, planProvider, date, context);
    //   //       // データが読み込まれた場合
    //   //       // List<PlanItemData> planItems = planProvider.state.planItems;
    //   //       // List<Widget> tiles = _buildPlanList(planItems, planProvider, date, context);
    //   //       String dialogDate = '${date.year}年 ${date.month}月 ${date.day}日';
    //   //       return Padding(
    //   //         padding: const EdgeInsets.only(left: 8.0, top: 200.0, right: 8.0, bottom: 10.0),
    //   //         child: Container(
    //   //           width: 100,
    //   //           height: 300,
    //   //           decoration: BoxDecoration(
    //   //             color: Colors.white,
    //   //             borderRadius: BorderRadius.circular(20),
    //   //           ),
    //   //           child: Padding(
    //   //             padding: const EdgeInsets.all(20.0),
    //   //             child: SingleChildScrollView(
    //   //               child: Column(
    //   //                 children: [
    //   //                   Row(
    //   //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   //                     children: [
    //   //                       Text(
    //   //                         dialogDate,
    //   //                         style: defaultTextStyle,
    //   //                       ),
    //   //                       IconButton(
    //   //                         onPressed: () {
    //   //                           Navigator.push(
    //   //                             context,
    //   //                             MaterialPageRoute(
    //   //                               builder: (context) => AddPlanScreen(selectedDate: date),
    //   //                             ),
    //   //                           );
    //   //                         },
    //   //                         icon: Icon(Icons.add, color: Colors.blue),
    //   //                       )
    //   //                     ],
    //   //                   ),
    //   //                   Column(
    //   //                     children: tiles,
    //   //                   ),
    //   //                 ],
    //   //               ),
    //   //             ),
    //   //           ),
    //   //         ),
    //   //       );
    //   //     } else {
    //   //       return Center(
    //   //         child: Text('予定がありません'),
    //   //       );
    //   //     }
    //   //   }
    //   // },
    //   // buildCustomDialogメソッド内のbuilderコールバック内を修正
    // );
    return FutureBuilder(
      future: planProvider.readData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // データがまだ読み込まれていない場合
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // データが読み込まれた場合
          List<PlanItemData> planItems = planProvider.state.planItems;
          List<Widget> tiles = _buildPlanList(planItems, planProvider, date, context);

          String dialogDate = '${date.year}年 ${date.month}月 ${date.day}日';

          return Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 200.0, right: 8.0, bottom: 10.0),
            child: Container(
              width: 100,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            dialogDate,
                            style: defaultTextStyle,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPlanScreen(selectedDate: date),
                                ),
                              );
                            },
                            icon: Icon(Icons.add, color: Colors.blue),
                          )
                        ],
                      ),
                      // Using spread operator and ternary conditional
                      ...tiles.isEmpty
                          ? [
                              Center(child: Column(
                                children: [
                                  Divider(
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 200),
                                  Text("予定がありません。"),
                                ],
                              ))
                            ]
                          : [Column(children: tiles)]
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void ShowDialog(BuildContext context, WidgetRef ref, DateTime selectedDate) {
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