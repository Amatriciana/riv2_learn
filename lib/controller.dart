import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riv2_learn/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

// sqflite用プロバイダ
final databaseProvider = Provider<Future<Database>>(
  (ref) => throw UnimplementedError(),
);

// shared_preferences用プロバイダ
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(),
);

// BottomNavigationBar用プロバイダ
final bottomNavProvider =
    StateProvider<BottomNav>((ref) => BottomNav.counterPage);

enum BottomNav {
  counterPage,
  bmiCalcPage,
  bmiHistoryPage,
}

// カウンターアプリ用プロバイダ
final counterProvider = StateNotifierProvider<CounterNotifier, int>(
    (ref) => CounterNotifier(ref.read));

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier(this._read) : super(0);
  final Reader _read;

  void increment() => state++; // カウント加算
  void decrement() => state--; // カウント減産
  void clear() => state = 0; // カウントを0にする

  // shared_preferencesにカウント数を保存
  Future<void> setCounterPrefs() async {
    _read(sharedPreferencesProvider).setInt('count', state);
  }

  // shared_preferencesからカウント数を読み込み
  Future<void> getCounterPrefs() async {
    state = _read(sharedPreferencesProvider).getInt('count') ?? 0;
  }
}

// BMI計算機用プロバイダ
final bmiCalcProvider =
    StateNotifierProvider.autoDispose<BmiCalcNotifier, String>(
  (ref) => BmiCalcNotifier(ref.read),
);

class BmiCalcNotifier extends StateNotifier<String> {
  BmiCalcNotifier(this._read) : super('');

  final Reader _read;

  // BMIを計算し、結果をstateに持たせる
  void calculate(height, weight) {
    double bmi = double.parse(weight) /
        ((double.parse(height) * double.parse(height) / 10000));
    state = bmi.toStringAsFixed(2);
  }

  // 身長、体重、BMIをtableに保存
  Future<void> setDb(height, weight) async {
    var bmiHistory = BmiDatabase(
      result: state,
      height: double.parse(height),
      weight: double.parse(weight),
    );
    await _read(bmiDbProvider.notifier).insertBmiHistory(bmiHistory);
  }
}

// BMI履歴用プロバイダ
final bmiHistoryProvider = StateNotifierProvider<BmiHistoryNotifier, List>(
    (ref) => BmiHistoryNotifier(ref.read));

class BmiHistoryNotifier extends StateNotifier<List> {
  BmiHistoryNotifier(this._read) : super([]);
  final Reader _read;

  // tableからデータを取得、List<Map>型でstateに持たせる
  Future<void> getDb() async {
    List a = await _read(bmiDbProvider.notifier).getBmiHistory();
    List b = [];
    for (var e in a) {
      b.add(e.toMap());
    }
    state = b;
  }

  // tableからデータを削除
  Future<void> deleteDb(id) async {
    await _read(bmiDbProvider.notifier).deleteBmiHistory(id);
  }
}
