/// 1ヶ月分のカレンダーデータを生成するクラス
class CalendarBuilder {
  /// [date]が表す日が所属する月のカレンダーを生成
  List<List<DateTime?>> build(DateTime date) {
    final calendar = <List<DateTime?>>[];

    final firstWeekday = _calcFirstWeekday(date);
    final lastDate = _calcLastDate(date);
    final previousLastDate = _calcPreviousMonthLastDate(date);

    final firstWeek = List.generate(7, (index) {
      final i = index + 1; // index は 0 はじまりのため、1 はじまりの曜日と合わせる
      final offset = i - firstWeekday; // その月の 1 日の曜日との差
      return i < firstWeekday
          ? DateTime(date.year, date.month - 1, previousLastDate - firstWeekday + i + 1)
          : DateTime(date.year, date.month, 1 + offset);
    });

    calendar.add(firstWeek);

    while (true) {
      final firstDateOfWeek = calendar.last.last!.day + 1; // 前の週の最終日の次の日がスタート
      int month = calendar.last.last!.month;
      int year = calendar.last.last!.year;
      int lastDateOfCurrentMonth = _calcLastDate(DateTime(year, month));

      if (firstDateOfWeek > lastDate) {
        month += 1;
        if (month > 12) {
          month = 1;
          year += 1;
        }
        lastDateOfCurrentMonth = _calcLastDate(DateTime(year, month));
      }
      // 1 週間分のデータを生成
      final week = List.generate(7, (index) {
        final day = firstDateOfWeek + index;
        return DateTime(year, month, day);
      });

      calendar.add(week); // 週のリストを月のリストに追加

      // 月の最終日を含む週が追加されたら終了
      if (week.any((dateTime) => dateTime.day == lastDateOfCurrentMonth && dateTime.month == month)) {
        break;
      }
    }
    return calendar;
  }

  /// [date] が所属する月の 1 日の曜日を計算します。
  /// 月曜日を 1 とし、日曜日は 7 です。
  int _calcFirstWeekday(DateTime date) {
    return DateTime(date.year, date.month, 1).weekday;
  }

  /// [date] が所属する月の最後の日を計算します。
  int _calcLastDate(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  /// [date] が所属する月の前月の最後の日を計算します。
  int _calcPreviousMonthLastDate(DateTime date) {
    return DateTime(date.year, date.month, 0).day;
  }
}
