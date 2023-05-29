import 'package:calender_app/routing/router.dart' as Router;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'カレンダー',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: Router.Router.generateRoute,
      locale: Locale('ja', 'JP'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja', 'JP'),
      ],
    );
  }
}




// final currentDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
// class DateRangeNotifier extends StateNotifier<List<DateTime>> {
//   DateRangeNotifier() : super([
//     DateTime.now().subtract(Duration(days: 1)),
//     DateTime.now(),
//     DateTime.now().add(Duration(days: 1)),
//   ]);
//
//   void setDate(DateTime date) {
//     state = [
//       date.subtract(Duration(days: 1)),
//       date,
//       date.add(Duration(days: 1)),
//     ];
//   }
// }
// final dialogProvider = StateProvider<int>((ref) => 0);
//

//
// final dateRangeProvider = StateNotifierProvider<DateRangeNotifier, List<DateTime>>((ref) => DateRangeNotifier());
//

//
