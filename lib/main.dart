import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'counter.dart';
import 'bmi_calculator.dart';
import 'bmi_history.dart';
import 'controller.dart';
import 'database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late final Future<Database> database;

  await Future.wait(
    [
      Future(() async {
        database = DbController().dbCreate();
      })
    ],
  );

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: Consumer(
        builder: (context, ref, child) {
          return child!;
        },
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNav = ref.watch(bottomNavProvider);
    final bottomNavState = ref.watch(bottomNavProvider.notifier);

    final List _pageList;
    _pageList = [
      const CounterApp(),
      const BmiCalculator(),
      const BmiHistory(),
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('title'),
        ),
        body: _pageList[bottomNav.index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: bottomNav.index,
          onTap: (int selectPage) {
            bottomNavState.state = BottomNav.values[selectPage];
          },
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'カウンター'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'BMI計算機'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'BMI履歴'),
          ],
        ),
      ),
    );
  }
}
