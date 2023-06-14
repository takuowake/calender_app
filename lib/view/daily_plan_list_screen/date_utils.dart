String getFormattedDayOfWeek(DateTime date) {
  String weekday = '';

  // 曜日の取得
  switch (date.weekday) {
    case 1:
      weekday = '月';
      break;
    case 2:
      weekday = '火';
      break;
    case 3:
      weekday = '水';
      break;
    case 4:
      weekday = '木';
      break;
    case 5:
      weekday = '金';
      break;
    case 6:
      weekday = '土';
      break;
    case 7:
      weekday = '日';
      break;
  }

  return '($weekday)';
}

String getFormattedMonthAndDate(DateTime date) {
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');
  return '$month月$day日';
}