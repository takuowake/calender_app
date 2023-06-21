import 'package:calender_app/common/string.dart';
import 'package:calender_app/common/text_style.dart';
import 'package:calender_app/repository/providers/plan_database_norifier.dart';
import 'package:calender_app/repository/providers/plan_provider.dart';
import 'package:calender_app/service/db/plan_db.dart';
import 'package:calender_app/view/add_plan_screen/add_plan_screen.dart';
import 'package:calender_app/view/edit_plan_screen/edit_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class PlanList extends ConsumerWidget {

  const PlanList({super.key});

  // _buildPlanListの引数は、planItemListとdb
  List<Widget> _buildPlanList(List<PlanItemData> planItemList, DateTime date, BuildContext context) {
    List<Widget> list = [];
    // planItemListの各要素について、for...inループを使用して処理を行う
    for (PlanItemData item in planItemList) {
      // ここで日付が一致するアイテムだけをチェック
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      if ((item.startDate?.isBefore(endOfDay) ?? false) &&
          (item.endDate?.isAfter(startOfDay) ?? false)) {
        String startTime = '${item.startDate?.hour.toString().padLeft(2, '0')}:${item.startDate?.minute.toString().padLeft(2, '0')}';
        String endTime = '${item.endDate?.hour.toString().padLeft(2, '0')}:${item.endDate?.minute.toString().padLeft(2, '0')}';

        Widget tile = Column(
          children: [
            const Divider(
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
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              leading: SizedBox(
                width: 45,
                child: Row(
                  children: [
                    SizedBox(
                      width:29,
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
                            const Text(
                              allDayText,
                              style: timeTextStyle,
                            ),
                        ],
                      ),
                    ),
                    const VerticalDivider(
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
    DateTime selectedDate = DateTime.now();
    var date = selectedDate;

    return buildCustomDialog(context, date, ref);
  }

  Widget buildCustomDialog(BuildContext context, DateTime date, WidgetRef ref) {
    // Providerの状態変化を監視し、変化があるたびにビルダー関数を実行
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, _) {
        // planDatabaseProviderからplanProviderを取得
        final planProvider = ref.watch(planDatabaseNotifierProvider);

        // planProviderの状態からplanItemsを取得
        List<PlanItemData> planItems = planProvider.planItems;

        if (planItems == null) {
          // データがまだロードされていない場合
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Widget> tiles = _buildPlanList(planItems, date, context);

        String formattedDate = getFormattedDate(date);
        String formattedWeekDay = getFormattedWeekDay(date);
        TextStyle weekdayTextStyle = getWeekdayTextStyle(date.weekday);

        return GestureDetector(
          onTap: () {},
          child: Padding(
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
                          Row(
                            children: [
                              Text(formattedDate),
                              const Text(' ('),
                              Text(formattedWeekDay, style: weekdayTextStyle),
                              const Text(')'),
                            ],
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
                            icon: const Icon(Icons.add, color: Colors.blue),
                          )
                        ],
                      ),
                      ...tiles.isEmpty
                          ? [
                        const Center(
                            child: Column(
                              children: [
                                Divider(
                                  thickness: 1,
                                ),
                                SizedBox(height: 200),
                                Text(noPlanText),
                              ],
                            ))
                      ]
                          : [Column(children: tiles)]
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
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
        return GestureDetector(
          onTap: () {
            Navigator.pop(context); // Close the dialog when tapped outside
          },
          child: Material(
            // 透明の背景
            type: MaterialType.transparency,
            // タップイベントを検知してダイアログを閉じる
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