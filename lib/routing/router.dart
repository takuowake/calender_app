import 'package:calender_app/view/add_plan_screen.dart';
import 'package:calender_app/view/calendar_screen.dart';
import 'package:calender_app/view/edit_plan_screen.dart';
import 'package:calender_app/view/plan_list.dart';
import 'package:flutter/material.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => CalendarScreen()); // カレンダー画面へのルーティング
      case '/plan-list':
        return MaterialPageRoute(builder: (_) => PlanList()); // 予定一覧画面へのルーティング
      case '/add-plan':
        return MaterialPageRoute(builder: (_) => AddPlanScreen()); // 予定追加画面へのルーティング
      case '/edit-plan':
        return MaterialPageRoute(builder: (_) => EditPlanScreen()); // 予定編集画面へのルーティング
      default:
        return MaterialPageRoute(builder: (_) => CalendarScreen()); // 存在しないルートへのアクセス時のエラーハンドリング
    }
  }
}