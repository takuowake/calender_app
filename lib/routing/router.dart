import 'package:calender_app/view/add_plan_screen.dart';
import 'package:calender_app/view/calendar_screen.dart';
import 'package:calender_app/view/edit_plan_screen.dart';
import 'package:calender_app/view/plan_list.dart';
import 'package:flutter/material.dart';

import '../model/db/plan_db.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const CalendarScreen()); // カレンダー画面へのルーティング
      case '/plan-list':
        return MaterialPageRoute(builder: (_) => const PlanList()); // 予定一覧画面へのルーティング
      case '/add-plan':
        var selectedDate = settings.arguments as DateTime;
        return MaterialPageRoute(builder: (_) => AddPlanScreen(selectedDate: selectedDate)); // 予定追加画面へのルーティング
      case '/edit-plan':
        var item = settings.arguments as PlanItemData;
        return MaterialPageRoute(builder: (_) => EditPlanScreen(item: item)); // 予定編集画面へのルーティング
      default:
        return MaterialPageRoute(builder: (_) => const CalendarScreen()); // 存在しないルートへのアクセス時のエラーハンドリング
    }
  }
}