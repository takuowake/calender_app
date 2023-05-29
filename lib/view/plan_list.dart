import 'package:calender_app/view/add_plan_screen.dart';
import 'package:calender_app/view/edit_plan_screen.dart';
import 'package:calender_app/view/view_model/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime selectedDate = DateTime.now(); // 仮に現在の日付を選択日付としています。
    // ここで、適切な日付を選択するロジックを追加するべきです。

    return _buildCustomDialogForDate(context, selectedDate, ref, selectedDate);
  }

  Widget buildCustomDialog(BuildContext context, TempPlanItemData matchedPlanItems, WidgetRef ref) {
    final state = ref.watch(planDatabaseProvider);
    final planItems = state.planItems;
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
                      matchedPlanItems.start.toString(),
                      style: defaultTextStyle,
                    ),
                    IconButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPlanScreen()),
                      );
                    }, icon: Icon(Icons.add, color: Colors.blue))
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Container(
                      width: 40,
                      child: Column(
                        children: [
                          Text(matchedPlanItems.start.toString()),
                          Text(matchedPlanItems.end.toString()),
                        ],
                      ),
                    ),
                    Container(
                      width: 4.0,
                      height: 50.0,
                      color: Colors.blue, // 縦棒の色
                      margin: EdgeInsets.symmetric(horizontal: 10.0), // 縦棒の左右の余白
                    ),
                    TextButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditPlanScreen()),
                      );
                    }, child: Text(matchedPlanItems.title.length > 14 ? matchedPlanItems.title.substring(0, 11) + '...' : 'title', style: defaultTextStyle)),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Container(
                      width: 40,
                      child: Text(
                        '終日',
                        style: defaultTextStyle,
                      ),
                    ),
                    Container(
                      width: 4.0,
                      height: 50.0,
                      color: Colors.blue, // 縦棒の色
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    // Text(
                    //   dialogDate.length > 14 ? dialogDate.substring(0, 11) + '...' : dialogDate,
                    //   style: defaultTextStyle,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildCustomDialogForDate(BuildContext context, DateTime date, WidgetRef ref, DateTime selectedDate, TempPlanItemData matchedPlanItems) {
    // String dialogDate = '${date.year}年 ${date.month}月 ${date.day}日';
    return buildCustomDialog(context, matchedPlanItems, ref);
  }

  void ShowDialog(BuildContext context, WidgetRef ref, DateTime selectedDate) {
    final planItems = ref.watch(planDatabaseProvider).state.planItems;

    List<TempPlanItemData> matchedPlanItems = [];
    // TempPlanItemData selectedPlanItem;

    for (var planItem in planItems) {
      if (planItem.startDate.day == selectedDate.day &&
          planItem.startDate.month == selectedDate.month &&
          planItem.startDate.year == selectedDate.year) {
        matchedPlanItems.add(planItem as TempPlanItemData);
      }
    }

    if (matchedPlanItems.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return buildCustomDialog(context, matchedPlanItems, ref);
        },
      );
    }
    final pageController = PageController(
      initialPage: 1000,  // 適当に大きな数で初期化
      viewportFraction: 0.8,
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width * 0.7,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  // 選択した日付を更新
                  DateTime newDate = selectedDate.add(Duration(days: value - 1000));  // 初期化した日付からの差分を計算
                  ref.read(datePickerProvider.notifier).setDate(newDate);
                },
                itemBuilder: (context, index) {
                  // ページのインデックスから日付を計算
                  DateTime date = selectedDate.add(Duration(days: index - 1000));  // 初期化した日付からの差分を計算
                  return _buildCustomDialogForDate(context, date, ref, selectedDate);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

