/// 共通
const String allDayText = '終日';

/// カレンダー画面
const String todayText = '今日';

/// 追加・編集画面
const String titleHintText = 'タイトルを入力してください';
const String commentHintText = 'コメントを入力してください';
const String startText = '開始';
const String endText = '終了';
const String saveText = '保存';
const String editCancelText = '編集を破棄';
const String cancelText = 'キャンセル';
const String completeText = '完了';

/// 編集画面
const String deleteText = '削除';
const String deleteThisPlanText = 'この予定の削除';
const String confirmDeleteText = '本当にこの日の予定を削除しますか？';
const String deletePlanText = '予定の削除';

/// 日別予定一覧
const String noPlanText = '予定がありません。';

String getFormattedWeekDay(DateTime date) {
  String weekday = '';

  switch (date.weekday) {
    case DateTime.monday:
      weekday = '月';
      break;
    case DateTime.tuesday:
      weekday = '火';
      break;
    case DateTime.wednesday:
      weekday = '水';
      break;
    case DateTime.thursday:
      weekday = '木';
      break;
    case DateTime.friday:
      weekday = '金';
      break;
    case DateTime.saturday:
      weekday = '土';
      break;
    case DateTime.sunday:
      weekday = '日';
      break;
  }

  return weekday;
}

String getFormattedDate(DateTime date) {
  String year = date.year.toString();
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');

  return '$year/$month/$day';
}