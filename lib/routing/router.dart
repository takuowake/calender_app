import 'package:calender_app/main.dart';
import 'package:calender_app/view/event_list_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const CalendarPage(),
      '/daily_schedule_list': (context) => const EventListScreen(),
      // '/bottom_navigation_bar_screen': (context) => const BottomNavigationBarScreen(),
      // '/drawer_screen': (context) => const DrawerScreen(),
      // '/dialog_screen': (context) => DialogScreen(),
    },
  ));
}