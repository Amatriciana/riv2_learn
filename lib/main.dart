import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:riv2_learn/bmi_history.dart';

import 'package:riv2_learn/controller.dart';
import 'package:sqflite/sqflite.dart';
import 'counter.dart';
import 'bmi_calculator.dart';
import 'bmi_history.dart';

final databaseProvider = Provider<Future<Database>>(
  (ref) => throw UnimplementedError(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late final Future<Database> database;
  await Future.wait(
    [
      Future(() async {
        //TODO この処理間違ってる気がする
        database = openDatabase(
          join(await getDatabasesPath(), 'bmi_database.db'),
          onCreate: (db, version) {
            return db.execute(
                "CREATE TABLE bmi_history(id INTEGER PRIMARY KEY AUTOINCREMENT, result REAL, height REAL, weight REAL)");
          },
          version: 1,
        );
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
