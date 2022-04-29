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
