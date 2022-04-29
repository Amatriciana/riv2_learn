import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  (ref) => BmiCalcController(),
);

class BmiCalcController extends StateNotifier<String> {
  BmiCalcController() : super('');

  void calculate(height, weight) {
    double bmi = double.parse(weight) /
        ((double.parse(height) * double.parse(height) / 10000));
    state = bmi.toStringAsFixed(2);
  }
}
