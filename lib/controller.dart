import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riv2_learn/database.dart';
import 'package:sqflite/sqflite.dart';

final databaseProvider = Provider<Future<Database>>(
  (ref) => throw UnimplementedError(),
);

final bottomNavProvider = StateProvider<BottomNav>((ref) => BottomNav.counter);

enum BottomNav {
  counter,
  bmiCalc,
  bmiHistory,
}

final counterProvider =
    StateNotifierProvider<CounterController, int>((ref) => CounterController());

class CounterController extends StateNotifier<int> {
  CounterController() : super(0);

  void increment() => state++;
  void decrement() => state--;
  void clear() => state = 0;
}

final bmiCalcProvider =
    StateNotifierProvider.autoDispose<BmiCalcController, String>(
  (ref) => BmiCalcController(ref.read),
);

class BmiCalcController extends StateNotifier<String> {
  BmiCalcController(this._read) : super('');

  final Reader _read;

  void calculate(height, weight) {
    double bmi = double.parse(weight) /
        ((double.parse(height) * double.parse(height) / 10000));
    state = bmi.toStringAsFixed(2);
  }

  Future<void> setDb(height, weight) async {
    var bmiHistory = BmiHistoryDatabase(
      result: state,
      height: double.parse(height),
      weight: double.parse(weight),
    );
    await _read(bmiHistoryDbProvider.notifier).insertBmiHistory(bmiHistory);
  }
}

final bmiHistoryProvider = StateNotifierProvider<BmiHistoryController, List>(
    (ref) => BmiHistoryController(ref.read));

class BmiHistoryController extends StateNotifier<List> {
  BmiHistoryController(this._read) : super([]);
  final Reader _read;

  Future<void> getDb() async {
    List aaa = await _read(bmiHistoryDbProvider.notifier).getBmiHistory();
    List bbb = [];
    for (var element in aaa) {
      bbb.add(element.toMap());
    }
    state = bbb;
  }

  Future<void> deleteDb(id) async {
    await _read(bmiHistoryDbProvider.notifier).deleteBmiHistory(id);
  }
}
